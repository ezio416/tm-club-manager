// c 2024-09-27
// m 2024-09-27

class Club {
    bool        admin;
    Campaign@[] campaigns;
    bool        getting = false;
    uint        id;
    string      name;
    string      nameFormatted;
    string      nameStripped;

    Club(Json::Value@ club) {
        if (club.GetType() != Json::Type::Object)
            throw("club is not an object!");

        id = uint(club["id"]);

        const string[] adminRoles = { "Creator", "Admin" };
        admin = adminRoles.Find(string(club["role"])) != -1;

        name = string(club["name"]).Trim();
        nameFormatted = Text::OpenplanetFormatCodes(name).Trim();
        nameStripped  = Text::StripFormatCodes(name).Trim();
    }

    void GetCampaignsAsync() {
        while (getting)
            yield();

        getting = true;

        int        itemCount = -1;
        const uint length    = 20;
        uint       offset    = 0;

        trace("getting campaigns for club \"" + nameStripped + "\"");

        campaigns = {};

        while (int(campaigns.Length) != itemCount) {
            print("itemCount: " + itemCount + " | offset: " + offset);

            Net::HttpRequest@ req = API::GetAsync(
                API::audienceLive,
                NadeoServices::BaseURLLive() + "/api/token/club/" + id + "/activity?length=" + length + "&offset=" + offset + "&active=true"
            );

            Json::Value@ json = req.Json();
            print(Json::Write(json));

            if (CheckJsonType(json)) {
                if (json.HasKey("itemCount"))
                    itemCount = int(json["itemCount"]);

                Json::Value@ activityList = GetJsonValue(json, "activityList", Json::Type::Array);
                if (activityList !is null) {
                    if (activityList.Length == 0)
                        break;

                    for (uint i = 0; i < activityList.Length; i++) {
                        try {
                            campaigns.InsertLast(Campaign(activityList[i]));
                        } catch {
                            warn(getExceptionInfo());
                        }
                    }
                } else {
                    warn("something went wrong while getting campaigns for club \"" + nameStripped + "\"");
                    break;
                }
            }

            offset += length;
        }

        for (uint i = 0; i < campaigns.Length; i++)
            @campaigns[i].club = @this;

        trace("got campaigns for club \"" + nameStripped + "\" (" + campaigns.Length + ")");

        getting = false;
    }
}
