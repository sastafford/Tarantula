xquery version "1.0-ml";
import module namespace xqmvc = "http://scholarsportal.info/xqmvc/core" at "../../../system/xqmvc.xqy";
import module namespace cfg = "http://scholarsportal.info/xqmvc/langedit/config" at "../config/config.xqy";
import module namespace editor = "http://scholarsportal.info/xqmvc/langedit/m/editor" at "../models/editor-model.xqy";
declare variable $data as map:map external;

declare variable $INPUT-EMPTY-SIZE as xs:integer := 50;
declare variable $INPUT-MAX-SIZE as xs:integer := 50;

<div xmlns="http://www.w3.org/1999/xhtml">
    <div class="langs">
        <div style="float: left; width: 59%; text-align: left;">{
            xqmvc:plugin-view($cfg:plugin-name, 'langs-view', (
                'current', map:get($data, 'lang')
            ))
        }</div>
        <div style="float: right; width: 39%; text-align: right;">
            <form method="get">
                { xqmvc:plugin-formlink($cfg:plugin-name, 'editor', 'index') }
                <div>
                    <input type="text" name="lang" value="" />
                    <input type="submit" value="create lang" />
                </div>
            </form>
            <form action="{ xqmvc:plugin-link($cfg:plugin-name, 'editor', 'lang-delete') }" method="post"
                    onclick="return confirm('Are you sure you wish to delete language [{ map:get($data, 'lang') }]?');">
                <div>
                    <input type="hidden" name="lang" value="{ map:get($data, 'lang') }" />
                    <input type="submit" value="delete [{ map:get($data, 'lang') }]" />
                </div>
            </form>
        </div>
        <div style="clear: both;">{' '}</div>
    </div>
    
    <div class="controls">
        <div class="new">
            <form action="{ xqmvc:plugin-link($cfg:plugin-name, 'editor', 'value-create') }" method="post">
                <div>
                    <input type="hidden" name="lang" value="{ map:get($data, 'lang') }" />
                    <input type="hidden" name="filter" value="{ map:get($data, 'filter') }" />
                    <input id="focus" type="text" name="key" value="" />
                    <input type="submit" value="create" />
                </div>
            </form>
        </div>
        <div class="filter">
            <form method="get">
                { xqmvc:apply-namespace(xqmvc:plugin-formlink($cfg:plugin-name, 'editor', 'index'), 'http://www.w3.org/1999/xhtml') }
                <div>
                    <input type="hidden" name="lang" value="{ map:get($data, 'lang') }" />
                    <input type="text" name="filter" value="{ map:get($data, 'filter') }" />
                    <input type="submit" value="filter" />
                    [<a href="{ xqmvc:plugin-link($cfg:plugin-name, 'editor', 'index', ('lang', map:get($data, 'lang'))) }">clear</a>]
                </div>
            </form>
        </div>
    </div>
    
    <form action="{ xqmvc:plugin-link($cfg:plugin-name, 'editor', 'value-save-all') }" method="post">
        
        <div class="values">
            
            <input type="hidden" name="lang" value="{ map:get($data, 'lang') }" />
            <input type="hidden" name="filter" value="{ map:get($data, 'filter') }" />
            <input type="submit" value="save all" />{
            
            let $categories := editor:category-list(map:get($data, 'lang'))
            return
                if (not($categories)) then
                    <div class="novalues">
                        No values found.
                        Create one using dot-notation for hierarchy: 'cat.subcat.key'
                    </div>
                else
                    for $category in $categories
                    order by $category
                    return
                        let $values := editor:value-list(map:get($data, 'lang'), map:get($data, 'filter'))[$category eq editor:value-key-category(.)]
                        where exists($values)
                        return
                            <table>{
                                for $value in $values
                                return
                                    let $id := string($value/@id)
                                    let $key := string($value/@key)
                                    let $key-cat := editor:key-category($key)
                                    let $key-name := editor:key-name($key)
                                    let $text := editor:value-text($value)
                                    return
                                        <tr>
                                            <td>{
                                                
                                                element input {
                                                    attribute name { concat("__key__", $id) },
                                                    attribute type { "text" },
                                                    attribute size { if ($key) then string-length($key) + 1 else $INPUT-EMPTY-SIZE },
                                                    attribute value { $key },
                                                    attribute class { 'key' }
                                                }
                                            }</td>
                                            <td>&nbsp;=&nbsp;</td>
                                            <td>{
                                                if (string-length($text) gt $INPUT-MAX-SIZE) then
                                                    element textarea {
                                                        attribute name { concat("__text__", $id) },
                                                        attribute cols { $INPUT-MAX-SIZE },
                                                        attribute rows { "3" },
                                                        $text
                                                    }
                                                else
                                                    element input {
                                                        attribute name { concat("__text__", $id) },
                                                        attribute type { "text" },
                                                        attribute size { if ($text) then string-length($text) + 1 else $INPUT-EMPTY-SIZE },
                                                        attribute value { $text },
                                                        attribute class { 'text' }
                                                    }
                                                ,
                                                <span> [<a href="{ xqmvc:plugin-link($cfg:plugin-name, 'editor', 'value-delete', ('lang', map:get($data, 'lang'), 'id', $id)) }" title='delete-phrase'>x</a>]</span>
                                            }</td>
                                        </tr>
                            }</table>
            
            }<input type="submit" value="save all" />
            
        </div>
    </form>
</div>