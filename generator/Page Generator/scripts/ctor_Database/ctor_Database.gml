function Database() constructor {
    participants = [];
    participants_by_id = {};
    jams = [];
    jams_by_id = {};
    
    static add_participants = function(_participants) {
        array_foreach(_participants, function(_participant) {
            array_push(participants, _participant);
            participants_by_id[$ string_lower(_participant.id)] = _participant;
        });
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
