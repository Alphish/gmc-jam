function DbJamParticipantSummary(_participant, _jam) constructor {
    participant = _participant;
    jam_id = _jam.id;
    jam_title = _jam.short_title ?? _jam.title;
    rows = [];
    
    static add_entry_row = function(_entry, _participant_awards) {
        var _awards = [];
        _participant_awards ??= [];
        var _participant_awards_length = array_length(_participant_awards);
        participant.trophy_info[3] += _participant_awards_length;
        
        if (is_undefined(_entry)) {
            array_copy(_awards, 0, _participant_awards, 0, _participant_awards_length);
            array_push(rows, { entry_id: undefined, entry_title: undefined, team: undefined, rank: undefined, awards: _awards });
            return;
        }
        
        var _entry_awards = _entry.awards ?? [];
        var _entry_awards_length = array_length(_entry_awards);
        participant.trophy_info[3] += _entry_awards_length;
        
        array_copy(_awards, 0, _entry_awards, 0, _entry_awards_length);
        array_copy(_awards, _entry_awards_length, _participant_awards, 0, _participant_awards_length);
        
        array_push(rows, {
            entry_id: _entry.id,
            entry_title: _entry.name,
            team: _entry.team,
            rank: _entry.rank,
            awards: _awards,
        });
        
        if (_entry.rank <= 3)
            participant.trophy_info[_entry.rank - 1] += 1;
    }
}
