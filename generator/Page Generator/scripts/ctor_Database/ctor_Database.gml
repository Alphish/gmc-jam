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
    
    static add_jam = function(_jam) {
        array_push(jams, _jam);
        jams_by_id[$ _jam.id] = _jam;
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
