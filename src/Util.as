// c 2024-10-08
// m 2024-10-10

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

void HoverTooltip(const string &in msg) {
    if (!UI::IsItemHovered())
        return;

    UI::BeginTooltip();
    UI::Text(msg);
    UI::EndTooltip();
}

uint LineNo(const string &in filename, const string &in uid) {
    if (!IO::FileExists(filename)) {
        print("file not found: " + filename);
        return 0;
    }

    uint i;
    IO::FileSource file(filename);
    for (i = 1; !file.EOF(); i++) {
        if (file.ReadLine().Contains(uid))
            return i;
    }

    return 0;
}

string Zpad(uint num, uint digits = 2) {
    string zeroes;

    const string result = tostring(num);

    const uint length = digits - uint(result.Length);

    for (uint i = 0; i < length; i++)
        zeroes += "0";

    return zeroes + result;
}
