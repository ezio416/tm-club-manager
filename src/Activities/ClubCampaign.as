class ClubCampaign : ClubActivity {
    string clubDecalUrl;
    int    popularityLevel      = -1;
    int64  publicationTimestamp = -1;
    int64  creationTimestamp    = -1;
    FormattedString@ clubName;
    uint   mapsCount = 0;
    string seasonUid;
    string color;
    int    useCase = -1;
    string leaderboardGroupUid;
    int64  endTimestamp         = -1;
    int64  rankingSentTimestamp = -1;
    int    year                 = -1;
    int    week                 = -1;
    int    day                  = -1;
    int    monthYear            = -1;
    int    month                = -1;
    int    monthDay             = -1;
    bool   published            = false;

    ClubCampaign(Json::Value@ json) {
        super(json);

        print("init ClubCampaign");

        if (type != ActivityType::Campaign)
            throw("can't initialize ClubCampaign: type is " + tostring(type));

        Update(json);
    }

    void Update(Json::Value@ json) {
        clubDecalUrl         = JsonExt::GetString(json, "clubDecalUrl");
        popularityLevel      = JsonExt::GetInt(json, "popularityLevel");
        publicationTimestamp = JsonExt::GetInt64(json, "publicationTimestamp");
        creationTimestamp    = JsonExt::GetInt64(json, "creationTimestamp");
        // @clubName            = FormattedString(JsonExt::GetString(json, "clubName"));
        mapsCount            = JsonExt::GetUint(json, "mapsCount");

        Json::Value@ campaign = JsonExt::GetValue(json, "campaign");
        if (campaign !is null) {
            seasonUid            = JsonExt::GetString(campaign, "seasonUid");
            color                = JsonExt::GetString(campaign, "color");
            useCase              = JsonExt::GetInt(campaign, "useCase");
            leaderboardGroupUid  = JsonExt::GetString(campaign, "leaderboardGroupUid");
            endTimestamp         = JsonExt::GetInt64(campaign, "endTimestamp");
            rankingSentTimestamp = JsonExt::GetInt64(campaign, "rankingSentTimestamp");
            year                 = JsonExt::GetInt(campaign, "year");
            week                 = JsonExt::GetInt(campaign, "week");
            day                  = JsonExt::GetInt(campaign, "day");
            monthYear            = JsonExt::GetInt(campaign, "monthYear");
            month                = JsonExt::GetInt(campaign, "month");
            monthDay             = JsonExt::GetInt(campaign, "monthDay");
            published            = JsonExt::GetBool(campaign, "published");

            Json::Value@ playlist = JsonExt::GetValue(campaign, "playlist", Json::Type::Array);
            if (playlist !is null) {
                print("playlist has " + playlist.Length + " items");
                for (uint i = 0; i < playlist.Length; i++) {
                    Map@ map = Map(playlist[i]);
                    @map.parent = this;
                    maps.InsertLast(map);
                }
            }
        }
    }
}
