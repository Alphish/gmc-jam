function DbJamImporter(_id, _jamdir) constructor {
    static dbjam_writer = new DbJamWriter();
    
    id = _id;
    data = { id: _id };
    jam_directory = _jamdir;
    jam_path = $"{jam_directory}/jam.jaminfo";
    target_file = $"{Filesystem.instance.datafiles_directory}/{id}.jam.json";
    
    remaining_files = [jam_path];
    remaining_entries = [];
    
    missing_authors = [];
    
    static process_next = function() {
        if (array_length(remaining_files) == 0) {
            if (array_length(missing_authors) > 0)
                throw "Some authors could not be mapped to participant data. Make sure all participants are accounted for.";
            
            write_data();
            return true;
        }
        
        var _path = array_shift(remaining_files);
        if (string_ends_with(_path, ".jaminfo"))
            process_jam(_path);
        else if (string_ends_with(_path, ".jamentry"))
            process_entry(_path);
        else if (string_ends_with(_path, ".jamoverrides"))
            process_overrides(_path);
        else
            throw $"Cannot process file at path: {_path}";
        
        return false;
    }
    
    static process_jam = function(_path) {
        var _info = json_load(_path);
        data.title = _info[$ "title"];
        data.start_time = _info[$ "startTime"];
        data.end_time = _info[$ "endTime"];
        data.theme = _info[$ "theme"];
        data.links = _info[$ "links"];
        
        if (struct_exists(_info, "hosts")) {
            data.hosts = array_map(_info.hosts, function(_host) { return Database.instance.get_participant_id(_host); });
        } else {
            data.hosts = undefined;
        }
        
        data.entries = [];
        data.entries_by_id = {};
        array_foreach(_info.entries, function(_entry) {
            var _entry_data = { id: _entry.id };
            array_push(data.entries, _entry_data);
            data.entries_by_id[$ string_lower(_entry.id)] = _entry_data;
            array_push(remaining_entries, _entry_data);
            array_push(remaining_files, $"{jam_directory}/Entries/{_entry.entrySubpath}/entry.jamentry");
        });
        
        array_push(remaining_files, $"{jam_directory}/.jamtally/overrides.jamoverrides");
    }
    
    static process_entry = function(_path) {
        var _info = json_load(_path);
        var _entry = array_shift(remaining_entries);
        _entry.title = _info.title;
        
        _entry.team = {};
        if (is_nonempty_string(_info.team[$ "name"]))
            _entry.team.name = _info.team.name;
        
        _entry.team.authors = [];
        for (var i = 0, _count = array_length(_info.team.authors); i < _count; i++) {
            var _author = _info.team.authors[i];
            var _data = get_author_data(_author);
            array_push(_entry.team.authors, _data);
        }
    }
    
    static process_overrides = function(_path) {
        if (!file_exists(_path))
            return;
        
        var _info = json_load(_path);
        for (var i = 0, _count = array_length(_info.entries); i < _count; i++) {
            var _entry_info = _info.entries[i];
            var _jam_id = _entry_info.entryId;
            var _page_id = string_replace_all(_entry_info.tallyCode, "_", "-");
            var _entry = data.entries_by_id[$ string_lower(_jam_id)];
            _entry.page_id = _page_id;
        }
    }
    
    static get_author_data = function(_author) {
        var _participant_id = Database.instance.try_get_participant_id(_author.name);
        if (!is_undefined(_participant_id))
            return { name: _author.name, id: _participant_id, participant: Database.get_participant(_participant_id) };
        
        show_debug_message($"Missing: {_author}");
        array_push(missing_authors, _author);
    }
    
    static write_data = function() {
        var _content = dbjam_writer.generate_content(data);
        show_debug_message(_content);
        file_write_all_text(target_file, _content);
    }
}
