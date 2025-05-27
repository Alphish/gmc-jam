database = new Database();

var _project_filename = string_replace_all(GM_project_filename, "\\", "/");
var _project_directory = string_copy(_project_filename, 1, string_last_pos("/", _project_filename));
var _datafiles_directory = _project_directory + "datafiles/";

remaining_participant_files = file_find_all(_datafiles_directory, "*.participants.json");
