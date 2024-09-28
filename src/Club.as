// c 2024-09-27
// m 2024-09-27

class Club {
    bool      admin;
    string    author;
    Campaign@ campaigns;
    int64     creationTimestamp;
    string    description;
    int64     editionTimestamp;
    uint      id;
    string    latestEditor;
    string    name;
    string    nameFormatted;
    string    nameStripped;
    uint      popularity;
    string    state;
    string    tag;
    string    tagFormatted;
    string    tagStripped;
    bool      verified;

    Club(Json::Value@ club) {
        author            = string(club["authorAccountId"]      );
        creationTimestamp = int64 (club["creationTimestamp"]    );
        description       = string(club["description"]          ).Trim();
        editionTimestamp  = int64 (club["editionTimestamp"]     );
        id                = uint  (club["id"]                   );
        latestEditor      = string(club["latestEditorAccountId"]);
        popularity        = uint  (club["popularityLevel"]      );
        state             = string(club["state"]                );
        verified          = bool  (club["verified"]             );

        const string[] adminRoles = { "Creator", "Admin" };
        admin = adminRoles.Find(string(club["role"])) != -1;

        name = string(club["name"]).Trim();
        nameFormatted = Text::OpenplanetFormatCodes(name).Trim();
        nameStripped  = Text::StripFormatCodes(name).Trim();

        tag = string(club["tag"]).Trim();
        tagFormatted = Text::OpenplanetFormatCodes(tag).Trim();
        tagStripped  = Text::StripFormatCodes(tag).Trim();
    }

    void GetActivitiesAsync() {
        ;
    }
}
