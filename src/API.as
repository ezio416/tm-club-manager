// c 2024-10-08
// m 2024-10-08

namespace API {
    const string audienceCore = "NadeoServices";
    const string audienceLive = "NadeoLiveServices";
    uint64       lastRequest  = 0;
    const uint64 minimumWait  = 1000;
    bool         requesting   = false;

    string get_urlCore() { return NadeoServices::BaseURLCore(); }
    string get_urlLive() { return NadeoServices::BaseURLLive(); }
    string get_urlMeet() { return NadeoServices::BaseURLMeet(); }

    Net::HttpRequest@ GetAsync(const string &in audience, const string &in url, bool start = true) {
        NadeoServices::AddAudience(audience);

        while (!NadeoServices::IsAuthenticated(audience) || requesting)
            yield();

        if (start)
            requesting = true;

        WaitAsync();

        Net::HttpRequest@ req = NadeoServices::Get(audience, url);
        if (start) {
            req.Start();
            while (!req.Finished())
                yield();

            requesting = false;
        }

        return req;
    }

    Net::HttpRequest@ GetCoreAsync(const string &in endpoint, bool start = true) {
        return GetAsync(audienceCore, urlCore + endpoint, start);
    }

    Net::HttpRequest@ GetLiveAsync(const string &in endpoint, bool start = true) {
        return GetAsync(audienceLive, urlLive + endpoint, start);
    }

    Net::HttpRequest@ GetMeetAsync(const string &in endpoint, bool start = true) {
        return GetAsync(audienceLive, urlMeet + endpoint, start);
    }

    Net::HttpRequest@ PostAsync(const string &in audience, const string &in url, const string &in body = "", bool start = true) {
        NadeoServices::AddAudience(audience);

        while (!NadeoServices::IsAuthenticated(audience) || requesting)
            yield();

        if (start)
            requesting = true;

        WaitAsync();

        Net::HttpRequest@ req = NadeoServices::Post(audience, url, body);
        if (start) {
            req.Start();
            while (!req.Finished())
                yield();

            requesting = false;
        }

        return req;
    }

    Net::HttpRequest@ PostAsync(const string &in audience, const string &in url, Json::Value@ body = null, bool start = true) {
        return PostAsync(audience, url, Json::Write(body), start);
    }

    Net::HttpRequest@ PostCoreAsync(const string &in endpoint, const string &in body = "", bool start = true) {
        return PostAsync(audienceCore, urlCore + endpoint, body, start);
    }

    Net::HttpRequest@ PostCoreAsync(const string &in endpoint, Json::Value@ body = null, bool start = true) {
        return PostAsync(audienceCore, urlCore + endpoint, body, start);
    }

    Net::HttpRequest@ PostLiveAsync(const string &in endpoint, const string &in body = "", bool start = true) {
        return PostAsync(audienceLive, urlLive + endpoint, body, start);
    }

    Net::HttpRequest@ PostLiveAsync(const string &in endpoint, Json::Value@ body = null, bool start = true) {
        return PostAsync(audienceLive, urlLive + endpoint, body, start);
    }

    Net::HttpRequest@ PostMeetAsync(const string &in endpoint, const string &in body = "", bool start = true) {
        return PostAsync(audienceLive, urlMeet + endpoint, body, start);
    }

    Net::HttpRequest@ PostMeetAsync(const string &in endpoint, Json::Value@ body = null, bool start = true) {
        return PostAsync(audienceLive, urlMeet + endpoint, body, start);
    }

    void WaitAsync() {
        uint64 now;

        while ((now = Time::Now) - lastRequest < minimumWait)
            yield();

        lastRequest = now;
    }
}
