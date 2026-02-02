function JsonWriter() : StringWriter() constructor {
    scopes = [];
    
    static write_key = function(_str) {
        array_last(scopes).write_key(_str);
    }
    
    static write_value = function(_str) {
        array_last(scopes).write_value(_str);
    }
    
    static write_string = function(_str) {
        array_last(scopes).write_string(_str);
    }
    
    static begin_inline_object = function() {
        if (array_length(scopes) > 0)
            array_last(scopes).prepare_value();
        
        var _scope = new JsonWriterObjectScope(self, false);
        array_push(self.scopes, _scope);
        _scope.init();
    }
    
    static begin_multiline_object = function() {
        if (array_length(scopes) > 0)
            array_last(scopes).prepare_value();
        
        var _scope = new JsonWriterObjectScope(self, true);
        array_push(self.scopes, _scope);
        _scope.init();
    }
    
    static begin_inline_array = function() {
        if (array_length(scopes) > 0)
            array_last(scopes).prepare_value();
        
        var _scope = new JsonWriterArrayScope(self, false);
        array_push(self.scopes, _scope);
        _scope.init();
    }
    
    static begin_multiline_array = function() {
        if (array_length(scopes) > 0)
            array_last(scopes).prepare_value();
        
        var _scope = new JsonWriterArrayScope(self, true);
        array_push(self.scopes, _scope);
        _scope.init();
    }
    
    static end_object = function() {
        array_last(scopes).end_object();
    }
    
    static end_array = function() {
        array_last(scopes).end_array();
    }
    
    // --------------
    // Writing values
    // --------------
    
    static write_value_if_any = function(_value) {
        if (is_undefined(_value))
            return;
        
        write_value(_value);
    }
    
    static write_string_if_any = function(_str) {
        if (is_undefined(_str) || _str == "")
            return;
        
        write_string(_str);
    }
    
    static write_inline_array_if_any = function(_array, _itemwrite) {
        if (is_undefined(_array) || array_length(_array) == 0)
            return;
        
        begin_inline_array();
        for (var i = 0, _count = array_length(_array); i < _count; i++) {
            _itemwrite(self, _array[i]);
        }
        end_array();
    }
    
    static write_multiline_array_if_any = function(_array, _itemwrite) {
        if (is_undefined(_array) || array_length(_array) == 0)
            return;
        
        begin_multiline_array();
        for (var i = 0, _count = array_length(_array); i < _count; i++) {
            _itemwrite(self, _array[i]);
        }
        end_array();
    }
    
    static write_inline_object_if_any = function(_struct, _itemwrite) {
        if (is_undefined(_struct) || struct_names_count(_struct) == 0)
            return;
        
        begin_inline_object();
        var _keys = struct_get_names(_struct);
        array_sort(_keys, true);
        for (var i = 0, _count = array_length(_keys); i < _count; i++) {
            write_key(_keys[i]);
            _itemwrite(self, _struct[$ _keys[i]]);
        }
        end_object();
    }
    
    static write_multiline_object_if_any = function(_struct, _itemwrite) {
        if (is_undefined(_struct) || struct_names_count(_struct) == 0)
            return;
        
        begin_inline_object();
        var _keys = struct_get_names(_struct);
        array_sort(_keys, true);
        for (var i = 0, _count = array_length(_keys); i < _count; i++) {
            write_key(_keys[i]);
            _itemwrite(self, _struct[$ _keys[i]]);
        }
        end_object();
    }
    
    // ---------------
    // Writing entries
    // ---------------
    
    static write_value_entry_if_any = function(_key, _value) {
        if (is_undefined(_value))
            return;
        
        write_key(_key);
        write_value(_value);
    }
    
    static write_string_entry_if_any = function(_key, _str) {
        if (is_undefined(_str) || _str == "")
            return;
        
        write_key(_key);
        write_string(_str);
    }
    
    static write_inline_array_entry_if_any = function(_key, _array, _itemwrite) {
        if (is_undefined(_array) || array_length(_array) == 0)
            return;
        
        write_key(_key);
        write_inline_array_if_any(_array, _itemwrite);
    }
    
    static write_multiline_array_entry_if_any = function(_key, _array, _itemwrite) {
        if (is_undefined(_array) || array_length(_array) == 0)
            return;
        
        write_key(_key);
        write_multiline_array_if_any(_array, _itemwrite);
    }
    
    static write_inline_object_entry_if_any = function(_key, _struct, _itemwrite) {
        if (is_undefined(_struct) || struct_names_count(_struct) == 0)
            return;
        
        write_key(_key);
        write_inline_object_if_any(_struct, _itemwrite);
    }
    
    static write_multiline_object_entry_if_any = function(_key, _struct, _itemwrite) {
        if (is_undefined(_struct) || struct_names_count(_struct) == 0)
            return;
        
        write_key(_key);
        write_multiline_object_if_any(_struct, _itemwrite);
    }
}
