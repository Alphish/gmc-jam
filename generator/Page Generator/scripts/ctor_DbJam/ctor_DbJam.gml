function DbJam(_data) constructor {
    data = _data;
    id = _data.id;
    info_directory = Filesystem.get_jam_directory(id);
    
    title = _data[$ "title"];
    logo_path = file_exists(info_directory + "logo.png") ? "logo.png" : undefined;
    start_time = _data[$ "startTime"];
    end_time = _data[$ "endTime"];
    theme = _data[$ "theme"];
    hosts = array_map(_data[$ "hosts"], Database.get_participant);
    links = _data[$ "links"];
    
    // -------
    // Entries
    // -------
    
    entries = [];
    entries_by_id = {};
    
    var _jam = self;
    array_foreach(_data[$ "entries"] ?? [], function(_entry_data) {
        var _entry = new DbJamEntry(self, _entry_data);
        array_push(entries, _entry);
        entries_by_id[$ _entry.id] = _entry;
    });
    
    // -------
    // Results
    // -------
    
    var _results_data = _data[$ "results"] ?? {};
    var _ranking_data = _results_data[$ "ranking"] ?? [];
    ranking = array_map(_ranking_data, function(_id) { return entries_by_id[$ _id]; });
    
    var _awards_data = _results_data[$ "awards"] ?? [];
    awards = array_map(_awards_data, function(_data) {
        return new DbJamAward(self, _data);
    });
}