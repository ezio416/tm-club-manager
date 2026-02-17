const string cache = IO::FromStorageFolder("icons");

namespace Textures {
    bool        requesting = false;
    dictionary@ textures   = dictionary();

    UI::Texture@ Load(const string &in url, bool file = false) {
        if (textures.Exists(url))
            return cast<UI::Texture@>(textures[url]);

        if (!file)
            startnew(GetAsync, url);
        else {
            UI::Texture@ tex = @UI::LoadTexture(url);
            if (tex !is null)
                textures.Set(url, @tex);
        }

        return null;
    }

    void GetAsync(const string &in url) {
        while (requesting)
            yield();

        if (url.Length == 0 || textures.Exists(url))
            return;

        if (!IO::FolderExists(cache))
            IO::CreateFolder(cache);

        const string path = IO::FromStorageFolder("icons/" + GetUUID(url) + ".png").Replace("\\", "/");

        if (IO::FileExists(path)) {
            trace("loading texture from file: " + path);

            IO::File file(path, IO::FileMode::Read);

            UI::Texture@ tex = UI::LoadTexture(file.Read(file.Size()));
            if (tex !is null) {
                textures.Set(url, @tex);
                return;
            }
        }

        requesting = true;

        trace("getting texture from url: " + url);

        Net::HttpRequest@ req = Net::HttpGet(url);
        while (!req.Finished())
            yield();

        if (req.ResponseCode() == 200) {
            textures.Set(url, @UI::LoadTexture(req.Buffer()));

            trace("saving texture to file: " + path);
            req.SaveToFile(path);
        } else
            textures.Set(url, null);

        requesting = false;
    }

    void Render(UI::Texture@ tex, vec2 size) {
        if (tex !is null)
            UI::Image(tex, size);
        else
            UI::Dummy(size);
    }

    void Render(const string &in url, vec2 size, bool file = false) {
        Render(Load(url, file), size);
    }
}
