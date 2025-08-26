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
        
        if (!is_undefined(_data.links)) {
            _next = _writer.write_key("links", _next);
            _writer.write_multiline_array(_data.links, DbJamWriter.write_link);
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
}
