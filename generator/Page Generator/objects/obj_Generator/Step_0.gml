if (array_length(remaining_participant_files) > 0) {
    var _file = array_shift(remaining_participant_files);
    var _participants_data = json_load(_file);
    var _participants = array_map(_participants_data, function(_data) { return new DbParticipant(_data); });
    database.add_participants(_participants);
    return;
}

if (array_length(remaining_jam_files) > 0) {
    var _file = array_shift(remaining_jam_files);
    var _jam_data = json_load(_file);
    var _jam = new DbJam(_jam_data, database);
    database.add_jam(_jam);
    return;
}
