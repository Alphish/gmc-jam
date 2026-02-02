function JamInfoGenerator() constructor {
    static generate_content = function(_jam) {
        var _writer = new JsonWriter();
        
        _writer.begin_multiline_object();
        
        _writer.write_string_entry_if_any("title", _jam.title);
        _writer.write_string_entry_if_any("logoPath", _jam.logo_path);
        _writer.write_string_entry_if_any("startTime", _jam.start_time);
        _writer.write_string_entry_if_any("endTime", _jam.end_time);
        _writer.write_string_entry_if_any("theme", _jam.theme);
        
        _writer.write_inline_array_entry_if_any("hosts", _jam.hosts, JamInfoGenerator.write_host);
        _writer.write_multiline_array_entry_if_any("links", _jam.links, JamInfoGenerator.write_link);
        
        _writer.write_multiline_array_entry_if_any("entries", _jam.entries, JamInfoGenerator.write_entry);
        
        if (is_nonempty_array(_jam.ranking) || is_nonempty_array(_jam.awards)) {
            _writer.write_key("results");
            _writer.begin_multiline_object();
            _writer.write_multiline_array_entry_if_any("ranking", _jam.ranking, JamInfoGenerator.write_entry_id);
            _writer.write_multiline_array_entry_if_any("awards", _jam.awards, JamInfoGenerator.write_award);
            _writer.end_object();
        }
        
        _writer.end_object();
        
        return _writer.get_content();
    }
    
    // -----------------
    // Basic information
    // -----------------
    
    static write_host = function(_writer, _host) {
        _writer.write_string(_host.name);
    }
    
    static write_link = function(_writer, _link) {
        _writer.begin_inline_object();
        _writer.write_string_entry_if_any("title", _link.title);
        _writer.write_string_entry_if_any("url", _link.url);
        _writer.end_object();
    }
    
    // -------
    // Entries
    // -------
    
    static write_entry = function(_writer, _entry) {
        _writer.begin_inline_array();
        _writer.write_string(_entry.id);
        _writer.write_string(_entry.name);
        
        _writer.begin_inline_array();
        if (is_nonempty_string(_entry.team.name))
            _writer.write_string(_entry.team.name);
        
        var _authors = _entry.team.authors;
        for (var i = 0, _count = array_length(_authors); i < _count; i++) {
            _writer.begin_inline_array();
            _writer.write_string(_authors[i].id);
            _writer.write_string(_authors[i].name);
            _writer.end_array();
        }
        
        _writer.end_array();
        
        _writer.end_array();
    }
    
    // -------
    // Results
    // -------
    
    static write_entry_id = function(_writer, _entry) {
        _writer.write_string(_entry.id);
    }
    
    static write_award = function(_writer, _award) {
        _writer.begin_inline_array();
        _writer.write_string(_award.id);
        _writer.write_string(_award.name);
            
        switch (_award.awarded_to) {
            case "entry":
                _writer.write_inline_array_if_any(_award.winners, JamInfoGenerator.write_entry_id);
                break;
            case "participant":
                _writer.write_inline_array_if_any(_award.winners, JamInfoGenerator.write_participant);
                _writer.write_string("participant");
                break;
        }
        _writer.end_array();
    }
    
    static write_participant = function(_writer, _participant) {
        _writer.begin_inline_object();
        _writer.write_string_entry_if_any("id", _participant.id);
        _writer.write_string_entry_if_any("name", _participant.name);
        _writer.end_object();
    }
}
