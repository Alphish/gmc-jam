function DbJam(_id) constructor {
    id = _id;
    info_directory = Filesystem.get_jam_directory(id);
    target_file = $"{Filesystem.instance.datafiles_directory}/{id}.jam.json";
    
    title = undefined;
    logo_path = file_exists(info_directory + "logo.png") ? "logo.png" : undefined;
    start_time = undefined;
    end_time = undefined;
    theme = undefined;
    hosts = undefined;
    links = undefined;
    entries = [];
    entries_by_id = {};
    ranking = undefined;
    awards = undefined;
    
    static populate_from_data = function(_data) {
        title = _data[$ "title"] ?? title;
        start_time = _data[$ "startTime"] ?? start_time;
        end_time = _data[$ "endTime"] ?? end_time;
        theme = _data[$ "theme"] ?? theme;
        hosts = struct_exists(_data, "hosts") ? array_map(_data[$ "hosts"], Database.get_participant) : hosts;
        links = _data[$ "links"] ?? links;
        
        array_foreach(_data[$ "entries"] ?? [], function(_entry_data) {
            var _entry = get_or_stub_entry(_entry_data.id);
            _entry.populate_from_data(_entry_data);
        });
        
        var _results_data = _data[$ "results"] ?? {};
        if (struct_exists(_results_data, "ranking"))
            ranking = array_map(_results_data.ranking, function(_id) { return entries_by_id[$ _id]; });
        if (struct_exists(_results_data, "awards"))
            awards = array_map(_results_data.awards, function(_data) { return new DbJamAward(self, _data); });
        
        recalculate_entry_results();
    }
    
    static complete_from_data = function(_data) {
        title ??= _data[$ "title"];
        start_time ??= _data[$ "startTime"];
        end_time ??= _data[$ "endTime"];
        theme ??= _data[$ "theme"];
        hosts ??= array_map(_data[$ "hosts"], Database.get_participant);
        links ??= _data[$ "links"];
        
        array_foreach(_data[$ "entries"] ?? [], function(_entry_data) {
            var _entry = get_or_stub_entry(_entry_data.id);
            _entry.complete_from_data(_entry_data);
        });
        
        var _results_data = _data[$ "results"] ?? {};
        if (struct_exists(_results_data, "ranking"))
            ranking = array_map(_results_data.ranking, function(_id) { return entries_by_id[$ _id]; });
        if (struct_exists(_results_data, "awards"))
            awards = array_map(_results_data.awards, function(_data) { return new DbJamAward(self, _data); });
        
        recalculate_entry_results();
    }
    
    static get_or_stub_entry = function(_id) {
        if (!struct_exists(entries_by_id, _id)) {
            var _entry = new DbJamEntry(self, _id);
            array_push(entries, _entry);
            entries_by_id[$ _id] = _entry;
        }
        return entries_by_id[$ _id];
    }
    
    static recalculate_entry_results = function() {
        if (!is_nonempty_array(entries))
            return;
        
        array_foreach(entries, function(_entry) { _entry.awards = []; });
        
        for (var i = 0, _count = array_length(ranking ?? []); i < _count; i++) {
            ranking[i].rank = i + 1;
        }
        
        for (var i = 0, _count = array_length(awards ?? []); i < _count; i++) {
            var _award = awards[i];
            if (_award.awarded_to == "participant")
                continue;
            
            for (var j = 0, _wincount = array_length(_award.winners); j < _wincount; j++) {
                array_push(_award.winners[j].awards, { id: _award.id, name: _award.name });
            }
        }
    }
}