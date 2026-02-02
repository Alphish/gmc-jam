function DbJamTeam(_data) constructor {
    data = _data;
    
    name = is_struct(_data) ? _data[$ "name"] : undefined;
    
    var _authors_data = is_array(_data) ? _data : _data.authors;
    authors = array_map(_authors_data, function(_data) {
        if (is_string(_data))
            return new DbJamAuthor(_data);
        
        var _author = new DbJamAuthor(_data.id);
        _author.name = _data[$ "alias"] ?? _author.name;
        return _author;
    });
}
