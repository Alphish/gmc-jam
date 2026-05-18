filesystem = Filesystem.instance;
database = Database.instance;

remaining_participant_files = filesystem.get_datafiles("*.participants.json");
remaining_participants = [];

remaining_imports = [
];

remaining_jam_files = filesystem.get_datafiles("*.jam.json");
array_sort(remaining_jam_files, /* ascending */ false);
remaining_jams = undefined;
trophies_exported = false;

dbjam_writer = new DbJamWriter();
jam_generator = new JamInfoGenerator();
entry_generator = new EntryInfoGenerator();
participant_generator = new ParticipantInfoGenerator();
trophy_generator = new TrophyInfoGenerator();
