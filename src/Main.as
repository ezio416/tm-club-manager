// c 2024-09-27
// m 2024-09-27

Club@        activeClub;
Club@[]      clubs;
bool         getting            = false;
bool         hasClub            = false;
const float  scale              = UI::GetScale();
bool         switchToActiveClub = false;
const string title              = "\\$0B9" + Icons::Random + "\\$G Mixed Club Campaigns";
string[]     uids;

void Main() {
    hasClub = Permissions::CreateClub();

    if (!hasClub) {
        const string msg = "This plugin requires club access.";
        warn(msg);
        UI::ShowNotification(title, msg, vec4(1.0f, 0.3f, 0.0f, 1.0f));
        return;
    }

    NadeoServices::AddAudience(API::audienceLive);
}

void Render() {
    if (false
        || !hasClub
        || !S_Enabled
        || (S_HideWithGame && !UI::IsGameUIVisible())
        || (S_HideWithOP && !UI::IsOverlayShown())
    )
        return;

    if (UI::Begin(title, S_Enabled, UI::WindowFlags::None)) {
        UI::BeginTabBar("tab-bar");
            if (UI::BeginTabItem(Icons::ListUl + " Club List")) {
                UI::BeginDisabled(getting);
                if (UI::Button(Icons::Download + " Get My Clubs"))
                    startnew(API::GetMyClubsAsync);
                UI::EndDisabled();

                UI::SameLine();
                UI::Text("Clubs: " + clubs.Length);

                if (UI::BeginTable("##table-clubs", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
                    UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

                    UI::TableSetupScrollFreeze(0, 1);
                    UI::TableSetupColumn("name");
                    UI::TableSetupColumn("id",    UI::TableColumnFlags::WidthFixed, scale * 50.0f);
                    UI::TableSetupColumn("admin", UI::TableColumnFlags::WidthFixed, scale * 50.0f);
                    UI::TableHeadersRow();

                    UI::ListClipper clipper(clubs.Length);
                    while (clipper.Step()) {
                        for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                            Club@ club = clubs[i];

                            UI::TableNextRow();

                            UI::TableNextColumn();
                            if (UI::Selectable(club.nameFormatted, false, UI::SelectableFlags::SpanAllColumns)) {
                                @activeClub = @club;
                                switchToActiveClub = true;
                            }

                            UI::TableNextColumn();
                            UI::Text(tostring(club.id));

                            UI::TableNextColumn();
                            UI::Text(tostring(club.admin));
                        }
                    }

                    UI::PopStyleColor();
                    UI::EndTable();
                }

                UI::EndTabItem();
            }

            if (activeClub !is null) {
                bool open = true;

                if (UI::BeginTabItem(activeClub.nameFormatted, open, switchToActiveClub ? UI::TabItemFlags::SetSelected : UI::TabItemFlags::None)) {
                    UI::Text(activeClub.nameStripped);
                    UI::Separator();

                    ;

                    UI::EndTabItem();
                }

                if (!open)
                    @activeClub = null;
            }

        UI::EndTabBar();
    }
    UI::End();
}

void RenderMenu() {
    if (!hasClub)
        return;

    if (UI::MenuItem(title, "", S_Enabled))
        S_Enabled = !S_Enabled;
}
