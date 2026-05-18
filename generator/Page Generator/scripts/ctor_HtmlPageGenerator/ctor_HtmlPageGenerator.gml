function HtmlPageGenerator(_page_template) constructor {
    page_template = _page_template;
    
    static generate_content = function(_pagecontent, _pagedata) {
        static delimiters = ["\r\n", "\r", "\n"];
        
        var _content_lines = string_split_ext(string_trim_end(_pagecontent, ["\n"]), delimiters);
        var _indented_lines = array_map(_content_lines, function(_str) { return "      " + _str; });
        var _indent_content = string_join_ext("\n", _indented_lines);
        
        var _scripts_preload = string_join_ext("\n", array_map(_pagedata.scripts, function(_scriptname) {
            return $"    <link rel=\"modulepreload\" href=\"/js/{_scriptname}.js\" />";
        }));
        var _scripts_load = string_join_ext("\n", array_map(
            array_filter(_pagedata.scripts, function(_scriptname) { return _scriptname != "common"; }),
            function(_scriptname) { return $"    <script src=\"/js/{_scriptname}.js\" type=\"module\"></script>";}
            ));
        var _stylesheets_link = string_join_ext("\n", array_map(_pagedata.stylesheets, function(_stylename) {
            return $"    <link rel=\"stylesheet\" media=\"screen\" href=\"/css/{_stylename}.css\">";
        }));
        
        return string(page_template, _indent_content, _pagedata.title, _scripts_preload, _scripts_load, _stylesheets_link)
    }
}