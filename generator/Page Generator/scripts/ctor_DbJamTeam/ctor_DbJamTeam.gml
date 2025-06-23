function DbJamTeam(_data) constructor {
    data = _data;
    
    var _authors_data = _data;
    authors = array_map(_authors_data, function(_data) {
        if (is_string(_data))
            return Database.get_participant(_data);
        else
            return new DbJamAuthor(_data);
    });
}