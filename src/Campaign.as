// c 2024-09-27
// m 2024-09-27

class Campaign {
    Club@    club;
    bool     getting = false;
    uint     id;
    string   name;
    string   nameFormatted;
    string   nameStripped;
    string[] uids;

    Campaign(Json::Value@ campaign) {
        if (campaign.GetType() != Json::Type::Object)
            throw("campaign is not an object!");

        if (string(campaign["activityType"]) != "campaign")
            throw("campaign is not a campaign!");

        id = uint(campaign["campaignId"]);

        name = string(campaign["name"]);
        nameFormatted = Text::OpenplanetFormatCodes(name);
        nameStripped  = Text::StripFormatCodes(name);
    }

    void GetMapsAsync() {
        while (getting)
            yield();

        getting = true;

        trace("getting maps for campaign \"" + nameStripped + "\" in club \"" + club.nameStripped + "\"");

        uids = {};

        Net::HttpRequest@ req = API::GetAsync(
            API::audienceLive,
            NadeoServices::BaseURLLive() + "/api/token/club/" + club.id + "/campaign/" + id
        );

        Json::Value@ json = req.Json();
        print(Json::Write(json));

        if (CheckJsonType(json)) {
            Json::Value@ campaign = GetJsonValue(json, "campaign");
            if (campaign !is null) {
                Json::Value@ playlist = GetJsonValue(campaign, "playlist", Json::Type::Array);
                if (playlist !is null) {
                    for (uint i = 0; i < playlist.Length; i++) {
                        Json::Value@ map = playlist[i];
                        if (CheckJsonType(map)) {
                            Json::Value@ uid = GetJsonValue(map, "mapUid", Json::Type::String);
                            if (uid !is null)
                                uids.InsertLast(string(uid));
                        }
                    }
                }
            }
        }

        trace("got maps for campaign \"" + nameStripped + "\" in club \"" + club.nameStripped + "\"");

        getting = false;
    }
}
