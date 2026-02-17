// c 2024-09-27
// m 2024-09-27

class Map {
    string    authorId;
    Campaign@ campaign;
    string    name;
    string    nameFormatted;
    string    nameStripped;
    string    type;
    string    uid;

    Map(const string &in uid) {
        this.uid = uid;
    }

    void UpdateInfo(Json::Value@ map) {
        if (!CheckJsonType(map))
            throw("map is not an object!");

        authorId = string(map["author"]);
        if (!accounts.Exists(authorId))
            accounts[authorId] = "";

        name = string(map["name"]);
        nameFormatted = Text::OpenplanetFormatCodes(name);
        nameStripped = Text::StripFormatCodes(name);

        type = string(map["mapType"]);
    }
}
