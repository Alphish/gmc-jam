function DbParticipant(_data) constructor {
    data = _data;
    id = _data.id;
    export_filename = Filesystem.get_participant_filename(id);
    
    name = _data.name;
    aliases = _data[$ "aliases"] ?? [];
    spellings = _data[$ "spellings"] ?? [];
    links = _data[$ "links"] ?? [];
    
    jam_summaries = [];
    jam_summaries_by_id = {};
    
    trophy_info = [0, 0, 0, 0, name];
    
    static get_or_stub_jam_summary = function(_jam) {
        if (struct_exists(jam_summaries_by_id, _jam.id))
            return jam_summaries_by_id[$ _jam.id];
        
        var _summary = new DbJamParticipantSummary(self, _jam);
        array_push(jam_summaries, _summary);
        jam_summaries_by_id[$ _jam.id] = _summary;
        return _summary;
    }
    
    static has_trophy = function() {
        return trophy_info[0] + trophy_info[1] + trophy_info[2] + trophy_info[3] > 0;
    }
}
