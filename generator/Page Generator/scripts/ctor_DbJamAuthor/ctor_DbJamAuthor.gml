function DbJamAuthor(_id) constructor {
    id = _id;
    participant = Database.get_participant(id);
    name = participant.name;
}
