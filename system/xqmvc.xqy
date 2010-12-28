xquery version "1.0-ml";

(:
 : Copyright 2009 Ontario Council of University Libraries
 : 
 : Licensed     under the Apache License, Version 2.0 (the "License");
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

(:~
 : The core of xqmvc.  Loads and executes functions within controllers, invokes
 : views and templates, and provides basic linking and querystring building.
 :)
module namespace xqmvc = "http://scholarsportal.info/xqmvc/core";
import module namespace xqmvc-conf = "http://scholarsportal.info/xqmvc/config" at "../application/config/config.xqy";
declare namespace xqmvc-ctrlr = "http://scholarsportal.info/xqmvc/controller";

declare variable $controller-dir as xs:string := fn:concat($xqmvc-conf:app-root, '/application/controllers');
declare variable $view-dir as xs:string := fn:concat($xqmvc-conf:app-root, '/application/views');
declare variable $template-dir as xs:string := fn:concat($xqmvc-conf:app-root, '/application/templates');
declare variable $plugin-dir as xs:string := fn:concat($xqmvc-conf:app-root, '/plugins');

declare variable $resource-dir as xs:string := fn:concat($xqmvc-conf:app-root, '/application/resources');
declare variable $plugin-resource-dir as xs:string := fn:concat($xqmvc-conf:app-root, '/plugins/', current-plugin(), '/resources');
declare variable $library-dir as xs:string := fn:concat($xqmvc-conf:app-root, '/application/libraries');
declare variable $plugin-library-dir as xs:string := fn:concat($xqmvc-conf:app-root, '/plugins/', current-plugin(), '/libraries');

declare variable $doctype-html-4.01-strict :=       '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">';
declare variable $doctype-html-4.01-transitional := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">';
declare variable $doctype-html-4.01-frameset :=     '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">';
declare variable $doctype-xhtml-1.0-strict :=       '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">';
declare variable $doctype-xhtml-1.0-transitional := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
declare variable $doctype-xhtml-1.0-frameset :=     '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">';
declare variable $doctype-xhtml-1.1 :=              '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">';

(:~
 : Loads a controller, and executes a zero-argument function within that 
 : controller.
 :)
declare function _controller($controller-file as xs:string,
    $function as xs:string)
as item()*
{
    if (fn:starts-with($function, '_')) then
        ()
    else
        let $import-declaration := fn:concat(
            'import module namespace xqmvc-ctrlr = ',
            '"http://scholarsportal.info/xqmvc/controller" at ',
            '"', $controller-file, '";'
        )
        let $function-call := fn:concat('xqmvc-ctrlr:', $function, '()')
        return
            xdmp:eval(fn:concat($import-declaration, $function-call),
                (),
                <options xmlns="xdmp:eval">
                    <isolation>different-transaction</isolation>
                    <prevent-deadlocks>true</prevent-deadlocks>
                </options>
            )
};

declare function controller($controller as xs:string, $function as xs:string)
as item()*
{
    let $controller-file := fn:concat($controller-dir, '/', $controller, '.xqy')
    return
        _controller(
            $controller-file,
            $function
        )
};

declare function plugin-controller($plugin as xs:string, 
    $controller as xs:string, $function as xs:string)
as item()*
{
    let $controller-file := fn:concat($plugin-dir, '/', $plugin, 
        '/controllers/', $controller, '.xqy')
    return
        _controller(
            $controller-file,
            $function
        )
};

(:~
 : Invokes and returns the contents of a view.
 : 
 : Optionally accepts a sequence of key-value pairs to use and/or display within
 : the view.  This sequence must contain an even number of items.
 :)
declare function _view($view-file as xs:string, $pairs as item()*)
as item()*
{
    xdmp:invoke($view-file,
        (xs:QName("data"), sequence-to-map($pairs)),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
            <prevent-deadlocks>true</prevent-deadlocks>
        </options>
    )
};

declare function view($view as xs:string, $pairs as item()*)
as item()*
{
    let $view-file := fn:concat($view-dir, '/', $view, '.xqy')
    return
        _view($view-file, $pairs)
};

declare function view($view as xs:string)
as item()*
{
    view($view, ())
};

declare function plugin-view($plugin as xs:string, $view as xs:string, 
    $pairs as item()*)
as item()*
{
    let $view-file := fn:concat($plugin-dir, '/', $plugin, '/views/', $view, 
        '.xqy')
    return
        _view($view-file, $pairs)
};

declare function plugin-view($plugin as xs:string, $view as xs:string)
as item()*
{
    plugin-view($plugin, $view, ())
};

(:~
 : Invokes and returns the contents of a template.
 : 
 : Optionally accepts a sequence of key-value pairs to embed as internal 
 : content within the template.  This sequence must contain an even number of 
 : items.
 :)
declare function _template($template-file as xs:string, $pairs as item()*)
as item()*
{
    _view($template-file, $pairs)
};

declare function template($template as xs:string, $pairs as item()*)
as item()*
{
    let $template-file := fn:concat($template-dir, '/', $template, '.xqy')
    return
        _template(
            $template-file,
            $pairs
        )
};

declare function template($template as xs:string)
as item()*
{
    template($template, ())
};

declare function plugin-template($plugin as xs:string, 
    $template as xs:string, $pairs as item()*)
as item()*
{
    let $template-file := fn:concat($plugin-dir, '/', $plugin, '/templates/',
        $template, '.xqy')
    return
        _template(
            $template-file,
            $pairs
        )
};

declare function plugin-template($plugin as xs:string, $template as xs:string)
as item()*
{
    plugin-template($plugin, $template, ())
};

(:~
 : Generates a URL string pointing to the specified controller / function, for 
 : use in href= and action= attributes of html anchors and forms.  This function
 : should be used exclusively within a webapp when linking to internal pages.
 :
 : Note: Use _formlink for forms with method="get".
 : 
 : Optionally accepts a sequence of paired items to append as a query string.  
 : This sequence must contain an even number of items.
 :)
declare function _link($plugin as xs:string?, $controller as xs:string, 
    $function as xs:string, $querystring-pairs as item()*)
as xs:string
{
    fn:concat(
        
        $xqmvc-conf:app-root,
        
        if ($xqmvc-conf:url-rewrite) then
            fn:concat(
                if (fn:not($plugin)) then ()
                else fn:concat('/', $plugin),
                '/', $controller,
                '/', $function, 
                $xqmvc-conf:url-suffix,
                if ($querystring-pairs) then '?' else ()
            )
        else
            fn:concat(
                '/index.xqy?',
                if (fn:not($plugin)) then ()
                else fn:concat($xqmvc-conf:plugin-querystring-field, '=', 
                    $plugin, '&amp;'),
                $xqmvc-conf:controller-querystring-field, '=', $controller,
                '&amp;',
                $xqmvc-conf:function-querystring-field, '=', $function,
                if ($querystring-pairs) then '&amp;' else ()
            )
        ,
        querystring-join($querystring-pairs)
    )
};

declare function link($controller as xs:string, $function as xs:string, 
    $querystring-pairs as item()*)
as xs:string
{
    _link((), $controller, $function, $querystring-pairs)
};

declare function link($controller as xs:string, $function as xs:string)
as xs:string
{
    link($controller, $function, ())
};

declare function plugin-link($plugin as xs:string, $controller as xs:string, 
    $function as xs:string, $querystring-pairs as item()*)
as xs:string
{
    _link($plugin, $controller, $function, $querystring-pairs)
};

declare function plugin-link($plugin as xs:string, $controller as xs:string, 
    $function as xs:string)
as xs:string
{
    plugin-link($plugin, $controller, $function, ())
};

(:~
 : Generates depending on whether the app uses URL Rewriting or not, either an 
 : action attribute, or a set of hidden <input> elements, for forms with 
 : method="get" 
 :)
declare function _formlink($plugin as xs:string?, $controller as xs:string,
    $function as xs:string)
as item()*
{
    if ($xqmvc-conf:url-rewrite) then (
    
        attribute action { _link($plugin, $controller, $function, ()) }
        
    ) else (
        
        attribute action { '?' },
        
        <div>{
            element input {
                attribute type { 'hidden' },
                attribute name { $xqmvc-conf:controller-querystring-field },
                attribute value { $controller }
            },
            element input {
                attribute type { 'hidden' },
                attribute name { $xqmvc-conf:function-querystring-field },
                attribute value { $function }
            },
            if ($plugin) then
                element input {
                    attribute type { 'hidden' },
                    attribute name { $xqmvc-conf:plugin-querystring-field },
                    attribute value { $plugin }
                }
            else ()
        }</div>
        
    )
};

declare function formlink($controller as xs:string, $function as xs:string)
as item()*
{
    _formlink((), $controller, $function)
};

declare function plugin-formlink($plugin as xs:string, 
    $controller as xs:string, $function as xs:string)
as item()*
{
    _formlink($plugin, $controller, $function)
};

(:~
 : Redirects the App Server response to the specified location. This function is
 : typically used in conjunction with mvc:link, within controller functions 
 : which have updated some data, and wish to redirect to another controller / 
 : function.
 :)
declare function redirect($location as xs:string)
as empty-sequence()
{
    xdmp:redirect-response($location)
};

(:~
 : Generates a querystring based on pairs of items in a sequence.  The given
 : sequence must contain an even number of items.
 :
 : Ex: querystring-join(('x', '123', 'y', '456')) will produce x=123&y=546
 :)
declare function querystring-join($pairs as item()*)
as xs:string
{
    fn:string-join(
        for $i in (1 to fn:count($pairs))[. mod 2 ne 0]
          return fn:concat(fn:string($pairs[$i]), '=', fn:string($pairs[$i+1])),
          '&amp;'
      )
};

(:~
 : Generates a sequence of paired items based on a querystring.
 :
 : Ex: querystring-split('x=123&y=546') will produce ('x', '123', 'y', '456')
 :)
declare function querystring-split($querystring as xs:string*)
as xs:string*
{
    for $pair in fn:tokenize($querystring, '&amp;')
    let $key-value := fn:tokenize($pair, '=')
    return ($key-value[1], $key-value[2])
};

(:~
 : The controller being loaded by the current request. 
 :)
declare function current-controller()
as xs:string
{
    xdmp:get-request-field($xqmvc-conf:controller-querystring-field, 
        $xqmvc-conf:default-controller)
};

(:~
 : The function being executed by the current request. 
 :)
declare function current-function()
as xs:string
{
    xdmp:get-request-field($xqmvc-conf:function-querystring-field, 'index')
};

(:~
 : The plugin being used by the current request. 
 :)
declare function current-plugin()
as xs:string
{
    xdmp:get-request-field($xqmvc-conf:plugin-querystring-field, '')
};

(:~
 : Converts an even-length sequence of key-value pairs into a map:map().
 :)
declare function sequence-to-map($pairs as item()*)
as map:map
{
    let $map := map:map()
    let $put :=
        for $i in (1 to fn:count($pairs))[. mod 2 ne 0]
          return map:put($map, $pairs[$i], $pairs[$i+1])
    return $map
};

(:~
 : Recursively applies a namespace to an xml structure.
 :)
declare function apply-namespace($node as node(), $namespace as xs:string)
as node()*
{
    typeswitch ($node)
        case element() return
            element { fn:QName($namespace, fn:name($node)) } {
                $node/@*,
                for $n in $node/node() return apply-namespace($n, $namespace)
            }
        default return $node
};

(:~
 : Send some information to the log about what we're executing.
 :)
declare function log-status()
{
    xdmp:log(fn:concat(
        'app-root=[',     $xqmvc-conf:app-root    , '] ',
        'plugin=[',     current-plugin()        , '] ',
        'controller=[', current-controller()    , '] ',
        'function=[',     current-function()        , '] '
    ))
};