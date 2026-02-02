if (array_length(remaining_participant_files) > 0) {
    var _file = array_shift(remaining_participant_files);
    var _participants_data = json_load(_file);
    var _participants = array_map(_participants_data, function(_data) { return new DbParticipant(_data); });
    database.add_participants(_participants);
    show_debug_message("Loaded participants from " + _file);
    return;
}

if (array_length(remaining_jam_files) > 0) {
    var _file = array_shift(remaining_jam_files);
    var _jam_data = json_load(_file);
    Database.populate_jam(_jam_data.id, _jam_data);
    show_debug_message("Loaded jam from " + _file);
    return;
}

if (array_length(remaining_imports) > 0) {
    var _import = remaining_imports[0];
    if (_import.process_next())
        array_shift(remaining_imports);
    
    return;
}

if (is_undefined(remaining_jams))
    remaining_jams = array_map(Database.instance.jams, function(_jam) { return _jam; });

if (array_length(remaining_jams) > 0) {
    var _jam = array_shift(remaining_jams);
    var _db_content = dbjam_writer.generate_content(_jam);
    file_write_all_text(_jam.target_file, _db_content);
    
    var _content = jam_generator.generate_content(_jam);
    file_write_all_text(_jam.info_directory + "jaminfo.json", _content);
    
    for (var i = 0, _count = array_length(_jam.entries); i < _count; i++) {
        var _entry = _jam.entries[i];
        var _entry_content = entry_generator.generate_content(_entry);
        file_write_all_text(_jam.info_directory + _entry.id + ".entry.json", _entry_content);
    }
    show_debug_message("Generated data for jam " + _jam.title);
    return;
}
