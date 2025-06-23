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
    var _jam = new DbJam(_jam_data);
    database.add_jam(_jam);
    array_push(remaining_jams, _jam);
    show_debug_message("Loaded jam from " + _file);
    return;
}

if (array_length(remaining_jams) > 0) {
    var _jam = array_shift(remaining_jams);
    var _content = jam_generator.generate_content(_jam);
    file_write_all_text(_jam.info_directory + "jaminfo.json", _content);
    show_debug_message("Generated data for jam " + _jam.title);
    return;
}
