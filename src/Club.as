enum ClubRole {
    Admin,
    ContentCreator,
    Creator,
    Member,
    Unknown = 5
}

enum ClubState {
    Private,
    Public,
    Unknown = 3
}

class Club {
    string authorAccountId;
    string backgroundTheme;
    string backgroundUrl;
    string backgroundUrlDds;
    string backgroundUrlJpgLarge;
    string backgroundUrlJpgMedium;
    string backgroundUrlJpgSmall;
    int64  creationTimestamp = -1;
    string decalSponsor4x1Url;
    string decalSponsor4x1UrlDds;
    string decalSponsor4x1UrlPngLarge;
    string decalSponsor4x1UrlPngMedium;
    string decalSponsor4x1UrlPngSmall;
    string decalTheme;
    string decalUrl;
    string decalUrlDds;
    string decalUrlPngLarge;
    string decalUrlPngMedium;
    string decalUrlPngSmall;
    string description;
    int64  editionTimestamp = -1;
    bool   featured         = false;
    string iconTheme;
    string iconUrl;
    string iconUrlDds;
    string iconUrlPngLarge;
    string iconUrlPngMedium;
    string iconUrlPngSmall;
    int    id = -1;
    string latestEditorAccountId;
    string logoUrl;
    string metadata;
    FormattedString@ name;
    int       popularityLevel = -1;
    ClubRole  role            = ClubRole::Unknown;
    string    screen16x1Theme;
    string    screen16x1Url;
    string    screen16x1UrlDds;
    string    screen16x1UrlPngLarge;
    string    screen16x1UrlPngMedium;
    string    screen16x1UrlPngSmall;
    string    screen64x41Theme;
    string    screen64x41Url;
    string    screen64x41UrlDds;
    string    screen64x41UrlPngLarge;
    string    screen64x41UrlPngMedium;
    string    screen64x41UrlPngSmall;
    string    screen16x9Theme;
    string    screen16x9Url;
    string    screen16x9UrlDds;
    string    screen16x9UrlPngLarge;
    string    screen16x9UrlPngMedium;
    string    screen16x9UrlPngSmall;
    string    screen8x1Theme;
    string    screen8x1Url;
    string    screen8x1UrlDds;
    string    screen8x1UrlPngLarge;
    string    screen8x1UrlPngMedium;
    string    screen8x1UrlPngSmall;
    ClubState state = ClubState::Unknown;
    FormattedString@ tag;
    bool   verified = false;
    string verticalTheme;
    string verticalUrl;
    string verticalUrlDds;
    string verticalUrlPngLarge;
    string verticalUrlPngMedium;
    string verticalUrlPngSmall;
    string walletUid;

    ClubActivity@[] activeActivities;
    int activeActivityIndex = -1;
    ClubActivity@[] activities;
    uint activityCount = 0;
    bool requestingActivities = false;

    uint memberCount = 0;
    ClubMember@[] members;
    bool requestingMembers = false;

    bool get_requesting() {
        return requestingActivities || requestingMembers;
    }

