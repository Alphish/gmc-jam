function DbJamEntry(_jam, _data) constructor {
    jam = _jam;
    data = _data;
    
    id = _data.id;
    name = _data.name;
    team = new DbJamTeam(_data.team);
}