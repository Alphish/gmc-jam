function DbJamTeam(_data, _db) constructor {
    data = _data;
    
    var _authors_data = _data;
    authors = array_map(_authors_data, method({ database: _db }, function(_id) {
        return database.participants_by_id[$ _id];
    }));
}