    Club(Json::Value@ json) {
        if (!JsonExt::CheckType(json))
            throw("can't initialize Club");

        authorAccountId             = JsonExt::GetString(json, "authorAccountId");
        backgroundTheme             = JsonExt::GetString(json, "backgroundTheme");
        backgroundUrl               = JsonExt::GetString(json, "backgroundUrl");
        backgroundUrlDds            = JsonExt::GetString(json, "backgroundUrlDds");
        backgroundUrlJpgLarge       = JsonExt::GetString(json, "backgroundUrlJpgLarge");
        backgroundUrlJpgMedium      = JsonExt::GetString(json, "backgroundUrlJpgMedium");
        backgroundUrlJpgSmall       = JsonExt::GetString(json, "backgroundUrlJpgSmall");
        creationTimestamp           = JsonExt::GetInt64(json, "creationTimestamp");
        decalSponsor4x1Url          = JsonExt::GetString(json, "decalSponsor4x1Url");
        decalSponsor4x1UrlDds       = JsonExt::GetString(json, "decalSponsor4x1UrlDds");
        decalSponsor4x1UrlPngLarge  = JsonExt::GetString(json, "decalSponsor4x1UrlPngLarge");
        decalSponsor4x1UrlPngMedium = JsonExt::GetString(json, "decalSponsor4x1UrlPngMedium");
        decalSponsor4x1UrlPngSmall  = JsonExt::GetString(json, "decalSponsor4x1UrlPngSmall");
        decalTheme                  = JsonExt::GetString(json, "decalTheme");
        decalUrl                    = JsonExt::GetString(json, "decalUrl");
        decalUrlDds                 = JsonExt::GetString(json, "decalUrlDds");
        decalUrlPngLarge            = JsonExt::GetString(json, "decalUrlPngLarge");
        decalUrlPngMedium           = JsonExt::GetString(json, "decalUrlPngMedium");
        decalUrlPngSmall            = JsonExt::GetString(json, "decalUrlPngSmall");
        description                 = JsonExt::GetString(json, "description");
        editionTimestamp            = JsonExt::GetInt64(json, "editionTimestamp");
        featured                    = JsonExt::GetBool(json, "featured");
        iconTheme                   = JsonExt::GetString(json, "iconTheme");
        iconUrl                     = JsonExt::GetString(json, "iconUrl");
        iconUrlDds                  = JsonExt::GetString(json, "iconUrlDds");
        iconUrlPngLarge             = JsonExt::GetString(json, "iconUrlPngLarge");
        iconUrlPngMedium            = JsonExt::GetString(json, "iconUrlPngMedium");
        iconUrlPngSmall             = JsonExt::GetString(json, "iconUrlPngSmall");
        id                          = JsonExt::GetInt(json, "id");
        latestEditorAccountId       = JsonExt::GetString(json, "latestEditorAccountId");
        logoUrl                     = JsonExt::GetString(json, "logoUrl");
        metadata                    = JsonExt::GetString(json, "metadata");
        @name                       = FormattedString(JsonExt::GetString(json, "name"));
        popularityLevel             = JsonExt::GetInt(json, "popularityLevel");
        role                        = GetClubRole(JsonExt::GetString(json, "role"));
        screen16x1Theme             = JsonExt::GetString(json, "screen16x1Theme");
        screen16x1Url               = JsonExt::GetString(json, "screen16x1Url");
        screen16x1UrlDds            = JsonExt::GetString(json, "screen16x1UrlDds");
        screen16x1UrlPngLarge       = JsonExt::GetString(json, "screen16x1UrlPngLarge");
        screen16x1UrlPngMedium      = JsonExt::GetString(json, "screen16x1UrlPngMedium");
        screen16x1UrlPngSmall       = JsonExt::GetString(json, "screen16x1UrlPngSmall");
        screen64x41Theme            = JsonExt::GetString(json, "screen64x41Theme");
        screen64x41Url              = JsonExt::GetString(json, "screen64x41Url");
        screen64x41UrlDds           = JsonExt::GetString(json, "screen64x41UrlDds");
        screen64x41UrlPngLarge      = JsonExt::GetString(json, "screen64x41UrlPngLarge");
        screen64x41UrlPngMedium     = JsonExt::GetString(json, "screen64x41UrlPngMedium");
        screen64x41UrlPngSmall      = JsonExt::GetString(json, "screen64x41UrlPngSmall");
        screen16x9Theme             = JsonExt::GetString(json, "screen16x9Theme");
        screen16x9Url               = JsonExt::GetString(json, "screen16x9Url");
        screen16x9UrlDds            = JsonExt::GetString(json, "screen16x9UrlDds");
        screen16x9UrlPngLarge       = JsonExt::GetString(json, "screen16x9UrlPngLarge");
        screen16x9UrlPngMedium      = JsonExt::GetString(json, "screen16x9UrlPngMedium");
        screen16x9UrlPngSmall       = JsonExt::GetString(json, "screen16x9UrlPngSmall");
        screen8x1Theme              = JsonExt::GetString(json, "screen8x1Theme");
        screen8x1Url                = JsonExt::GetString(json, "screen8x1Url");
        screen8x1UrlDds             = JsonExt::GetString(json, "screen8x1UrlDds");
        screen8x1UrlPngLarge        = JsonExt::GetString(json, "screen8x1UrlPngLarge");
        screen8x1UrlPngMedium       = JsonExt::GetString(json, "screen8x1UrlPngMedium");
        screen8x1UrlPngSmall        = JsonExt::GetString(json, "screen8x1UrlPngSmall");

        const string _state = JsonExt::GetString(json, "state");
        if (_state == "private")
            state = ClubState::Private;
        else if (_state == "public")
            state = ClubState::Public;

        @tag                 = FormattedString(JsonExt::GetString(json, "tag"));
        verified             = JsonExt::GetBool(json, "verified");
        verticalTheme        = JsonExt::GetString(json, "verticalTheme");
        verticalUrl          = JsonExt::GetString(json, "verticalUrl");
        verticalUrlDds       = JsonExt::GetString(json, "verticalUrlDds");
        verticalUrlPngLarge  = JsonExt::GetString(json, "verticalUrlPngLarge");
        verticalUrlPngMedium = JsonExt::GetString(json, "verticalUrlPngMedium");
        verticalUrlPngSmall  = JsonExt::GetString(json, "verticalUrlPngSmall");
        walletUid            = JsonExt::GetString(json, "walletUid");
    }

