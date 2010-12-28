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
 
(:~
 : A module to create/edit/delete phrases from a database of languages.
 :)
module namespace this = "http://scholarsportal.info/xqmvc/langedit/m/editor";

import module namespace cfg = "http://scholarsportal.info/xqmvc/langedit/config" at "../config/config.xqy";

declare namespace le = "http://scholarsportal.info/xqmvc/langedit";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare variable $LANG-CHAR-PATTERN as xs:string := '[A-Za-z0-9\._-]';
declare variable $KEY-CHAR-PATTERN as xs:string := '[A-Za-z0-9\._-]';
declare variable $STRIP-CHARS as xs:string* := ('.', ' ');

declare function this:lang-list()
as xs:string*
{
    for $doc in xdmp:directory(concat($cfg:storage-dir, '/'))
    let $filename := base-uri($doc)
    let $lang := replace(tokenize($filename, '/')[last()], "(.*)\.xml", "$1")
    order by $lang
    return $lang
};

declare function this:lang-exists($lang as xs:string)
as xs:boolean
{
    doc-available(this:path($lang))
};

declare function this:lang-create($lang as xs:string)
as empty-sequence()
{
    let $lang := this:filter(this:strip($lang, $STRIP-CHARS), 
        $LANG-CHAR-PATTERN)
    return
        if (not($lang) or this:lang-exists($lang)) then ()
        else
            let $new-lang := 
                <le:lang xmlns:le="http://scholarsportal.info/xqmvc/langedit">{
                    let $existing-lang := this:lang-list()[1]
                    for $value in this:value-list($existing-lang, ())
                    return
                        element le:value { 
                            attribute id { $value/@id },
                            attribute key { $value/@key }
                        }
                }</le:lang>
            return
                xdmp:document-insert(this:path($lang), $new-lang)
};

declare function this:lang-delete($lang as xs:string)
as empty-sequence()
{
    if (not(this:lang-exists($lang))) then ()
    else xdmp:document-delete(this:path($lang))
};

declare function this:value-exists($id as xs:string)
as xs:boolean
{
    let $lang := this:lang-list()[1]
    return
        this:lang-exists($lang) and 
            exists(doc(this:path($lang))/le:lang/le:value[@id eq $id])
};

declare function this:value-create($key as xs:string)
as empty-sequence()
{
    let $key := this:filter(this:strip($key, $STRIP-CHARS), $KEY-CHAR-PATTERN)
    return
        if (not($key)) then ()
        else
            let $new-value := 
                element le:value { 
                    attribute id { xdmp:random() },
                    attribute key { $key }
                }
            return
                for $lang in this:lang-list()
                return
                    xdmp:node-insert-child(doc(this:path($lang))/le:lang, 
                        $new-value)
};

declare function this:value-retrieve($lang as xs:string, $id as xs:string)
as element(le:value)?
{
    doc(this:path($lang))/le:lang/le:value[@id eq $id]
};

declare function this:value-list($lang as xs:string, $filter as xs:string?)
as element(le:value)*
{
    let $values := doc(this:path($lang))/le:lang/le:value
    return
        if (not($filter)) then
            $values
        else
            for $value in $values
            where matches($value/@key, $filter)
            return $value 
};

declare function this:value-update($lang as xs:string, $id as xs:string,
    $key as xs:string, $text as xs:string)
{
    if (not(this:value-exists($id))) then ()
    else
        let $key := this:filter(this:strip($key, $STRIP-CHARS), 
            $KEY-CHAR-PATTERN)
        return
            if (not($key)) then ()
            else (
            
                (: replace key and text in current language :)
                let $old-value := this:value-retrieve($lang, $id)
                let $new-value := 
                    element le:value { 
                        attribute id { $old-value/@id },
                        attribute key { $key },
                        text { $text }
                    }
                return xdmp:node-replace($old-value, $new-value)
                
                ,
                
                (: replace key in other languages :)
                for $other-language in this:lang-list()
                where $other-language ne $lang
                return
                    let $old-value := this:value-retrieve($other-language, $id)
                    let $new-value := 
                        element le:value { 
                            attribute id { $old-value/@id },
                            attribute key { $key },
                            text { $old-value/text() }
                        }
                    return xdmp:node-replace($old-value, $new-value)
            )
};

declare function this:value-delete($id as xs:string)
as empty-sequence()
{
    if (not(this:value-exists($id))) then ()
    else
        for $lang in this:lang-list()
        return xdmp:node-delete(this:value-retrieve($lang, $id))
};

declare function this:key-retrieve($lang as xs:string, $key as xs:string)
as attribute(key)?
{
    doc(this:path($lang))/le:lang/le:value[@key eq $key]/@key
};

declare function this:category-list($lang as xs:string)
as xs:string*
{
    if (not(this:lang-exists($lang))) then ()
    else
        distinct-values(
            for $value in this:value-list($lang, ())
            return this:value-key-category($value)
        )
};

(:
 : HELPER FUNCTIONS
 :)

declare function this:path($lang as xs:string)
as xs:string
{
    concat($cfg:storage-dir, '/', $cfg:file-prefix, $lang, '.xml')
};

declare function this:filter($string as xs:string, $pattern as xs:string)
as xs:string
{
    let $filtered-string := ''
    let $work :=
        let $chars :=
            for $codepoint in string-to-codepoints($string)
            return codepoints-to-string($codepoint)
        for $char in $chars
        return
            if (matches($char, $pattern)) then 
                xdmp:set($filtered-string, concat($filtered-string, $char))
            else ()
    return $filtered-string
};

declare function this:value-key-category($value as element(le:value))
as xs:string
{
    this:key-category(string($value/@key))
};

declare function this:value-key-name($value as element(le:value))
as xs:string
{
    this:key-name(string($value/@key))
};

declare function this:key-category($key as xs:string)
as xs:string
{
    let $parts := tokenize($key, '\.')
    let $category := string-join($parts[1 to last() - 1], '.')
    return
        if ($category) then $category else ''
};

declare function this:key-name($key as xs:string)
as xs:string
{
    let $parts := tokenize($key, '\.')
    let $key := $parts[last()]
    return 
        if ($key) then $key else ''
};

declare function this:value-text($value as element(le:value))
as xs:string
{
    string($value/text())
};

declare function this:strip($str as xs:string, $chars as xs:string*)
as xs:string
{
    this:strip-left(this:strip-right($str, $chars), $chars)
};

declare function this:strip-left($str as xs:string, $chars as xs:string*)
as xs:string
{
    if (this:char-at($str, 1) = $chars) then
        this:strip-left(substring($str, 2), $chars)
    else $str
};

declare private function this:strip-right($str as xs:string, $chars as xs:string*)
as xs:string
{
    if (this:char-at($str, string-length($str)) = $chars) then
        this:strip-right(substring($str, 1, string-length($str)-1), $chars)
    else $str
};

declare function this:char-at($str as xs:string, $i as xs:integer)
as xs:string
{
    substring($str, $i, 1)
};