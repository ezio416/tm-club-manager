// c 2024-10-08
// m 2024-10-08

Accounts@     accounts    = Accounts();
bool          clubAccess  = false;
const string  pluginColor = "\\$0B9";
const string  pluginIcon  = Icons::Users;
Meta::Plugin@ pluginMeta  = Meta::ExecutingPlugin();
const string  pluginTitle = pluginColor + pluginIcon + "\\$G " + pluginMeta.Name;

void Main() {
    if (!(clubAccess = Permissions::CreateClub())) {
        const string msg = "This plugin requires club access.";
        warn(msg);
        UI::ShowNotification(pluginTitle, msg, vec4(1.0f, 0.3f, 0.0f, 1.0f));
        return;
    }
}

void Render() {
    if (false
        || !clubAccess
        || !S_Enabled
        || (S_HideWithGame && !UI::IsGameUIVisible())
        || (S_HideWithOP && !UI::IsOverlayShown())
    )
        return;

    if (UI::Begin(pluginTitle, S_Enabled, UI::WindowFlags::None)) {
        ;
    }
    UI::End();
}

void RenderMenu() {
    if (!clubAccess)
        return;

    if (UI::MenuItem(pluginTitle, "", S_Enabled))
        S_Enabled = !S_Enabled;
}