    void ClearActiveActivities() {
        while (activeActivities.Length > 0) {
            @activeActivities[0] = null;
            activeActivities.RemoveAt(0);
        }
    }

    void GetActivitiesAsync() {
        while (requestingActivities)
            yield();

        requestingActivities = true;

        trace("getting activities in club: " + name.stripped);

        activities = {};

        int        itemCount = -1;
        const uint length    = 160;  // game's default?
        int        max       = 0;
        int        maxPage   = -1;
        uint       min       = 0;
        uint       offset    = 0;

        for (int i = 0; i != maxPage; i++) {
            min = activities.Length + 1;
            if (itemCount > -1)
                max = Math::Min(min + length - 1, itemCount);

            const bool fetchingOne = int(min) + 1 == itemCount;

            trace(
                "\\$I" + name.stripped + "\\$I | getting activit" + (fetchingOne ? "y" : "ies") + ": " + min
                + (fetchingOne ? "" : "-" + (max > 0 ? max : length))
                + " / " + (itemCount > -1 ? tostring(itemCount) : "?????")
            );

            Net::HttpRequest@ req = API::GetLiveAsync(
                "/api/token/club/" + id + "/activity?length=" + length + "&offset=" + offset
                + (role == ClubRole::Admin ? "" : "&active=true")
            );

            Json::Value@ json = req.Json();

            if (JsonExt::CheckType(json)) {
                if (json.HasKey("itemCount")) {
                    itemCount = JsonExt::GetInt(json, "itemCount");

                    if (activityCount == 0)
                        activityCount = itemCount;
                } else {
                    warn("missing key 'itemCount'");
                    break;
                }

                if (json.HasKey("maxPage")) {
                    maxPage = JsonExt::GetInt(json, "maxPage");
                } else {
                    warn("missing key 'maxPage'");
                    break;
                }

                Json::Value@ activityList = JsonExt::GetValue(json, "activityList", Json::Type::Array);
                if (activityList !is null) {
                    if (activityList.Length == 0)
                        break;

                    for (uint j = 0; j < activityList.Length; j++) {
                        try {
                            ClubActivity@ activity = ClubActivity(activityList[j]);
                            if (activity.type == ActivityType::Campaign) {
                                @activity = null;
                                ClubCampaign@ campaign = ClubCampaign(activityList[j]);
                                @campaign.clubName = name;
                                @campaign.parent = this;
                                activities.InsertLast(@campaign);
                                continue;
                            }
                            @activity.parent = this;
                            activities.InsertLast(@activity);
                        } catch {
                            warn(getExceptionInfo());
                        }
                    }

                } else {
                    warn("something went wrong while getting club activities");
                    // print("code: " + req.ResponseCode() + " | " + Json::Write(json));
                    break;
                }
            }
        }

        trace("got " + activities.Length + " activities in club: " + name.stripped);

        requestingActivities = false;
    }

