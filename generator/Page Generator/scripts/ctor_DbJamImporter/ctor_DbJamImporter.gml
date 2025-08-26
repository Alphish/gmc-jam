function DbJamImporter(_id, _jampath) constructor {
    static dbjam_writer = new DbJamWriter();
    
    id = _id;
    data = { id: _id };
    jam_path = _jampath;
    target_file = $"{Filesystem.instance.datafiles_directory}/{id}.jam.json";
    
    remaining_files = [jam_path];
    
    static process_next = function() {
        if (array_length(remaining_files) == 0) {
            write_data();
            return true;
        }
        
        var _path = array_shift(remaining_files);
        if (string_ends_with(_path, ".jaminfo"))
            process_jam(_path);
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
    }
    
    static write_data = function() {
        var _content = dbjam_writer.generate_content(data);
        show_debug_message(_content);
        file_write_all_text(target_file, _content);
    }
}
