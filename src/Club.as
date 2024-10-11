// c 2024-10-08
// m 2024-10-10

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

    ClubActivity@[] activities;
    uint activityCount = 0;
    uint memberCount = 0;
    ClubMember@[] members;
    bool requestingActivities = false;
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
                            activities.InsertLast(ClubActivity(activityList[j]));
                            // print("inserted activity " + activities.Length);
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
