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

remaining_pages = [
    new HtmlPageData("entryview", "GMC Jam", ["common", "entryview"], ["styles", "entryview"]),
    new HtmlPageData("halloffame", "Hall of Fame | GMC Jam", ["common", "halloffame"], ["styles", "halloffame"]),
    new HtmlPageData("index", "GMC Jam Home", ["countdown"], ["styles", "countdown"]),
    new HtmlPageData("jamlist", "List of Jams | GMC Jam", ["jamlist"], ["styles", "jamlist"]),
    new HtmlPageData("jamview", "GMC Jam", ["common", "jamview"], ["styles", "jamview"]),
    new HtmlPageData("participantview", "GMC Jam", ["common", "participantview"], ["styles", "participantview"]),
];

dbjam_writer = new DbJamWriter();
jam_generator = new JamInfoGenerator();
entry_generator = new EntryInfoGenerator();
participant_generator = new ParticipantInfoGenerator();
trophy_generator = new TrophyInfoGenerator();

var _page_template = file_read_all_text(filesystem.datafiles_directory + "pages\\common.template.html");
html_page_generator = new HtmlPageGenerator(_page_template);
