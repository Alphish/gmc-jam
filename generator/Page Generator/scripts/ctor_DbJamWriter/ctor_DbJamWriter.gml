function DbJamWriter() constructor {
    static generate_content = function(_data) {
        var _writer = new JsonWriter();
        
        _writer.begin_multiline_object();
        
        _writer.write_string_entry_if_any("id", _data.id);
        _writer.write_string_entry_if_any("title", _data.title);
        _writer.write_string_entry_if_any("startTime", _data.start_time);
        _writer.write_string_entry_if_any("endTime", _data.end_time);
        _writer.write_string_entry_if_any("theme", _data.theme);
        
        _writer.write_inline_array_entry_if_any("hosts", _data.hosts, DbJamWriter.write_host);
        _writer.write_multiline_array_entry_if_any("links", _data.links, DbJamWriter.write_link);
        
        _writer.write_multiline_array_entry_if_any("entries", _data.entries, DbJamWriter.write_entry);
        
        if (is_nonempty_array(_data.ranking) || is_nonempty_array(_data.awards)) {
            _writer.write_key("results");
            _writer.begin_multiline_object();
            _writer.write_multiline_array_entry_if_any("ranking", _data.ranking, DbJamWriter.write_entity_id);
            _writer.write_multiline_array_entry_if_any("awards", _data.awards, DbJamWriter.write_award_entry);
            _writer.end_object();
        }
        
        _writer.end_object();
        
        return _writer.get_content();
    }
    
    // -----------------
    // Basic information
    // -----------------
    
    static write_host = function(_writer, _host) {
        _writer.write_string(_host.id);
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
        _writer.begin_inline_object();
        _writer.write_string_entry_if_any("id", _entry.id);
        _writer.write_string_entry_if_any("name", _entry.name);
        
        _writer.write_key("team");
        if (is_nonempty_string(_entry.team[$ "name"])) {
            _writer.begin_inline_object();
            _writer.write_string_entry_if_any("name", _entry.team.name);
            _writer.write_inline_array_entry_if_any("authors", _entry.team.authors, DbJamWriter.write_author);
            _writer.end_object();
        } else {
            _writer.write_inline_array_if_any(_entry.team.authors, DbJamWriter.write_author);
        }
        
        _writer.end_object();
    }
    
    static write_author = function(_writer, _author) {
        if (string_lower(_author.name) == string_lower(_author.participant.name)) {
            _writer.write_string(_author.id);
        } else {
            _writer.begin_inline_object();
            _writer.write_string_entry_if_any("id", _author.id);
            _writer.write_string_entry_if_any("alias", _author.name);
            _writer.end_object();
        }
    }
    
    // -------
    // Results
    // -------
    
    static write_entity_id = function(_writer, _entity) {
        _writer.write_string(_entity.id);
    }
    
    static write_award_entry = function(_writer, _entry) {
        _writer.begin_inline_object();
        
        _writer.write_string_entry_if_any("id", _entry.id);
        _writer.write_string_entry_if_any("name", _entry.name);
        _writer.write_inline_array_entry_if_any("winners", _entry.winners, DbJamWriter.write_entity_id);
        if (_entry.awarded_to == "participant")
            _writer.write_string_entry_if_any("awardedTo", "participant");
        
        _writer.end_object();
    }
}
