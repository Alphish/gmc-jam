function DbJamEntry(_jam, _id) constructor {
    jam = _jam;
    id = _id;
    
    name = undefined;
    team = undefined;
    
    rank = undefined;
    awards = undefined;
    
    static populate_from_data = function(_data) {
        name = _data[$ "name"] ?? name;
        if (struct_exists(_data, "team"))
            team = new DbJamTeam(_data.team);
    }
    
    static complete_from_data = function(_data) {
        name ??= _data[$ "name"];
        if (struct_exists(_data, "team"))
            team ??= new DbJamTeam(_data.team);
    }
}