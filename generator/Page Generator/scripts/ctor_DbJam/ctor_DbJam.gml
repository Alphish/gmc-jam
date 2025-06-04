function DbJam(_data, _db) constructor {
    data = _data;
    
    id = _data.id;
    title = _data[$ "title"];
    start_time = _data[$ "startTime"];
    end_time = _data[$ "endTime"];
    theme = _data[$ "theme"];
    hosts = _data[$ "hosts"];
    links = _data[$ "links"];
    
    // -------
    // Entries
    // -------
    
    entries = [];
    entries_by_id = {};
    
    var _jam = self;
    array_foreach(_data[$ "entries"] ?? [], method({ jam: _jam, database: _db }, function(_entry_data) {
        var _entry = new DbJamEntry(jam, _entry_data, database);
        array_push(jam.entries, _entry);
        jam.entries_by_id[$ _entry.id] = _entry;
    }));
    
    // -------
    // Results
    // -------
    
    var _results_data = _data[$ "results"] ?? {};
    var _ranking_data = _results_data[$ "ranking"] ?? [];
    ranking = array_map(_ranking_data, function(_id) { return entries_by_id[$ _id]; });
    
    var _awards_data = _results_data[$ "awards"] ?? [];
    awards = array_map(_awards_data, method({ jam: _jam, database: _db }, function(_data) {
        return new DbJamAward(jam, _data, database);
    }));
}