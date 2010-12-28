xquery version "1.0-ml";

(:
 : Copyright 2009 Ontario Council of University Libraries
 : 
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 : 
 :    http://www.apache.org/licenses/LICENSE-2.0
 : 
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)

module namespace xqmvc-controller = "http://scholarsportal.info/xqmvc/controller";
import module namespace xqmvc = "http://scholarsportal.info/xqmvc/core" at "../../../system/xqmvc.xqy";

import module namespace cfg = "http://scholarsportal.info/xqmvc/langedit/config" at "../config/config.xqy";
import module namespace lang = "http://scholarsportal.info/xqmvc/langedit/m/lang" at "../models/lang-model.xqy";
import module namespace editor = "http://scholarsportal.info/xqmvc/langedit/m/editor" at "../models/editor-model.xqy";

declare function index()
{
    let $lang := xdmp:get-request-field('lang', '')
    let $filter := xdmp:get-request-field('filter', '')
    let $path := lang:path($lang)
    return
        xqmvc:plugin-template($cfg:plugin-name, 'master-template', (
            'body',
                
                if (fn:not($lang)) then
                    _not-specified()
                
                else if (fn:not(fn:doc-available($path))) then
                    _not-found($lang)
                
                else
                    xqmvc:plugin-view($cfg:plugin-name, 'main-view', (
                        'lang', $lang,
                        'filter', $filter,
                        'path', $path
                    ))
        ))
};

declare function _not-specified()
{
    xqmvc:plugin-view($cfg:plugin-name, 'error-lang-not-specified-view')
};

declare function _not-found($lang as xs:string?)
{
    xqmvc:plugin-view($cfg:plugin-name, 'error-lang-not-found-view', (
        'lang', $lang
    ))
};

declare function lang-create()
{
    let $lang := xdmp:get-request-field('lang')
    return (
        editor:lang-create($lang),
        xqmvc:redirect(xqmvc:plugin-link($cfg:plugin-name, 'editor', 'index', 
            ('lang', $lang)))
    )
};

declare function lang-delete()
{
    let $lang := xdmp:get-request-field('lang')
    return (
        editor:lang-delete($lang),
        xqmvc:redirect(xqmvc:plugin-link($cfg:plugin-name, 'editor', 'index'))
    )
};

declare function value-save-all()
{
    let $lang := xdmp:get-request-field('lang')
    let $filter := xdmp:get-request-field('filter')
    return (
    
        for $field in xdmp:get-request-field-names()
        return
            if (fn:starts-with($field, '__key__')) then
                let $id := fn:substring-after($field, '__key__')
                let $key := xdmp:get-request-field($field)
                let $text := xdmp:get-request-field(fn:concat('__text__', $id))
                return
                    editor:value-update($lang, $id, $key, $text)
            else ()
        ,
        xqmvc:redirect(xqmvc:plugin-link($cfg:plugin-name, 'editor', 'index',
            ('lang', $lang, 'filter', $filter)))
    )
};

declare function value-create()
{
    let $lang := xdmp:get-request-field('lang')
    let $filter := xdmp:get-request-field('filter')
    let $key := xdmp:get-request-field('key')
    return (
        editor:value-create($key),
        xqmvc:redirect(xqmvc:plugin-link($cfg:plugin-name, 'editor', 'index', 
            ('lang', $lang, 'filter', $filter)))
    )
};

declare function value-delete()
{
    let $lang := xdmp:get-request-field('lang')
    let $id := xdmp:get-request-field('id')
    return (
        editor:value-delete($id),
        xqmvc:redirect(xqmvc:plugin-link($cfg:plugin-name, 'editor', 'index',
            ('lang', $lang)))
    )
};