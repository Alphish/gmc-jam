function DbJam(_id) constructor {
    id = _id;
    info_directory = Filesystem.get_jam_directory(id);
    target_file = $"{Filesystem.instance.datafiles_directory}/{id}.jam.json";
    
    title = undefined;
    short_title = undefined;
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
        short_title = _data[$ "shortTitle"] ?? short_title;
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
    
    static link_participant_entries = function() {
        var _participant_awards = {};
        
        // preparing participant awards
        for (var i = 0, _count = array_length(awards ?? []); i < _count; i++) {
            var _award = awards[i];
            if (_award.awarded_to != "participant")
                continue;
            
            for (var j = 0, _wincount = array_length(_award.winners); j < _wincount; j++) {
                var _winner = _award.winners[j];
                _participant_awards[$ _winner.id] ??= [];
                array_push(_participant_awards[$ _winner.id], { id: _award.id, name: _award.name });
            }
        }
        
        // populating relevant participants with jam entries
        for (var i = 0, _count = array_length(ranking ?? entries ?? []); i < _count; i++) {
            var _entry = ranking[i];
            for (var j = 0, _acount = array_length(_entry.team.authors); j < _acount; j++) {
                var _jam_author = _entry.team.authors[j];
                var _participant = _jam_author.participant;
                var _jam_summary = _participant.get_or_stub_jam_summary(self);
                _jam_summary.add_entry_row(_entry, _participant_awards[$ _participant.id]);
                struct_remove(_participant_awards, _participant.id);
            }
        };
        
        // adding rows for outstanding participant awards, when no entry was added
        var _names = struct_get_names(_participant_awards);
        for (var i = 0, _count = array_length(_names); i < _count; i++) {
            var _name = _names[i];
            var _participant = Database.get_participant(_name);
            var _jam_summary = _participant.get_or_stub_jam_summary(self);
            _jam_summary.add_entry_row(undefined, _participant_awards[$ _name]);
        }
    }
}