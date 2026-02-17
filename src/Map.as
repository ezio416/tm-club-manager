class Map {
    string id;
    string mapId;
    string mapUid;
    FormattedString@ name;
    ClubActivity@ parent;
    int position = -1;

    Map(Json::Value@ json) {
        id       = JsonExt::GetString(json, "id");
        position = JsonExt::GetInt(json, "position");
        mapUid   = JsonExt::GetString(json, "mapUid");
    }
}
