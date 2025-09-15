function DbJamWriter() constructor {
    static generate_content = function(_data) {
        var _writer = new JsonWriter();
        _writer.write("{");
        
        var _next = false;
        
        _next = _writer.write_key("id", _next);
        _writer.write_string(_data.id);
        
        if (!is_undefined(_data.title))
        {
            _next = _writer.write_key("title", _next);
            _writer.write_string(_data.title);
        }
        
        if (!is_undefined(_data.start_time)) {
            _next = _writer.write_key("startTime", _next);
            _writer.write_string(_data.start_time);
        }
        
        if (!is_undefined(_data.end_time)) {
            _next = _writer.write_key("endTime", _next);
            _writer.write_string(_data.end_time);
        }
        
        if (!is_undefined(_data.theme)) {
            _next = _writer.write_key("theme", _next);
            _writer.write_string(_data.theme);
        }
        
        if (!is_undefined(_data.hosts)) {
            _next = _writer.write_key("hosts", _next);
            _writer.write_inline_array(_data.hosts, DbJamWriter.write_host);
        }
        
        if (is_nonempty_array(_data.links)) {
            _next = _writer.write_key("links", _next);
            _writer.write_multiline_array(_data.links, DbJamWriter.write_link);
        }
        
        if (is_nonempty_array(_data.entries)) {
            _next = _writer.write_key("entries", _next);
            _writer.write_multiline_array(_data.entries, DbJamWriter.write_entry);
        }
        
        if (is_nonempty_array(_data.ranking) || is_nonempty_array(_data.awards)) {
            _next = _writer.write_key("results", _next);
            write_results(_writer, _data);
        }
        
        _writer.write("\n}");
        
        return _writer.get_content();
    }
    
    static write_host = function(_writer, _host) {
        _writer.write_string(_host);
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
        _writer.write("{");
        _writer.write_key("id");
        _writer.write_string(_entry.page_id);
        _writer.write(",");
        _writer.write_key("name");
        _writer.write_string(_entry.title);
        _writer.write(",");
        _writer.write_key("team");
        
        if (is_nonempty_string(_entry.team[$ "name"])) {
            _writer.write("{");
            _writer.write_key("name");
            _writer.write_string(_entry.team.name);
            _writer.write(",");
            _writer.write_key("authors");
        }
        _writer.write_inline_array(_entry.team.authors, DbJamWriter.write_author);
        if (is_nonempty_string(_entry.team[$ "name"])) {
            _writer.write("}");
        }
        
        _writer.write("}");
    }
    
    static write_author = function(_writer, _author) {
        if (string_lower(_author.name) == string_lower(_author.participant.name)) {
            _writer.write_string(_author.id);
        } else {
            _writer.write("{");
            _writer.write_key("id");
            _writer.write_string(_author.id);
            _writer.write(",");
            _writer.write_key("alias");
            _writer.write_string(_author.name);
            _writer.write("}");
        }
    }
    
    // -------
    // Results
    // -------
    
    static write_results = function(_writer, _data) {
        _writer.write("{");
        
        var _next = false;
        if (is_nonempty_array(_data.ranking)) {
            _next = _writer.write_key("ranking", _next);
            _writer.write_multiline_array(_data.ranking, DbJamWriter.write_ranking_entry);
        }
        
        if (is_nonempty_array(_data.awards)) {
            _next = _writer.write_key("awards", _next);
            _writer.write_multiline_array(_data.awards, DbJamWriter.write_award_entry);
        }
        
        _writer.write("\n}");
    }
    
    static write_ranking_entry = function(_writer, _entry) {
        _writer.write_string(_entry.page_id);
    }
    
    static write_award_entry = function(_writer, _entry) {
        _writer.write("{");
        _writer.write_key("id");
        _writer.write_string(_entry.id);
        _writer.write(",");
        _writer.write_key("name");
        _writer.write_string(_entry.name);
        _writer.write(",");
        _writer.write_key("winners");
        
        if (_entry.awarded_to == "participant") {
            _writer.write_inline_array(_entry.winners, function(_writer, _winner) {
                _writer.write_string(_winner.id);
            });
            _writer.write(",");
            _writer.write_key("awardedTo");
            _writer.write_string("participant");
        } else {
            _writer.write_inline_array(_entry.winners, function(_writer, _winner) {
                _writer.write_string(_winner.page_id);
            });
        }
        _writer.write("}");
    }
}
