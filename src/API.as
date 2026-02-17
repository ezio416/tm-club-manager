// c 2024-09-27
// m 2024-09-27

namespace API {
    const string audienceLive = "NadeoLiveServices";
    bool         getting      = false;
    uint64       lastRequest  = 0;
    const uint64 minimumWait  = 1000;
    bool         sending      = false;

    Net::HttpRequest@ GetAsync(const string &in audience, const string &in url) {
        while (!NadeoServices::IsAuthenticated(audience) || getting)
            yield();

        getting = true;

        WaitAsync();

        Net::HttpRequest@ req = NadeoServices::Get(audience, url);
        req.Start();
        while (!req.Finished())
            yield();

        getting = false;

        return req;
    }

    void GetMyClubsAsync() {
        int        clubCount = -1;
        const uint length    = 20;
        uint       offset    = 0;

        trace("getting my clubs");

        clubs = {};
        @activeCampaign = null;
        @activeClub = null;

        while (int(clubs.Length) != clubCount) {
            // print("clubCount: " + clubCount + " | offset: " + offset);

            Net::HttpRequest@ req = GetAsync(
                audienceLive,
                NadeoServices::BaseURLLive() + "/api/token/club/mine?length=" + length + "&offset=" + offset
            );

            Json::Value@ json = req.Json();

            if (CheckJsonType(json)) {
                if (json.HasKey("clubCount"))
                    clubCount = int(json["clubCount"]);

                Json::Value@ clubList = GetJsonValue(json, "clubList", Json::Type::Array);
                if (clubList !is null) {
                    if (clubList.Length == 0)
                        break;

                    for (uint i = 0; i < clubList.Length; i++) {
                        try {
                            clubs.InsertLast(Club(clubList[i]));
                        } catch {
                            warn(getExceptionInfo());
                        }
                    }
                } else {
                    warn("something went wrong while getting my clubs");
                    break;
                }
            }

            offset += length;
        }

        trace("got my clubs (" + clubs.Length + ")");
    }

    Net::HttpRequest@ PostAsync(const string &in audience, const string &in url, const string &in body = "") {
        while (!NadeoServices::IsAuthenticated(audience))
            yield();

        sending = true;

        WaitAsync();

        Net::HttpRequest@ req = NadeoServices::Post(audience, url, body);
        req.Start();
        while (!req.Finished())
            yield();

        sending = false;

        return req;
    }

    void WaitAsync() {
        uint64 now;

        while ((now = Time::Now) - lastRequest < minimumWait)
            yield();

        lastRequest = now;
    }
}
