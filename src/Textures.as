// c 2024-10-10
// m 2024-10-10

namespace Textures {
    bool        requesting = false;
    dictionary@ textures   = dictionary();

    UI::Texture@ Get(const string &in url) {
        if (textures.Exists(url))
            return cast<UI::Texture@>(textures[url]);

        startnew(LoadAsync, url);

        return null;
    }

    void LoadAsync(const string &in url) {
        while (requesting)
            yield();

        if (url.Length == 0 || textures.Exists(url))
            return;

        requesting = true;

        trace("getting texture: " + url);

        Net::HttpRequest@ req = Net::HttpGet(url);
        while (!req.Finished())
            yield();

        if (req.ResponseCode() == 200) {
            try {
                textures.Set(url, @UI::LoadTexture(req.Buffer()));
            } catch {
                textures.Set(url, null);
            }
        } else
            textures.Set(url, null);

        requesting = false;
    }
}