    void GetMembersAsync() {
        while (requestingMembers)
            yield();

        requestingMembers = true;

        trace("getting members in club: " + name.stripped);

        members = {};

        int        itemCount = -1;
        const uint length    = 250;  // maximum allowed
        int        max       = 0;
        int        maxPage   = -1;
        uint       min       = 0;
        uint       offset    = 0;

        for (int i = 0; i != maxPage; i++) {
            min = members.Length + 1;
            if (itemCount > -1)
                max = Math::Min(min + length - 1, itemCount);

            const bool fetchingOne = int(min) + 1 == itemCount;

            trace(
                "\\$I" + name.stripped + "\\$I | getting member" + (fetchingOne ? "" : "s") + ": " + min
                + (fetchingOne ? "" : "-" + (max > 0 ? max : length))
                + " / " + (itemCount > -1 ? tostring(itemCount) : "?????")
            );

            Net::HttpRequest@ req = API::GetLiveAsync("/api/token/club/" + id + "/member?length=" + length + "&offset=" + offset);

            Json::Value@ json = req.Json();

            if (JsonExt::CheckType(json)) {
                if (json.HasKey("itemCount")) {
                    itemCount = JsonExt::GetInt(json, "itemCount");

                    if (memberCount == 0)
                        memberCount = itemCount;
                } else {
                    warn("missing key 'itemCount'");
                    break;
                }

                if (json.HasKey("maxPage")) {
                    maxPage = JsonExt::GetInt(json, "maxPage");
                } else {
                    warn("missing key 'maxPage'");
                    break;
                }

                Json::Value@ memberList = JsonExt::GetValue(json, "clubMemberList", Json::Type::Array);
                if (memberList !is null) {
                    if (memberList.Length == 0)
                        break;

                    for (uint j = 0; j < memberList.Length; j++) {
                        try {
                            members.InsertLast(ClubMember(memberList[j]));
                            // print("inserted member " + members.Length);
                        } catch {
                            warn(getExceptionInfo());
                        }
                    }

                } else {
                    warn("something went wrong while getting club members");
                    // print("code: " + req.ResponseCode() + " | " + Json::Write(json));
                    break;
                }
            }

            offset += length;
        }

        accounts.Refresh();

        trace("got " + members.Length + " members in club: " + name.stripped);

        requestingMembers = false;
    }

    void RenderTabActivity(ClubActivity@ activity) {
        bool open = true;

        int flags = UI::TabItemFlags::None;
        if (activeActivities.FindByRef(activity) == activeActivityIndex) {
            flags |= UI::TabItemFlags::SetSelected;
            activeActivityIndex = -1;
        }

        if (UI::BeginTabItem(activity.name.stripped + "##" + activity.id, open, flags)) {
            if (UI::BeginTable("##table-activity-header", 2)) {
                UI::TableSetupColumn("name", UI::TableColumnFlags::WidthStretch);
                UI::TableSetupColumn("type", UI::TableColumnFlags::WidthFixed);

                UI::TableNextRow();

                UI::TableNextColumn();
                UI::PushFont(fontHeader);
                UI::Text(activity.name.formatted);
                UI::PopFont();

                UI::TableNextColumn();
                UI::Text("\\$I" + tostring(activity.type));

                UI::EndTable();
            }

            if (UI::BeginTable("##table-activity-info-header" + activity.id, 2)) {
                UI::TableSetupColumn("header", UI::TableColumnFlags::WidthStretch);
                UI::TableSetupColumn("button", UI::TableColumnFlags::WidthFixed);

                UI::TableNextRow();

                UI::TableNextColumn();
                UI::SeparatorText("Info");

                UI::TableNextColumn();
                UI::Button(Icons::ExclamationTriangle);

                UI::EndTable();
            }

            UI::Text("id: " + activity.id);
            UI::Text("active: " + activity.active);
            UI::Text("items: " + activity.itemsCount);
            UI::Text("public: " + activity.public);

            if (activity.type == ActivityType::Campaign)
                RenderActivityCampaign(activity);

            UI::EndTabItem();
        }

        if (!open) {
            const int index = activeActivities.FindByRef(activity);
            if (index > -1)
                activeActivities.RemoveAt(index);
            // for (uint i = 0; i < activeActivities.Length; i++) {
            //     if (activeActivities[i].id == id) {
            //         activeActivities.RemoveAt(i);
            //         break;
            //     }
            // }
        }
    }

