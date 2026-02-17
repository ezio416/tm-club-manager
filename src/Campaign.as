// c 2024-09-27
// m 2024-09-27

class Campaign {
    Club@       club;
    bool        getting = false;
    uint        id;
    dictionary@ maps    = dictionary();
    Map@[]      mapsArr;
    string      name;
    string      nameFormatted;
    string      nameStripped;
    string[]    newUids;
    bool        sending = false;

    Campaign(Json::Value@ campaign) {
        if (campaign.GetType() != Json::Type::Object)
            throw("campaign is not an object!");

        if (string(campaign["activityType"]) != "campaign")
            throw("campaign is not a campaign!");

        id = uint(campaign["campaignId"]);

        name = string(campaign["name"]);
        nameFormatted = Text::OpenplanetFormatCodes(name);
        nameStripped  = Text::StripFormatCodes(name);

        newUids.Resize(25);
    }

    void GetMapsAsync() {
        while (getting)
            yield();

        getting = true;

        trace("getting map UIDs for campaign \"" + nameStripped + "\" in club \"" + club.nameStripped + "\"");

        maps.DeleteAll();
        mapsArr = {};
        newUids = {};
        newUids.Resize(25);

        Net::HttpRequest@ req = API::GetAsync(
            API::audienceLive,
            NadeoServices::BaseURLLive() + "/api/token/club/" + club.id + "/campaign/" + id
        );

        Json::Value@ json = req.Json();
        // print(Json::Write(json));

        if (CheckJsonType(json)) {
            Json::Value@ campaign = GetJsonValue(json, "campaign");
            if (campaign !is null) {
                Json::Value@ playlist = GetJsonValue(campaign, "playlist", Json::Type::Array);
                if (playlist !is null) {
                    for (uint i = 0; i < playlist.Length; i++) {
                        if (CheckJsonType(playlist[i])) {
                            Json::Value@ uid = GetJsonValue(playlist[i], "mapUid", Json::Type::String);
                            if (uid !is null) {
                                Map@ map = Map(string(uid));
                                maps.Set(string(uid), @map);
                                mapsArr.InsertLast(@map);
                            }
                        }
                    }
                }
            }
        }

        trace("got map UIDs for campaign \"" + nameStripped + "\" in club \"" + club.nameStripped + "\"");

        GetMapInfosAsync();
    }

    private void GetMapInfosAsync() {
        trace("getting map infos for campaign \"" + nameStripped + "\" in club \"" + club.nameStripped + "\"");

        string[] uids;
        for (uint i = 0; i < mapsArr.Length; i++)
            uids.InsertLast(mapsArr[i].uid);

        Net::HttpRequest@ req = API::GetAsync(
            API::audienceLive,
            NadeoServices::BaseURLLive() + "/api/token/map/get-multiple?mapUidList=" + string::Join(uids, ",")
        );

        Json::Value@ json = req.Json();
        // print(Json::Write(json));

        if (CheckJsonType(json)) {
            Json::Value@ mapList = GetJsonValue(json, "mapList", Json::Type::Array);
            if (mapList !is null) {
                for (uint i = 0; i < mapList.Length; i++) {
                    if (CheckJsonType(mapList[i])) {
                        Json::Value@ uid = GetJsonValue(mapList[i], "uid", Json::Type::String);
                        if (uid !is null) {
                            Map@ map = cast<Map@>(maps[string(uid)]);
                            if (map !is null)
                                map.UpdateInfo(mapList[i]);
                        }
                    }
                }
            }
        }

        trace("got map infos for campaign \"" + nameStripped + "\" in club \"" + club.nameStripped + "\"");

        GetAccountNames();

        getting = false;
    }

    void SendUpdateAsync() {
        while (sending)
            yield();

        sending = true;

        trace("sending new UIDs for campaign \"" + nameStripped + "\" in club \"" + club.nameStripped + "\"");

        string[] mapInfos;

        for (uint i = 0; i < 25; i++) {
            if (newUids[i].Length > 0)
                mapInfos.InsertLast("{\"position\":" + i + ",\"mapUid\":\"" + newUids[i] + "\"}");
        }

        Net::HttpRequest@ req = API::PostAsync(
            API::audienceLive,
            NadeoServices::BaseURLLive() + "/api/token/club/" + club.id + "/campaign/" + id + "/edit",
            "{\"name\":\"" + name + "\",\"playlist\":[" + string::Join(mapInfos, ",") + "]}"
        );

        Json::Value@ json = req.Json();
        print(Json::Write(json));
        IO::SetClipboard(req.String());

        trace("sent new UIDs for campaign \"" + nameStripped + "\" in club \"" + club.nameStripped + "\"");

        sending = false;
    }
}
