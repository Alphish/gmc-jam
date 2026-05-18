function TrophyInfoGenerator() constructor {
    static generate_content = function(_participants) {
        var _writer = new JsonWriter();
        
        _writer.begin_multiline_array();
        
        for (var i = 0, _count = array_length(_participants); i < _count; i++) {
            var _participant = _participants[i];
            _writer.begin_inline_array();
            _writer.write_string(_participant.id);
            _writer.write_string(_participant.name);
            _writer.write_value(_participant.trophy_info[0]);
            _writer.write_value(_participant.trophy_info[1]);
            _writer.write_value(_participant.trophy_info[2]);
            _writer.write_value(_participant.trophy_info[3]);
            _writer.end_array();
        }
        
        _writer.end_array();
        
        return _writer.get_content();
    }
}
