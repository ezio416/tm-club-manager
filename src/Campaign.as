// c 2024-09-27
// m 2024-09-27

class Campaign {
    Club@    club;
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

        id = uint(campaign["id"]);

        name = string(campaign["name"]);
        nameFormatted = Text::OpenplanetFormatCodes(name);
        nameStripped  = Text::StripFormatCodes(name);
    }

    void GetMapsAsync() {
        trace("getting maps for campaign \"" + nameStripped + "\" in club \"" + club.nameStripped + "\"");

        ;

        trace("got maps for campaign \"" + nameStripped + "\" in club \"" + club.nameStripped + "\"");
    }
}
