// c 2024-10-08
// m 2024-10-08

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
