function JamDataGenerator() constructor {
    static generate_content = function(_jam) {
        var _writer = new JsonWriter();
        _writer.write("{");
        
        var _next = false;
        
        if (!is_undefined(_jam.title))
        {
            _next = _writer.write_key("title", _next);
            _writer.write_string(_jam.title);
        }
        
        if (!is_undefined(_jam.logo_path)) {
            _next = _writer.write_key("logoPath", _next);
            _writer.write_string(_jam.logo_path);
        }
        
        if (!is_undefined(_jam.start_time)) {
            _next = _writer.write_key("startTime", _next);
            _writer.write_string(_jam.start_time);
        }
        
        if (!is_undefined(_jam.end_time)) {
            _next = _writer.write_key("endTime", _next);
            _writer.write_string(_jam.end_time);
        }
        
        if (!is_undefined(_jam.theme)) {
            _next = _writer.write_key("theme", _next);
            _writer.write_string(_jam.theme);
        }
        
        if (!is_undefined(_jam.hosts)) {
            _next = _writer.write_key("hosts", _next);
            _writer.write_inline_array(_jam.hosts, JamDataGenerator.write_host);
        }
        
        if (!is_undefined(_jam.links)) {
            _next = _writer.write_key("links", _next);
            _writer.write_multiline_array(_jam.links, JamDataGenerator.write_link);
        }
        
        if (!is_undefined(_jam.entries)) {
            _next = _writer.write_key("entries", _next);
            _writer.write_multiline_array(_jam.entries, JamDataGenerator.write_entry);
        }
        
        if (!is_undefined(_jam.ranking) || !is_undefined(_jam.awards)) {
            _next = _writer.write_key("results", _next);
            write_results(_writer, _jam);
        }
        
        _writer.write("\n}");
        
        return _writer.get_content();
    }
    
    // -----------------
    // Basic information
    // -----------------
    
    static write_host = function(_writer, _host) {
        _writer.write_string(_host.name);
    }
    
    static write_link = function(_writer, _link) {
        _writer.write("{");
        _writer.write_key("title");
        _writer.write_string(_link.title);
        _writer.write(",");
        _writer.write_key("url");
        _writer.write_string(_link.url);
        _writer.write("}");
    }
    
    // -------
    // Entries
    // -------
    
    static write_entry = function(_writer, _entry) {
        _writer.write("[");
        _writer.write_string(_entry.id);
        _writer.write(",");
        _writer.write_string(_entry.name);
        _writer.write(",");
        _writer.write_inline_array(_entry.team.authors, JamDataGenerator.write_author);
        _writer.write("]");
    }
    
    static write_author = function(_writer, _author) {
        _writer.write("[");
        _writer.write_string(_author.id);
        _writer.write(",");
        _writer.write_string(_author.name);
        _writer.write("]");
    }
    
    // -------
    // Results
    // -------
    
    static write_results = function(_writer, _jam) {
        _writer.write("{");
        
        var _next = false;
        if (!is_undefined(_jam.ranking)) {
            _next = _writer.write_key("ranking", _next);
            _writer.write_multiline_array(_jam.ranking, JamDataGenerator.write_entry_id);
        }
        
        if (!is_undefined(_jam.awards)) {
            _next = _writer.write_key("awards", _next);
            _writer.write_multiline_array(_jam.awards, JamDataGenerator.write_award);
        }
        
        _writer.write("\n}");
    }
    
    static write_award = function(_writer, _award) {
        _writer.write("[");
        _writer.write_string(_award.id);
        _writer.write(",");
        _writer.write_string(_award.name);
        _writer.write(",");
            
        switch (_award.awarded_to) {
            case "entry":
                _writer.write_inline_array(_award.winners, JamDataGenerator.write_entry_id);
                break;
            case "participant":
                _writer.write_inline_array(_award.winners, JamDataGenerator.write_participant);
                _writer.write(",\"participant\""); // awarded to
                break;
        }
        _writer.write("]");
    }
    
    static write_entry_id = function(_writer, _entry) {
        _writer.write_string(_entry.id);
    }
    
    static write_participant = function(_writer, _participant) {
        _writer.write("{");
        _writer.write_key("id");
        _writer.write_string(_participant.id);
        _writer.write(",");
        _writer.write_key("name");
        _writer.write_string(_participant.name);
        _writer.write("}");
    }
}
