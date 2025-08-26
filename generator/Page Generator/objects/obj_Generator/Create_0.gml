filesystem = Filesystem.instance;
database = Database.instance;

remaining_participant_files = filesystem.get_datafiles("*.participants.json");

remaining_imports = [];

remaining_jam_files = filesystem.get_datafiles("*.jam.json");
remaining_jams = [];

jam_generator = new JamDataGenerator();
