function StringWriter() constructor {
    buffer = buffer_create(1024, buffer_grow, 1);
    
    static write = function(_str) {
        buffer_write(buffer, buffer_text, _str);
    }
    
    static get_content = function() {
        buffer_seek(buffer, buffer_seek_start, 0);
        return buffer_read(buffer, buffer_string);
    }
}
