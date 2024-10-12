// c 2024-10-10
// m 2024-10-11

enum ActivityType {
    Advertisement,
    Campaign,
    Competition,
    Map_Upload,
    News,
    Ranking_Club,
    Ranking_Daily,
    Room,
    Skin_Upload,
    Unknown = 10
}

class ClubActivity {
    bool         active       = false;
    int          activityId   = -1;
    ActivityType activityType = ActivityType::Unknown;
    int          campaignId   = -1;
    int          clubId       = -1;
    string       creatorAccountId;
    int64        editionTimestamp = -1;
    int          externalId       = -1;
    bool         featured         = false;
    int          id               = -1;
    uint         itemsCount       = 0;
    string       latestEditorAccountId;
    string       mediaUrl;
    string       mediaUrlDds;
    string       mediaUrlPngLarge;
    string       mediaUrlPngMedium;
    string       mediaUrlPngSmall;
    string       mediaTheme;
    FormattedString@ name;
    Club@ parent;
    bool password        = false;
    int  position        = -1;
    bool public          = false;
    int targetActivityId = -1;

    ClubActivity(Json::Value@ json) {
        if (!JsonExt::CheckType(json))
            throw("can't initialize ClubActivity");

        active                = JsonExt::GetBool(json, "active");
        activityId            = JsonExt::GetInt(json, "activityId");
        activityType          = GetActivityType(JsonExt::GetString(json, "activityType"));
        campaignId            = JsonExt::GetInt(json, "campaignId");
        clubId                = JsonExt::GetInt(json, "clubId");
        creatorAccountId      = JsonExt::GetString(json, "creatorAccountId");
        editionTimestamp      = JsonExt::GetInt64(json, "editionTimestamp");
        externalId            = JsonExt::GetInt(json, "externalId");
        featured              = JsonExt::GetBool(json, "featured");
        id                    = JsonExt::GetInt(json, "id");
        itemsCount            = JsonExt::GetUint(json, "itemsCount");
        latestEditorAccountId = JsonExt::GetString(json, "latestEditorAccountId");
        mediaUrl              = JsonExt::GetString(json, "mediaUrl");
        mediaUrlDds           = JsonExt::GetString(json, "mediaUrlDds");
        mediaUrlPngLarge      = JsonExt::GetString(json, "mediaUrlPngLarge");
        mediaUrlPngMedium     = JsonExt::GetString(json, "mediaUrlPngMedium");
        mediaUrlPngSmall      = JsonExt::GetString(json, "mediaUrlPngSmall");
        mediaTheme            = JsonExt::GetString(json, "mediaTheme");
        @name                 = FormattedString(JsonExt::GetString(json, "name"));
        password              = JsonExt::GetBool(json, "password");
        position              = JsonExt::GetInt(json, "position");
        public                = JsonExt::GetBool(json, "public");
        targetActivityId      = JsonExt::GetInt(json, "targetActivityId");
    }
}

ActivityType GetActivityType(const string &in type) {
    if (type == "ad")
        return ActivityType::Advertisement;

    if (type == "campaign")
        return ActivityType::Campaign;

    if (type == "competition")
        return ActivityType::Competition;

    if (type == "map-upload")
        return ActivityType::Map_Upload;

    if (type == "news")
        return ActivityType::News;

    if (type == "ranking-club")
        return ActivityType::Ranking_Club;

    if (type == "ranking-daily")
        return ActivityType::Ranking_Daily;

    if (type == "room")
        return ActivityType::Room;

    if (type == "skin-upload")
        return ActivityType::Skin_Upload;

    warn("unknown activity type: " + type);

    return ActivityType::Unknown;
}
