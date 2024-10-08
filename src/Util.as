// c 2024-10-08
// m 2024-10-08

void GetAccountNames() {
    accounts = NadeoServices::GetDisplayNamesAsync(accounts.GetKeys());
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
