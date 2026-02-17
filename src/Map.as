// c 2024-10-12
// m 2024-10-12

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
