// c 2023-09-26
// m 2024-09-29

Meta::Plugin@ thisPlugin = Meta::ExecutingPlugin();
const string  title      = "\\$FFF" + Icons::Arrows + "\\$G " + thisPlugin.Name;

[Setting category="General" name="Enabled"]
bool S_Enabled = true;

[Setting category="General" name="Show/hide with game UI"]
bool S_HideWithGame = true;

[Setting category="General" name="Show/hide with Openplanet UI"]
bool S_HideWithOP = false;

void Main() {
}

void Render() {
    if (false
        || !S_Enabled
        || (S_HideWithGame && !UI::IsGameUIVisible())
        || (S_HideWithOP && !UI::IsOverlayShown())
    )
        return;

    ;
}

void RenderMenu() {
    if (UI::MenuItem(title, "", S_Enabled))
        S_Enabled = !S_Enabled;
}
