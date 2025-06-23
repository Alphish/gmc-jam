/// @func file_read_all_text(filename)
/// @desc Reads entire content of a given file as a string, or returns undefined if the file couldn't be read.
/// @arg {String} filename          The path of the file to read the content of.
/// @returns {Undefined,String}
function file_read_all_text(_filename) {
    var _buffer = buffer_load(_filename);
    if (!buffer_exists(_buffer))
        return undefined;
    
    if (buffer_get_size(_buffer) == 0)
        return "";
    
    var _result = buffer_read(_buffer, buffer_text);
    buffer_delete(_buffer);
    return _result;
}

/// @func file_write_all_text(filename,content)
/// @desc Creates or overwrites a given file with the given string content.
/// @arg {String} filename          The path of the file to create/overwrite.
/// @arg {String} content           The content to create/overwrite the file with.
function file_write_all_text(_filename, _content) {
    var _buffer = buffer_create(string_length(_content), buffer_grow, 1);
    buffer_write(_buffer, buffer_text, _content);
    buffer_save(_buffer, _filename);
    buffer_delete(_buffer);
}

/// @func file_find_all(directory,mask)
/// @desc Finds all files matching the given mask and returns an array of their paths.
/// @arg {String} directory         The path of the directory of the files to list.
/// @arg {String} mask              The mask of the files to find.
/// @returns {Array<String>}
function file_find_all(_directory, _mask) {
    _directory = string_replace_all(_directory, "\\", "/");
    _directory = !string_ends_with(_directory, "/") ? _directory + "/" : _directory;
    var _query = _directory + _mask;
    
    var _result = [];
    var _entry = _directory + file_find_first(_mask, fa_none);
    while (file_exists(_entry)) {
        array_push(_result, _entry);
        _entry = _directory + file_find_next();
    }
    file_find_close();
    return _result;
}
