// c 2024-09-27
// m 2024-09-27

bool CheckJsonType(Json::Value@ json, Json::Type type = Json::Type::Object) {
    if (json is null)
        return false;

    return json.GetType() == type;
}

Json::Value@ GetJsonValue(Json::Value@ json, const string &in key, Json::Type type = Json::Type::Object) {
    if (json is null || !json.HasKey(key))
        return null;

    Json::Value@ value = json[key];

    if (!CheckJsonType(value, type))
        return null;

    return value;
}
