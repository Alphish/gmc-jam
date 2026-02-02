function JsonWriterScope(_writer) constructor {
    writer = _writer;
    
    static init = function() {
        throw $"{instanceof(self)}.init is not implemented.";
    }
    
    static prepare_value = function() {
        throw $"{instanceof(self)}.prepare_value is not implemented.";
    }
    
    static prepare_entry = function() {
        throw $"{instanceof(self)}.prepare_entry is not implemented.";
    }
    
    static write_value = function(_value) {
        prepare_value();
        writer.write(string(_value));
    }
    
    static write_string = function(_str) {
        prepare_value();
        var _json = json_stringify(_str);
        _json = string_replace_all(_json, "\\/", "/");
        writer.write(_json);
    }
    
    static write_key = function(_str) {
        prepare_entry();
        var _json = json_stringify(_str);
        _json = string_replace_all(_json, "\\/", "/");
        writer.write(_json);
        writer.write(":");
    }
    
    static end_object = function() {
        throw $"{instanceof(self)}.end_object is not implemented.";
    }
    
    static end_array = function() {
        throw $"{instanceof(self)}.end_array is not implemented.";
    }
}
