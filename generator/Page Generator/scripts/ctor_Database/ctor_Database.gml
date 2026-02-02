function Database() constructor {
    participants = [];
    participants_by_id = {};
    participants_by_name = {};
    jams = [];
    jams_by_id = {};
    
    static add_participants = function(_participants) {
        array_foreach(_participants, function(_participant) {
            array_push(participants, _participant);
            participants_by_id[$ string_lower(_participant.id)] = _participant;
            
            register_participant_name(_participant.name, _participant);
            for (var i = 0, _count = array_length(_participant.aliases); i < _count; i++) {
                register_participant_name(_participant.aliases[i], _participant);
            }
            for (var i = 0, _count = array_length(_participant.spellings); i < _count; i++) {
                register_participant_name(_participant.spellings[i], _participant);
            }
        });
    }
    
    static register_participant_name = function(_name, _participant) {
        var _key = string_lower(_name);
        if (struct_exists(participants_by_name, _key))
            participants_by_name[$ _key] = undefined;
        else
            participants_by_name[$ _key] = _participant;
    }
}

Database.instance = new Database();

Database.get_participant = function(_id) {
    return Database.instance.participants_by_id[$ _id];
}

Database.get_participant_id = function(_name) {
    var _participant = Database.try_get_participant_id(_name);
    if (is_undefined(_participant))
        throw $"Could not find participant: '{_name}'.";
    
    return _participant;
}

Database.try_get_participant_id = function(_name) {
    _name = string_lower(_name);
    if (!struct_exists(Database.instance.participants_by_name, _name))
        return undefined;
    
    return Database.instance.participants_by_name[$ _name].id;
}

Database.get_or_stub_jam = function(_id) {
    if (!struct_exists(Database.instance.jams_by_id, _id)) {
        var _jam = new DbJam(_id);
        array_push(Database.instance.jams, _jam);
        Database.instance.jams_by_id[$ _id] = _jam;
    }
    
    return Database.instance.jams_by_id[$ _id];
}

Database.populate_jam = function(_id, _data) {
    var _jam = Database.get_or_stub_jam(_id);
    _jam.populate_from_data(_data);
}

Database.complete_jam = function(_id, _data) {
    var _jam = Database.get_or_stub_jam(_id);
    _jam.complete_from_data(_data);
}
