function Database() constructor {
    participants = [];
    participants_by_id = {};
    
    static add_participants = function(_participants) {
        array_foreach(_participants, function(_participant) {
            array_push(participants, _participant);
            participants_by_id[$ string_lower(_participant.id)] = _participant;
        });
    }
}
