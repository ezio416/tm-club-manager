// c 2024-10-08
// m 2024-10-10

bool clubAccess = false;
Club@[] clubs;
UI::Font@ fontHeader;
UI::Font@ fontSubHeader;
const string pluginColor = "\\$0B9";
const string pluginIcon  = Icons::Users;
Meta::Plugin@ pluginMeta = Meta::ExecutingPlugin();
const string pluginTitle = pluginColor + pluginIcon + "\\$G " + pluginMeta.Name;
const float scale = UI::GetScale();
const vec2 iconSize = scale * vec2(154.0f, 69.0f);

void Main() {
    if ((clubAccess = Permissions::CreateClub())) {
        @fontSubHeader = UI::LoadFont("DroidSans.ttf", 20);
        @fontHeader    = UI::LoadFont("DroidSans.ttf", 26);

        return;
    }

    const string msg = "This plugin requires club access.";
    warn(msg);
    UI::ShowNotification(pluginTitle, msg, vec4(1.0f, 0.3f, 0.0f, 1.0f));
    return;
}

void Render() {
    if (false || !clubAccess || !S_Enabled || (S_HideWithGame && !UI::IsGameUIVisible()) || (S_HideWithOP && !UI::IsOverlayShown()))
        return;

    if (UI::Begin(pluginTitle, S_Enabled, UI::WindowFlags::None)) {
        UI::PushFont(fontSubHeader);
        UI::AlignTextToFramePadding();
        UI::Text(Icons::Kenney::Star + " You are a member of \\$FA0" + clubs.Length + "\\$G clubs!");
        UI::PopFont();

        UI::SameLine();
        UI::BeginDisabled(API::requesting);
        if (clubs.Length == 0 && GayButton(Icons::Download + " Get My Clubs", 2000))
            startnew(API::GetMyClubsAsync);
        else if (clubs.Length > 0 && UI::Button(Icons::Refresh + " Refresh Clubs"))
            startnew(API::GetMyClubsAsync);
        UI::EndDisabled();

#if SIG_DEVELOPER
        UI::BeginDisabled(clubs.Length == 0);
        if (UI::ButtonColored(Icons::Times + " Clear Clubs", 0.0f))
            clubs = {};
        UI::EndDisabled();
#endif
        UI::Separator();

        UI::BeginTabBar("##tabbar");

        Tab_ClubList();
        Tab_Debug();

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

void Tab_ClubList() {
    if (!UI::BeginTabItem(Icons::ListOl + " Club List"))
        return;

    float nameWidth = 0.0f;
    for (uint i = 0; i < clubs.Length; i++)
        nameWidth = Math::Max(nameWidth, Draw::MeasureString(clubs[i].name.formatted, fontHeader).x);

    if (UI::BeginTable("##table-clubs", 4, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(vec3(0.0f), 0.5f));

        UI::TableSetupColumn("icon", UI::TableColumnFlags::WidthFixed);
        UI::TableSetupColumn("name", UI::TableColumnFlags::WidthFixed, scale * nameWidth * 1.5f);
        UI::TableSetupColumn("role", UI::TableColumnFlags::WidthFixed, scale * 100.0f);
        UI::TableSetupColumn("members", UI::TableColumnFlags::WidthStretch);

        UI::ListClipper clipper(clubs.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                Club@ club = clubs[i];

                UI::TableNextRow();

                UI::TableNextColumn();
                UI::Texture@ icon = Textures::Get(club.iconUrlPngSmall);
                if (icon !is null)
                    UI::Image(icon, iconSize);
                else
                    UI::Dummy(iconSize);

                UI::PushFont(fontHeader);

                UI::TableNextColumn();
                UI::AlignTextToFramePadding();
                UI::Text(club.name.formatted);

                UI::PopFont();

                UI::TableNextColumn();
                UI::Text("\\$I" + tostring(club.role));

                UI::TableNextColumn();
                UI::Text("\\$I" + (club.requesting ? "\\$888" : "") + club.memberCount + " member" + (club.memberCount == 1 ? "" : "s"));
                if (club.memberCount > 0) {
                    if (club.requesting)
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

                UI::SameLine();
                UI::BeginDisabled(club.requesting);

                if (
                    (club.memberCount > 0 && UI::Button(Icons::Refresh + "##button-getmembers" + club.id))
                    || (club.memberCount == 0 && GayButton(Icons::Download + "##button-getmembers" + club.id, 3000, 1.0f - ((i % 10) * 0.1f)))
                )
                    startnew(CoroutineFunc(club.GetMembersAsync));

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
