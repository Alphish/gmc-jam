if (array_length(remaining_participant_files) > 0) {
    var _file = array_shift(remaining_participant_files);
    var _participants_data = json_load(_file);
    var _participants = array_map(_participants_data, function(_data) { return new DbParticipant(_data); });
    database.add_participants(_participants);
    array_foreach(_participants, function(_participant) { array_push(remaining_participants, _participant); });
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
    _jam.link_participant_entries();
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

if (array_length(remaining_participants) > 0) {
    var _participant = array_shift(remaining_participants);
    var _content = participant_generator.generate_content(_participant);
    file_write_all_text(_participant.export_filename, _content);
    show_debug_message("Generated data for participant " + _participant.name);
    return;
}

if (!trophies_exported) {
    var _trophies_participants = array_filter(Database.instance.participants, function(_participant) {
        return _participant.has_trophy();
    });
    array_sort(_trophies_participants, function(_left, _right) {
        var _left_trophies = _left.trophy_info;
        var _right_trophies = _right.trophy_info;
        if (_left_trophies[0] != _right_trophies[0])
            return _right_trophies[0] - _left_trophies[0];
        else if (_left_trophies[1] != _right_trophies[1])
            return _right_trophies[1] - _left_trophies[1];
        else if (_left_trophies[2] != _right_trophies[2])
            return _right_trophies[2] - _left_trophies[2];
        else if (_left_trophies[3] != _right_trophies[3])
            return _right_trophies[3] - _left_trophies[3];
        else
            return string_upper(_left_trophies[4]) < string_upper(_right_trophies[4]) ? -1 : 1;
    });
    
    var _content = trophy_generator.generate_content(_trophies_participants);
    file_write_all_text(filesystem.get_trophies_filename(), _content);
    
    show_debug_message("Generated trophies data");
    trophies_exported = true;
    return;
}

if (array_length(remaining_pages) > 0) {
    var _pagedata = array_shift(remaining_pages);
    var _page_content = file_read_all_text($"{filesystem.datafiles_directory}pages\\{_pagedata.page}.content.html");
    var _file_content = html_page_generator.generate_content(_page_content, _pagedata);
    file_write_all_text($"{filesystem.docs_directory}{_pagedata.page}.html", _file_content);
    show_debug_message($"Generated HTML page {_pagedata.page}");
}
