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
            UI::BeginDisabled(API::requesting);
            if (clubs.Length == 0 && GayButton(Icons::Download, 2000))
                startnew(API::GetMyClubsAsync);
            else if (clubs.Length > 0 && UI::Button(Icons::Refresh))
                startnew(API::GetMyClubsAsync);
            UI::EndDisabled();

            UI::EndTable();
        }

#if SIG_DEVELOPER
        UI::BeginDisabled(clubs.Length == 0);
        if (UI::ButtonColored(Icons::Times + " Clear Clubs", 0.0f)) {
            clubs = {};
            activeClubs = {};
        }
        UI::EndDisabled();
#endif
        UI::Separator();

        UI::BeginTabBar("##tabbar");

        Tab_ClubList();
#if SIG_DEVELOPER
        Tab_Debug();
#endif
        // Tabs_Clubs();

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
    if (!UI::BeginTabItem(Icons::Users + " Clubs"))
        return;

    UI::BeginTabBar("##tabbar-clubs");

    if (UI::BeginTabItem(Icons::ListOl + " List")) {
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

                    Textures::Render(club.iconUrlPngSmall, iconSize);

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

    Tabs_Clubs();

    UI::EndTabBar();

    UI::EndTabItem();
}

void Tab_Club(Club@ club) {
    bool open = true;

    int flags = UI::TabItemFlags::None;
    if (activeClubs.FindByRef(club) == activeClubIndex) {
        flags |= UI::TabItemFlags::SetSelected;
        activeClubIndex = -1;
    }

    if (club !is null && UI::BeginTabItem(club.name.stripped + "##" + club.id, open, flags)) {
        if (UI::BeginTable("##table-club-header", 2)) {
            UI::TableSetupColumn("header", UI::TableColumnFlags::WidthStretch);
            UI::TableSetupColumn("role", UI::TableColumnFlags::WidthFixed);

            UI::TableNextRow();

            UI::TableNextColumn();
            UI::PushFont(fontHeader);
            UI::Text(club.name.formatted);
            UI::PopFont();

            UI::TableNextColumn();
            UI::Text("\\$I" + tostring(club.role));

            UI::EndTable();
        }

        const vec2 spaceAvail = UI::GetContentRegionAvail();
        const vec2 childSize = vec2(spaceAvail.x, (spaceAvail.y - scale * 17.0f) * 0.5f);

        if (UI::BeginChild("##child-activities" + club.id, childSize)) {
            if (UI::BeginTable("##table-club-activity-header" + club.id, 2)) {
                UI::TableSetupColumn("header", UI::TableColumnFlags::WidthStretch);
                UI::TableSetupColumn("button", UI::TableColumnFlags::WidthFixed);

                UI::TableNextRow();

                UI::TableNextColumn();
                UI::PushFont(fontSubHeader);
                UI::SeparatorText((club.requestingActivities ? "\\$888" : "") + "Activities (" + club.activityCount + ")");
                UI::PopFont();
                if (club.requestingActivities)
                    HoverTooltip("patience, child...\n" + club.activities.Length + " / " + club.activityCount);

                UI::TableNextColumn();
                UI::BeginDisabled(club.requestingActivities);
                const bool refresh = club.activityCount > 0;
                if (
                    (refresh && UI::Button(Icons::Refresh + "##button-activities" + club.id))
                    || (!refresh && GayButton(Icons::Download + "##button-activities" + club.id, 2000, 0.5f))
                )
                    startnew(CoroutineFunc(club.GetActivitiesAsync));
                UI::EndDisabled();

                UI::EndTable();
            }

            const vec2 childSpaceAvail = UI::GetContentRegionAvail();

            const int cols = 5;
            const int rows = int(Math::Ceil(float(club.activities.Length) / float(cols)));

            if (UI::BeginTable("##table-activities", 5, UI::TableFlags::ScrollY)) {
                for (uint i = 0; i < cols; i++)
                    UI::TableSetupColumn("col" + i, UI::TableColumnFlags::WidthFixed);

                UI::ListClipper clipper(rows);
                while (clipper.Step()) {
                    for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                        UI::TableNextRow();

                        for (uint j = 0; j < 5; j++) {
                            const uint index = i * 5 + j;
                            if (index >= club.activities.Length)
                                break;

                            ClubActivity@ activity;

                            try {
                                @activity = club.activities[index];
                            } catch {
                                warn(getExceptionInfo());
                                throw("club.activities.Length: " + club.activities.Length + " | index: " + index);
                            }

                            UI::TableNextColumn();

                            const float factor = ((childSpaceAvail.x - scale * 49.0f) / 5.0f) / iconSize.x;
                            const vec2 activityIconSize = iconSize * factor;

                            const vec2 pre = UI::GetCursorPos();

                            if (Textures::Load(activity.mediaUrlPngSmall) !is null)
                                Textures::Render(activity.mediaUrlPngSmall, activityIconSize);
                            else
                                Textures::Render("assets/club_blank.png", activityIconSize, true);

                            UI::SetCursorPos(pre);
                            if (UI::InvisibleButton("##invisbutton-activity" + club.id, activityIconSize)) {
                                // const int index = activeClubs.FindByRef(club);
                                // if (index == -1) {
                                //     activeClubIndex = activeClubs.Length;
                                //     activeClubs.InsertLast(@club);
                                // } else
                                //     activeClubIndex = index;
                            }
                            if (UI::IsItemHovered()) {
                                UI::SetCursorPos(pre);

                                Textures::Render(
                                    "assets/1x1_white_alpha" + (UI::IsMouseDown() ? 1 : 2) + "0.png",
                                    activityIconSize,
                                    true
                                );
                            }

                            UI::Text(activity.name.formatted.Replace("|ClubActivity|", ""));
                            UI::Text("\\$888" + tostring(activity.activityType));

                            if (j % 5 == 0)
                                UI::NewLine();
                        }
                    }
                }

                UI::EndTable();
            }
        }
        UI::EndChild();

        if (UI::BeginChild("##child-members" + club.id, childSize)) {
            if (UI::BeginTable("##table-club-member-header" + club.id, 2)) {
                UI::TableSetupColumn("header", UI::TableColumnFlags::WidthStretch);
                UI::TableSetupColumn("button", UI::TableColumnFlags::WidthFixed);

                UI::TableNextRow();

                UI::TableNextColumn();
                UI::PushFont(fontSubHeader);
                UI::SeparatorText((club.requestingMembers ? "\\$888" : "") + "Members (" + club.memberCount + ")");
                UI::PopFont();
                if (club.requestingMembers)
                    HoverTooltip("patience, child...\n" + club.members.Length + " / " + club.memberCount);

                UI::TableNextColumn();
                UI::BeginDisabled(club.requestingMembers);
                const bool refresh = club.activityCount > 0;
                if (
                    (refresh && UI::Button(Icons::Refresh + "##button-members" + club.id))
                    || (!refresh && GayButton(Icons::Download + "##button-members" + club.id, 2000, 0.5f))
                )
                    startnew(CoroutineFunc(club.GetMembersAsync));
                UI::EndDisabled();

                UI::EndTable();
            }

            if (UI::BeginTable("##table-members", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
                UI::PushStyleColor(UI::Col::TableRowBgAlt, colorRowBg);

                UI::TableSetupScrollFreeze(0, 1);
                UI::TableSetupColumn("Name", UI::TableColumnFlags::WidthFixed);
                UI::TableSetupColumn("Role", UI::TableColumnFlags::WidthFixed);
                UI::TableSetupColumn("Since", UI::TableColumnFlags::WidthFixed);

                UI::ListClipper clipper(club.members.Length);
                while (clipper.Step()) {
                    for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                        ClubMember@ member = club.members[i];

                        UI::TableNextRow();

                        UI::TableNextColumn();
                        UI::Text(member.name + (member.vip ? "  " + Icons::UserPlus : ""));

                        UI::TableNextColumn();
                        UI::Text(
                            (member.role == ClubRole::ContentCreator ? "Content Creator" : tostring(member.role))
                            + (member.vip ? " - VIP" : "")
                        );

                        UI::TableNextColumn();
                        UI::Text(Time::FormatString("%Y-%m-%d", member.timestamp));
                    }
                }

                UI::PopStyleColor();
                UI::EndTable();
            }
        }
        UI::EndChild();

        UI::EndTabItem();
    }

    if (!open) {
        for (uint i = 0; i < activeClubs.Length; i++) {
            if (activeClubs[i].id == club.id) {
                activeClubs.RemoveAt(i);
                break;
            }
        }
    }
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

void Tabs_Clubs() {
    for (uint i = 0; i < activeClubs.Length; i++)
        Tab_Club(activeClubs[i]);
}
