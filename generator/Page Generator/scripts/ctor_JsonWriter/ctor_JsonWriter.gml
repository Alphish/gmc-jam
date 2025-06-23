function JsonWriter() : StringWriter() constructor {
    static write_string = function(_str) {
        write($"\"{_str}\"");
    }
    
    static write_inline_array = function(_array, _itemfunc) {
        write("[");
        for (var i = 0, _count = array_length(_array); i < _count; i++) {
            if (i > 0)
                write(",");
            
            _itemfunc(self, _array[i]);
        }
        write("]");
    }
    
    static write_multiline_array = function(_array, _itemfunc) {
        write("[");
        for (var i = 0, _count = array_length(_array); i < _count; i++) {
            if (i > 0)
                write(",");
            
            write("\n");
            _itemfunc(self, _array[i]);
        }
        write("\n]");
    }
    
    static write_key = function(_str, _next = undefined) {
        if (_next == true)
            write(",\n");
        else if (_next == false)
            write("\n");
        
        write("\"" + _str + "\":");
        return true;
    }
}
