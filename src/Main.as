// c 2024-10-08
// m 2024-10-11

int activeClubIndex = -1;
Club@[] activeClubs;
bool clubAccess = false;
Club@[] clubs;
const vec4 colorRowBg = vec4(vec3(0.0f), 0.5f);
UI::Font@ fontHeader;
UI::Font@ fontSubHeader;
const string pluginColor = "\\$0B9";
const string pluginIcon  = Icons::Users;
Meta::Plugin@ pluginMeta = Meta::ExecutingPlugin();
const string pluginTitle = pluginColor + pluginIcon + "\\$G " + pluginMeta.Name;
const float scale = UI::GetScale();
bool showClearConfirmation = false;
const vec2 iconSize = scale * vec2(154.0f, 69.0f);

void Main() {
    if (!(clubAccess = Permissions::CreateClub())) {
        const string msg = "This plugin requires club access.";
        warn(msg);
        UI::ShowNotification(pluginTitle, msg, vec4(1.0f, 0.3f, 0.0f, 1.0f));
        return;
    }

    @fontSubHeader = UI::LoadFont("DroidSans.ttf", 20);
    @fontHeader    = UI::LoadFont("DroidSans.ttf", 26);

    if (S_AutoGetClubs)
        startnew(API::GetMyClubsAsync);
}

void Render() {
    if (false
        || !clubAccess
        || !S_Enabled
        || (S_HideWithGame && !UI::IsGameUIVisible())
        || (S_HideWithOP && !UI::IsOverlayShown())
    )
        return;

    if (UI::Begin(pluginTitle, S_Enabled, UI::WindowFlags::None)) {
        if (UI::BeginTable("##table-header", 2)) {
            UI::TableSetupColumn("header", UI::TableColumnFlags::WidthStretch);
            UI::TableSetupColumn("button", UI::TableColumnFlags::WidthFixed);

            UI::TableNextRow();

            UI::TableNextColumn();
            UI::PushFont(fontSubHeader);
            UI::Text("You are a member of \\$FA0" + clubs.Length + "\\$G clubs!");
            UI::PopFont();

            UI::TableNextColumn();
            UI::BeginDisabled(clubs.IsEmpty());
            if (showClearConfirmation) {
                if (UI::Button(Icons::Times + " Are you sure?"))
                    ClearClubs();
                if (UI::IsItemHovered()) {
                    if (UI::IsMouseReleased(UI::MouseButton::Right))
                        showClearConfirmation = false;

                    HoverTooltip("right-click to cancel");
                }
            } else if (UI::ButtonColored(Icons::Trash, 0.0f))
                showClearConfirmation = true;
            UI::EndDisabled();

            UI::SameLine();
            UI::BeginDisabled(API::requesting);
            if (clubs.Length == 0 && GayButton(Icons::Download, 2000))
                startnew(API::GetMyClubsAsync);
            else if (clubs.Length > 0 && UI::Button(Icons::Refresh))
                startnew(API::GetMyClubsAsync);
            UI::EndDisabled();

            UI::EndTable();
        }

        UI::BeginTabBar("##tabbar");

        Tab_Clubs();

#if SIG_DEVELOPER
        Tab_Debug();
#endif

        for (uint i = 0; i < activeClubs.Length; i++)
            activeClubs[i].RenderTabSelf();

        UI::EndTabBar();
    }
    UI::End();
}

void RenderMenu() {
    if (!clubAccess)
        return;

    if (UI::MenuItem(pluginTitle, "", S_Enabled))
        S_Enabled = !S_Enabled;
}

void ClearActiveClubs() {
    while (activeClubs.Length > 0) {
        activeClubs[0].ClearActiveActivities();
        @activeClubs[0] = null;
        activeClubs.RemoveAt(0);
    }
}

void ClearClubs() {
    ClearActiveClubs();

    while (clubs.Length > 0) {
        clubs[0].ClearActiveActivities();
        @clubs[0] = null;
        clubs.RemoveAt(0);
    }

    showClearConfirmation = false;
}

