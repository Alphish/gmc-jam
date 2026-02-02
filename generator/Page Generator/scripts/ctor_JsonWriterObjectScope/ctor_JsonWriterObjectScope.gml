function JsonWriterObjectScope(_writer, _multiline) : JsonWriterScope(_writer) constructor {
    multiline = _multiline;
    got_first_entry = false;
    
    static init = function() {
        writer.write("{");
    }
    
    static prepare_value = function() {
        // do nothing, at this point the writer should be after entry key
    }
    
    static prepare_entry = function() {
        if (got_first_entry)
            writer.write(",");
        
        if (multiline)
            writer.write("\n");
        
        got_first_entry = true;
    }
    
    static end_object = function() {
        if (got_first_entry && multiline)
            writer.write("\n");
        
        writer.write("}");
        array_pop(writer.scopes);
    }
    
    static end_array = function() {
        throw $"{instanceof(self)} is an object scope and cannot end array.";
    }
}