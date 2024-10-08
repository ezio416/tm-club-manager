// c 2024-10-08
// m 2024-10-08

class Accounts {
    private dictionary@ data = dictionary();

    void Add(const string &in id) {
        data.Set(id, "");
    }

    void Add(const string &in id, const string &in name) {
        data.Set(id, name);
    }

    void AddAsync(const string &in id) {
        data.Set(id, NadeoServices::GetDisplayNameAsync(id));
    }

    string Get(const string &in id) {
        if (!data.Exists(id))
            return "";

        return string(data[id]);
    }

    void Refresh() {
        startnew(CoroutineFunc(RefreshAsync));
    }

    void RefreshAsync() {
        data = NadeoServices::GetDisplayNamesAsync(data.GetKeys());
    }
}
