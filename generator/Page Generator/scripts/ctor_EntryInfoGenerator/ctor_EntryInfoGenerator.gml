function EntryInfoGenerator() constructor {
    static generate_content = function(_entry) {
        var _writer = new JsonWriter();
        
        _writer.begin_multiline_object();
        
        _writer.write_key("jam");
        _writer.begin_inline_array();
        _writer.write_string(_entry.jam.id);
        _writer.write_string(_entry.jam.title);
        _writer.end_array();
        
        _writer.write_string_entry_if_any("title", _entry.name);
        _writer.write_string_entry_if_any("thumbnailPath", _entry.jam.logo_path);
        _writer.write_string_entry_if_any("team", _entry.team[$ "name"]);
        _writer.write_inline_array_entry_if_any("authors", _entry.team.authors, function(_writer, _author) {
            _writer.begin_inline_array();
            _writer.write_string(_author.id);
            _writer.write_string(_author.name);
            _writer.end_array();
        });
        
        _writer.write_multiline_array_entry_if_any("links", _entry[$ "links"], function(_writer, _link) {
            _writer.begin_inline_object();
            _writer.write_string_entry_if_any("title", _link.title);
            _writer.write_string_entry_if_any("url", _link.url);
            _writer.end_object();
        });
        
        _writer.write_value_entry_if_any("rank", _entry.rank);
        _writer.write_inline_array_entry_if_any("awards", _entry.awards, function(_writer, _award) {
            _writer.begin_inline_array();
            _writer.write_string(_award.id);
            _writer.write_string(_award.name);
            _writer.end_array();
        });
        
        _writer.end_object();
        
        return _writer.get_content();
    }
}