    void RenderActivityCampaign(ClubActivity@ activity) {
        if (activity.type != ActivityType::Campaign)
            return;

        UI::Separator();

        ClubCampaign@ campaign = cast<ClubCampaign@>(activity);
        if (campaign is null)
            return;

        UI::Text("it's a campaign!");
        UI::Text(campaign.clubName.stripped);
        UI::Text(campaign.creatorAccountId);
        UI::Text(tostring(campaign.maps.Length));

        int index = -1;

        for (uint i = 0; i < 5; i++) {
            if (i > 0 && i % 5 > 0)
                UI::SameLine();

            for (uint j = 0; j < 5; j++) {
                if ((index = i * 5 + j) >= int(campaign.maps.Length))
                    break;

                Map@ map = campaign.maps[index];
                if (map !is null) {
                    UI::Text(map.mapUid);
                } else
                    UI::Text("null map");
            }
        }

        UI::Text("that's all folks");
    }

    void RenderTabSelf() {
        bool open = true;

        int flags = UI::TabItemFlags::None;
        if (activeClubs.FindByRef(this) == activeClubIndex) {
            flags |= UI::TabItemFlags::SetSelected;
            activeClubIndex = -1;
        }

        if (UI::BeginTabItem(name.stripped + "##" + id, open, flags)) {
            UI::BeginTabBar("##tabbar-activities" + id);

            if (UI::BeginTabItem(Icons::Home + " Club")) {
                if (UI::BeginTable("##table-club-header", 2)) {
                    UI::TableSetupColumn("header", UI::TableColumnFlags::WidthStretch);
                    UI::TableSetupColumn("role", UI::TableColumnFlags::WidthFixed);

                    UI::TableNextRow();

                    UI::TableNextColumn();
                    UI::PushFont(fontHeader);
                    UI::Text(name.formatted);
                    UI::PopFont();

                    // if (activeActivities.Length > 0) {
                    //     UI::SameLine();
                    //     UI::Text("active: " + activeActivities.Length);
                    // }

                    UI::TableNextColumn();
                    UI::Text("\\$I" + tostring(role));

                    UI::EndTable();
                }

                const vec2 spaceAvail = UI::GetContentRegionAvail();
                const vec2 childSize = vec2(spaceAvail.x, (spaceAvail.y - scale * 17.0f) * 0.5f);

                if (UI::BeginChild("##child-activities" + id, childSize)) {
                    if (UI::BeginTable("##table-club-activity-header" + id, 2)) {
                        UI::TableSetupColumn("header", UI::TableColumnFlags::WidthStretch);
                        UI::TableSetupColumn("button", UI::TableColumnFlags::WidthFixed);

                        UI::TableNextRow();

                        UI::TableNextColumn();
                        UI::PushFont(fontSubHeader);
                        UI::SeparatorText((requestingActivities ? "\\$888" : "") + "Activities (" + activityCount + ")");
                        UI::PopFont();
                        if (requestingActivities)
                            HoverTooltip("patience, child...\n" + activities.Length + " / " + activityCount);

                        UI::TableNextColumn();
                        UI::BeginDisabled(requestingActivities);
                        const bool refresh = activityCount > 0;
                        if (
                            (refresh && UI::Button(Icons::Refresh + "##button-activities" + id))
                            || (!refresh && GayButton(Icons::Download + "##button-activities" + id, 2000, 0.5f))
                        )
                            startnew(CoroutineFunc(GetActivitiesAsync));
                        UI::EndDisabled();

                        UI::EndTable();
                    }

                    const vec2 childSpaceAvail = UI::GetContentRegionAvail();

                    const int cols = 5;
                    const int rows = int(Math::Ceil(float(activities.Length) / float(cols)));

                    if (UI::BeginTable("##table-activities", 5, UI::TableFlags::ScrollY)) {
                        for (uint i = 0; i < cols; i++)
                            UI::TableSetupColumn("col" + i, UI::TableColumnFlags::WidthFixed);

                        UI::ListClipper clipper(rows);
                        while (clipper.Step()) {
                            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                                UI::TableNextRow();

                                for (uint j = 0; j < 5; j++) {
                                    const uint index = i * 5 + j;
                                    if (index >= activities.Length)
                                        break;

                                    ClubActivity@ activity;

                                    try {
                                        @activity = activities[index];
                                    } catch {
                                        warn(getExceptionInfo());
                                        throw("activities.Length: " + activities.Length + " | index: " + index);
                                    }

                                    UI::TableNextColumn();

                                    if (j > 0 && j % 5 == 0)
                                        UI::NewLine();

                                    const float factor = ((childSpaceAvail.x - scale * 49.0f) / 5.0f) / iconSize.x;
                                    const vec2 activityIconSize = iconSize * factor;

                                    const vec2 pre = UI::GetCursorPos();

                                    if (Textures::Load(activity.mediaUrlPngSmall) !is null)
                                        Textures::Render(activity.mediaUrlPngSmall, activityIconSize);
                                    else
                                        Textures::Render("assets/club_blank.png", activityIconSize, true);

                                    UI::SetCursorPos(pre);
                                    if (UI::InvisibleButton("##invisbutton-activity" + activity.id, activityIconSize)) {
                                        // print("activity clicked: " + activity.id);

                                        const int activityIndex = activeActivities.FindByRef(activity);
                                        if (activityIndex == -1) {
                                            activeActivityIndex = activeActivities.Length;
                                            activeActivities.InsertLast(@activity);
                                        } else
                                            activeActivityIndex = activityIndex;
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
                                    UI::Text("\\$888" + tostring(activity.type));

                                    if (j % 5 == 1)
                                        UI::NewLine();
                                }
                            }
                        }

                        UI::EndTable();
                    }
                }
                UI::EndChild();

                if (UI::BeginChild("##child-members" + id, childSize)) {
                    if (UI::BeginTable("##table-club-member-header" + id, 2)) {
                        UI::TableSetupColumn("header", UI::TableColumnFlags::WidthStretch);
                        UI::TableSetupColumn("button", UI::TableColumnFlags::WidthFixed);

                        UI::TableNextRow();

                        UI::TableNextColumn();
                        UI::PushFont(fontSubHeader);
                        UI::SeparatorText((requestingMembers ? "\\$888" : "") + "Members (" + memberCount + ")");
                        UI::PopFont();
                        if (requestingMembers)
                            HoverTooltip("patience, child...\n" + members.Length + " / " + memberCount);

                        UI::TableNextColumn();
                        UI::BeginDisabled(requestingMembers);
                        const bool refresh = activityCount > 0;
                        if (
                            (refresh && UI::Button(Icons::Refresh + "##button-members" + id))
                            || (!refresh && GayButton(Icons::Download + "##button-members" + id, 2000, 0.5f))
                        )
                            startnew(CoroutineFunc(GetMembersAsync));
                        UI::EndDisabled();

                        UI::EndTable();
                    }

                    if (UI::BeginTable("##table-members", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
                        UI::PushStyleColor(UI::Col::TableRowBgAlt, colorRowBg);

                        UI::TableSetupScrollFreeze(0, 1);
                        UI::TableSetupColumn("Name", UI::TableColumnFlags::WidthFixed);
                        UI::TableSetupColumn("Role", UI::TableColumnFlags::WidthFixed);
                        UI::TableSetupColumn("Since", UI::TableColumnFlags::WidthFixed);

                        UI::ListClipper clipper(members.Length);
                        while (clipper.Step()) {
                            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                                ClubMember@ member = members[i];

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

            for (uint i = 0; i < activeActivities.Length; i++)
                RenderTabActivity(activeActivities[i]);

            UI::EndTabBar();

            UI::EndTabItem();
        }

        if (!open) {
            for (uint i = 0; i < activeClubs.Length; i++) {
                if (activeClubs[i].id == id) {
                    activeClubs.RemoveAt(i);
                    break;
                }
            }
        }
    }
}

ClubRole GetClubRole(const string &in role) {
    if (role == "Admin")
        return ClubRole::Admin;

    if (role == "Content_Creator")
        return ClubRole::ContentCreator;

    if (role == "Creator")
        return ClubRole::Creator;

    if (role == "Member")
        return ClubRole::Member;

    warn("unknown role: " + role);

    return ClubRole::Unknown;
}
