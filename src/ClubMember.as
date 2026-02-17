class ClubMember {
    bool     hasFeatured = false;
    string   id;
    bool     moderator   = false;
    bool     pin         = false;
    ClubRole role        = ClubRole::Unknown;
    int64    timestamp   = -1;
    bool     useTag      = false;
    bool     vip         = false;

    string get_name() { return accounts.Get(id); }

    ClubMember(Json::Value@ json) {
        if (!JsonExt::CheckType(json))
            throw("can't initialize ClubMember");

        hasFeatured = JsonExt::GetBool(json, "hasFeatured");
        id          = JsonExt::GetString(json, "accountId");
        moderator   = JsonExt::GetBool(json, "moderator");
        pin         = JsonExt::GetBool(json, "pin");
        role        = GetClubRole(JsonExt::GetString(json, "role"));
        timestamp   = JsonExt::GetInt64(json, "creationTimestamp");
        useTag      = JsonExt::GetBool(json, "useTag");
        vip         = JsonExt::GetBool(json, "vip");

        accounts.Add(id);
    }
}
