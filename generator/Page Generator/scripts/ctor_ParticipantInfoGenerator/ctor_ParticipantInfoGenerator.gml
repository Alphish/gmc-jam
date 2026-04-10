function ParticipantInfoGenerator() constructor {
    static generate_content = function(_participant) {
        var _writer = new JsonWriter();
        
        _writer.begin_multiline_object();
        
        _writer.write_string_entry_if_any("name", _participant.name);
        _writer.write_multiline_array_entry_if_any("links", _participant.links, ParticipantInfoGenerator.write_link);
        
        var _entries = generate_entry_rows(_participant.jam_summaries);
        _writer.write_multiline_array_entry_if_any("entries", _entries, ParticipantInfoGenerator.write_entry);
        
        _writer.end_object();
        
        return _writer.get_content();
    }
    
    // -----------------
    // Basic information
    // -----------------
    
    static write_link = function(_writer, _link) {
        _writer.begin_inline_object();
        _writer.write_string_entry_if_any("title", _link.title);
        _writer.write_string_entry_if_any("url", _link.url);
        _writer.end_object();
    }
    
    // -------
    // Entries
    // -------
    
    static generate_entry_rows = function(_jam_summaries) {
        var _result = [];
        for (var i = 0, _count = array_length(_jam_summaries); i < _count; i++) {
            var _summary = _jam_summaries[i];
            for (var j = 0, _rcount = array_length(_summary.rows); j < _rcount; j++) {
                var _row = _summary.rows[j];
                var _file_row = [_summary.jam_id, _summary.jam_title, _row.entry_id, _row.entry_title, _row.team, _row.rank];
                if (is_nonempty_array(_row[$ "awards"]))
                    array_push(_file_row, _row[$ "awards"]);
                
                array_push(_result, _file_row);
            }
        }
        return _result;
    }
    
    static write_entry = function(_writer, _entry) {
        _writer.begin_inline_array();
        _writer.write_string(_entry[0]);
        _writer.write_string(_entry[1]);
        _writer.write_string(_entry[2]);
        _writer.write_string(_entry[3]);
        
        _writer.begin_inline_array();
        var _team = _entry[4];
        if (is_nonempty_string(_team.name))
            _writer.write_string(_team.name);
        
        var _authors = _team.authors;
        for (var i = 0, _count = array_length(_authors); i < _count; i++) {
            _writer.begin_inline_array();
            _writer.write_string(_authors[i].id);
            _writer.write_string(_authors[i].name);
            _writer.end_array();
        }
        _writer.end_array();
        
        _writer.write_value(_entry[5]);
        
        if (array_length(_entry) > 6 && is_nonempty_array(_entry[6])) {
            var _awards = _entry[6];
            _writer.begin_inline_array();
            for (var i = 0, _count = array_length(_awards); i < _count; i++) {
                _writer.begin_inline_array();
                _writer.write_string(_awards[i].id);
                _writer.write_string(_awards[i].name);
                _writer.end_array();
            }
            _writer.end_array();
        }
        
        _writer.end_array();
    }
}
