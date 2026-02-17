// c 2024-09-27
// m 2024-09-27

bool CheckJsonType(Json::Value@ json, Json::Type type = Json::Type::Object) {
    if (json is null)
        return false;

    return json.GetType() == type;
}

void GetAccountNames() {
    accounts = NadeoServices::GetDisplayNamesAsync(accounts.GetKeys());
}

Json::Value@ GetJsonValue(Json::Value@ json, const string &in key, Json::Type type = Json::Type::Object) {
    if (json is null || !json.HasKey(key))
        return null;

    Json::Value@ value = json[key];

    if (!CheckJsonType(value, type))
        return null;

    return value;
}

void HoverTooltip(const string &in msg) {
    if (!UI::IsItemHovered())
        return;

    UI::BeginTooltip();
        UI::Text(msg);
    UI::EndTooltip();
}

string ZPad2(int num) {
    return (num < 10 ? "0" : "") + num;
}
