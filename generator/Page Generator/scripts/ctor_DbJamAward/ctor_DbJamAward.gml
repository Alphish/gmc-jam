function DbJamAward(_jam, _data, _db) constructor {
    jam = _jam;
    data = _data;
    
    id = _data.id;
    name = _data.name;
    awarded_to = string_lower(_data[$ "awardedTo"] ?? "entry");
    
    var _winners_data = _data.winners;
    winners = array_map(_winners_data, method({ jam: _jam, database: _db, awarded_to }, function(_id) {
        switch (awarded_to) {
            case "entry":
                return jam.entries_by_id[$ _id];
            case "participant":
                return database.participants_by_id[$ _id];
        }
    }));
}
