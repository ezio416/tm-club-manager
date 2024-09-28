// c 2024-09-27
// m 2024-09-27

namespace API {
    const string audienceLive = "NadeoLiveServices";
    uint64       lastRequest  = 0;
    const uint64 minimumWait  = 1000;

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
        const uint length    = 2;
        uint       offset    = 0;

        trace("getting my clubs");

        clubs = {};

        while (int(clubs.Length) != clubCount) {
            print("clubCount: " + clubCount + " | offset: " + offset);

            Net::HttpRequest@ req = GetAsync(
                audienceLive,
                NadeoServices::BaseURLLive() + "/api/token/club/mine?length=" + length + "&offset=" + offset
            );

            Json::Value@ json = req.Json();

            if (json.GetType() == Json::Type::Object) {
                if (json.HasKey("clubCount"))
                    clubCount = uint(json["clubCount"]);

                if (json.HasKey("clubList") && json["clubList"].GetType() == Json::Type::Array) {
                    for (uint i = 0; i < json["clubList"].Length; i++)
                        clubs.InsertLast(Club(json["clubList"][i]));
                } else {
                    warn("something went wrong while getting my clubs");
                    break;
                }
            }

            offset += length;
        }

        trace("got my clubs (" + clubs.Length + ")");
    }

    void WaitAsync() {
        uint64 now;

        while ((now = Time::Now) - lastRequest < minimumWait)
            yield();

        lastRequest = now;
    }
}