void Tab_Clubs() {
    if (!UI::BeginTabItem(Icons::Users + " My Clubs"))
        return;

    float nameWidth = 0.0f;
    for (uint i = 0; i < clubs.Length; i++)
        nameWidth = Math::Max(nameWidth, Draw::MeasureString(clubs[i].name.formatted, fontHeader).x);

    if (UI::BeginTable("##table-clubs", 5, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, colorRowBg);

        UI::TableSetupColumn("icon", UI::TableColumnFlags::WidthFixed);
        UI::TableSetupColumn("name", UI::TableColumnFlags::WidthFixed, scale * nameWidth * 1.5f);
        UI::TableSetupColumn("role", UI::TableColumnFlags::WidthFixed, scale * 100.0f);
        UI::TableSetupColumn("counts", UI::TableColumnFlags::WidthStretch);
        UI::TableSetupColumn("buttons", UI::TableColumnFlags::WidthFixed, scale * 40.0f);

        UI::ListClipper clipper(clubs.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                Club@ club = clubs[i];

                UI::TableNextRow();
                UI::TableNextColumn();

                const vec2 pre = UI::GetCursorPos();

                if (Textures::Load(club.iconUrlPngSmall) !is null)
                    Textures::Render(club.iconUrlPngSmall, iconSize);
                else
                    Textures::Render("assets/club_blank.png", iconSize, true);

                UI::SetCursorPos(pre);
                if (UI::InvisibleButton("##invisbutton" + club.id, iconSize)) {
                    const int index = activeClubs.FindByRef(club);

                    if (index == -1) {
                        activeClubIndex = activeClubs.Length;
                        activeClubs.InsertLast(@club);

                        if (S_AutoGetActivities)
                            startnew(CoroutineFunc(club.GetActivitiesAsync));

                        if (S_AutoGetMembers)
                            startnew(CoroutineFunc(club.GetMembersAsync));
                    } else
                        activeClubIndex = index;
                }
                // HoverTooltip(Icons::Eye + " View Club");
                if (UI::IsItemHovered()) {
                    UI::SetCursorPos(pre);

                    Textures::Render(
                        "assets/1x1_white_alpha" + (UI::IsMouseDown() ? 1 : 2) + "0.png",
                        iconSize,
                        true
                    );
                }

                UI::PushFont(fontHeader);

                UI::TableNextColumn();
                UI::Text(club.name.formatted);

                UI::PopFont();

                UI::TableNextColumn();
                UI::Text("\\$I" + tostring(club.role));

                UI::TableNextColumn();

                UI::Text("\\$I" + (club.requestingActivities ? "\\$888" : "") + club.activityCount + " activit" + (club.activityCount == 1 ? "y" : "ies"));
                if (club.activityCount > 0) {
                    if (club.requestingActivities)
                        HoverTooltip("patience, child...\n" + club.activities.Length + " / " + club.activityCount);
                    else {
                        string msg;

                        for (uint j = 0; j < club.activities.Length; j++) {
                            if (j == 20) {
                                msg += "...";
                                break;
                            }

                            msg += (club.activities[j].name.stripped) + "\n";
                        }

                        HoverTooltip(msg);
                    }
                }

                UI::Text("\\$I" + (club.requestingMembers ? "\\$888" : "") + club.memberCount + " member" + (club.memberCount == 1 ? "" : "s"));
                if (club.memberCount > 0) {
                    if (club.requestingMembers)
                        HoverTooltip("patience, child...\n" + club.members.Length + " / " + club.memberCount);
                    else {
                        string msg;

                        for (uint j = 0; j < club.members.Length; j++) {
                            if (j == 20) {
                                msg += "...";
                                break;
                            }

                            msg += (club.members[j].name) + "\n";
                        }

                        HoverTooltip(msg);
                    }
                }

                UI::TableNextColumn();
                UI::BeginDisabled(club.requesting);
                const bool refresh = club.activityCount + club.memberCount > 0;

                if (
                    (refresh && UI::Button(Icons::Refresh + "##button" + club.id))
                    || (!refresh && GayButton(Icons::Download + "##button" + club.id, 3000, 1.0f - ((i % 10) * 0.1f)))
                ) {
                    startnew(CoroutineFunc(club.GetActivitiesAsync));
                    startnew(CoroutineFunc(club.GetMembersAsync));
                }
                UI::EndDisabled();
            }
        }

        UI::PopStyleColor();
        UI::EndTable();
    }

    UI::EndTabItem();
}

void Tab_Debug() {
    if (!UI::BeginTabItem(Icons::Bug + " Debug"))
        return;

    UI::Text("clubs: " + clubs.Length);

    // if (UI::BeginTable("##table-debug"))

    // for (uint row = 0; row < 10; row++) {
    //     for (uint col = 0; col < 10; col++) {
    //         GayButton(
    //             "   ",
    //             1000,
    //             1.0f - 0.008f * (row * 10 + col)
    //         );
    //         UI::SameLine();
    //     }
    //     UI::NewLine();
    // }

    UI::EndTabItem();
}
