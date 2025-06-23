function Filesystem() constructor {
    project_directory = filename_dir(GM_project_filename) + "\\";
    datafiles_directory = project_directory + "datafiles\\";
    
    repo_directory = filename_dir(filename_dir(filename_dir(project_directory))) + "\\";
    docs_directory = repo_directory + "docs\\";
    
    static get_datafiles = function(_mask) {
        return file_find_all(datafiles_directory, _mask);
    }
    
    static get_jam_directory = function(_id) {
        return $"{Filesystem.instance.docs_directory}jams\\{_id}\\";
    }
}

Filesystem.instance = new Filesystem();
