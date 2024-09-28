// c 2024-09-27
// m 2024-09-27

Campaign@    activeCampaign;
Club@        activeClub;
Club@[]      clubs;
bool         clubAccess             = false;
const float  scale                  = UI::GetScale();
bool         switchToActiveCampaign = false;
bool         switchToActiveClub     = false;
const string title                  = "\\$0B9" + Icons::Random + "\\$G Mixed Club Campaigns";
string[]     uids;

void Main() {
    clubAccess = Permissions::CreateClub();

    if (!clubAccess) {
        const string msg = "This plugin requires club access.";
        warn(msg);
        UI::ShowNotification(title, msg, vec4(1.0f, 0.3f, 0.0f, 1.0f));
        return;
    }

    NadeoServices::AddAudience(API::audienceLive);
}

void Render() {
    if (false
        || !clubAccess
        || !S_Enabled
        || (S_HideWithGame && !UI::IsGameUIVisible())
        || (S_HideWithOP && !UI::IsOverlayShown())
    )
        return;

    if (UI::Begin(title, S_Enabled, UI::WindowFlags::None)) {
        UI::BeginTabBar("tabbar-main");
            if (UI::BeginTabItem(Icons::ListUl + " Club List")) {
                UI::BeginDisabled(API::getting);
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
                                @activeCampaign = null;
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

                int flags = UI::TabItemFlags::None;
                if (switchToActiveClub) {
                    flags |= UI::TabItemFlags::SetSelected;
                    switchToActiveClub = false;
                }

                if (UI::BeginTabItem(activeClub.nameFormatted, open, flags)) {
                    UI::BeginDisabled(API::getting || activeClub.getting);
                    if (UI::Button(Icons::Download + " Get Campaigns"))
                        startnew(CoroutineFunc(activeClub.GetCampaignsAsync));
                    UI::EndDisabled();

                    UI::SameLine();
                    UI::Text("Campaigns: " + activeClub.campaigns.Length);

                    if (UI::BeginTable("##table-campaigns", 2, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
                        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

                        UI::TableSetupScrollFreeze(0, 1);
                        UI::TableSetupColumn("name");
                        UI::TableSetupColumn("id", UI::TableColumnFlags::WidthFixed, scale * 50.0f);
                        UI::TableHeadersRow();

                        UI::ListClipper clipper(activeClub.campaigns.Length);
                        while (clipper.Step()) {
                            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                                Campaign@ campaign = activeClub.campaigns[i];

                                UI::TableNextRow();

                                UI::TableNextColumn();
                                if (UI::Selectable(campaign.nameFormatted, false, UI::SelectableFlags::SpanAllColumns)) {
                                    @activeCampaign = @campaign;
                                    switchToActiveCampaign = true;
                                }

                                UI::TableNextColumn();
                                UI::Text(tostring(campaign.id));
                            }
                        }

                        UI::PopStyleColor();
                        UI::EndTable();
                    }

                    UI::EndTabItem();
                }

                if (!open) {
                    @activeCampaign = null;
                    @activeClub = null;
                }
            }

            if (activeCampaign !is null) {
                bool open = true;

                int flags = UI::TabItemFlags::None;
                if (switchToActiveCampaign) {
                    flags |= UI::TabItemFlags::SetSelected;
                    switchToActiveCampaign = false;
                }

                if (UI::BeginTabItem(activeCampaign.nameFormatted, open, flags)) {
                    UI::Text(activeCampaign.nameStripped);

                    UI::EndTabItem();
                }

                if (!open)
                    @activeCampaign = null;
            }

        UI::EndTabBar();
    }
    UI::End();
}

void RenderMenu() {
    if (!clubAccess)
        return;

    if (UI::MenuItem(title, "", S_Enabled))
        S_Enabled = !S_Enabled;
}
