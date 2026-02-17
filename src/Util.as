bool GayButton(const string &in text, uint cycleTimeMs = 5000, float offset = 0.0f, bool reverse = false) {
    return UI::ButtonColored(text, GayHue(cycleTimeMs, offset, reverse));
}

float GayHue(uint cycleTimeMs = 5000, float offset = 0.0f, bool reverse = false) {
    const float h = float(Time::Now % cycleTimeMs) / float(cycleTimeMs) + offset;
    const float normal = h - Math::Floor(h);

    if (reverse)
        return 1.0f - normal;

    return normal;
}

string GetUUID(const string &in url) {
    string[]@ parts = url.Replace("https://trackmania-prod-media-s3.cdn.ubi.com/media/image/live-api/", "").Split("/");
    return parts.Length > 0 ? parts[0] : "";
}

void HoverTooltip(const string &in msg) {
    if (!UI::IsItemHovered())
        return;

    UI::BeginTooltip();
    UI::Text(msg);
    UI::EndTooltip();
}

string Zpad(uint num, uint digits = 2) {
    string zeroes;

    const string result = tostring(num);

    const uint length = digits - uint(result.Length);

    for (uint i = 0; i < length; i++)
        zeroes += "0";

    return zeroes + result;
}
