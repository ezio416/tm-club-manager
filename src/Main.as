// c 2024-10-08
// m 2024-10-08

const string  pluginColor = "\\$0B9";
const string  pluginIcon  = Icons::Users;
Meta::Plugin@ pluginMeta  = Meta::ExecutingPlugin();
const string  pluginTitle = pluginColor + pluginIcon + "\\$G " + pluginMeta.Name;

[Setting category="General" name="Enabled"]
bool S_Enabled = true;

[Setting category="General" name="Show/hide with game UI"]
bool S_HideWithGame = true;

[Setting category="General" name="Show/hide with Openplanet UI"]
bool S_HideWithOP = false;

void Main() {
    ;
}

void Render() {
    if (false
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
    if (UI::MenuItem(pluginTitle, "", S_Enabled))
        S_Enabled = !S_Enabled;
}
