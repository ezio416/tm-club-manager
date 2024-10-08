// c 2024-10-08
// m 2024-10-08

namespace Json {
    bool CheckType(Json::Value@ json, Json::Type type = Json::Type::Object) {
        if (json is null)
            return false;

        return json.GetType() == type;
    }

    Json::Value@ GetValue(Json::Value@ json, const string &in key, Json::Type type = Json::Type::Object) {
        if (json is null || !json.HasKey(key))
            return null;

        Json::Value@ value = json[key];

        if (!CheckType(value, type))
            return null;

        return value;
    }
}
