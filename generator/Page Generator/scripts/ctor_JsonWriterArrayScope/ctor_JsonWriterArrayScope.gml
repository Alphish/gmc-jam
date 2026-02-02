function JsonWriterArrayScope(_writer, _multiline) : JsonWriterScope(_writer) constructor {
    multiline = _multiline;
    got_first_item = false;
    
    static init = function() {
        writer.write("[");
    }
    
    static prepare_value = function() {
        if (got_first_item)
            writer.write(",");
        
        if (multiline)
            writer.write("\n");
        
        got_first_item = true;
    }
    
    static prepare_entry = function() {
        throw $"{instanceof(self)} is an array scope and cannot contain object entries.";
    }
    
    static end_object = function() {
        throw $"{instanceof(self)} is an array scope and cannot end object.";
    }
    
    static end_array = function() {
        if (got_first_item && multiline)
            writer.write("\n");
        
        writer.write("]");
        array_pop(writer.scopes);
    }
}