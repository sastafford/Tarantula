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
 : A module to retrieve phrases from a database of languages.
 :)
module namespace this = "http://scholarsportal.info/xqmvc/langedit/m/lang";

import module namespace cfg = "http://scholarsportal.info/xqmvc/langedit/config" at "../config/config.xqy";

declare namespace le = "http://scholarsportal.info/xqmvc/langedit";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

(:~
 : Retrieves text from a language file, as an xs:string.
 :
 : If tokens are provided, will substitute tokens into the phrase at proper 
 : locations ([1], [2], etc).  For example, the phrase with key 
 : "search.msg.result" and value "Searched for [1] in [2] seconds" can be 
 : fetched with text("search.msg.result", ("xquery", "1.25")) resulting 
 : in "Searched for xquery in 1.25 seconds".
 :
 : @param $key The text key.
 : @param [$tokens] Tokens to substitute into the phrase.
 : @param [$lang] The lang to use.  If not present, will attempt to use
 :         $SESS-VAR, followed by $DEFAULT-LANG in lang-custom.xqy.
 : @return A text string.
 :)
declare function this:text($key as xs:string, $tokens as xs:string*, 
    $lang as xs:string)
as xs:string
{
    let $path := this:path($lang)
    return
        if (not(doc-available($path))) then
            concat('lang file [', $path, '] not found')
        else
            let $value := string(this:value($path, $key))
            let $substitutions :=
                for $token at $i in $tokens
                return xdmp:set($value, replace($value, concat('\[', $i, '\]'), 
                    $token))
            return
                if ($value) then $value else concat('[', $key, ']')
};

declare function this:text($key as xs:string, $tokens as xs:string*)
as xs:string
{
    let $lang := $cfg:default-lang
    return this:text($key, $tokens, $lang)
};

declare function this:text($key as xs:string)
as xs:string
{
    this:text($key, ())
};

(:~
 : Retrieves text from a language file, as an element(span).
 :
 : Tokens work the same as this:text(...)
 :
 : The text will be xdmp:unquote'd, meaning, for example, phrases with 
 : <b>bold</b> tags will be properly displayed in a browser.  YOU MUST ENSURE
 : THAT THE PHRASE CONTAINS VALID XML, IF ANY, otherwise all bets are off.
 :
 : @param $key The text key.
 : @param [$tokens] Tokens to substitute into the phrase.
 : @param [$lang] The lang to use.  If not present, will attempt to use
 :         $SESS-VAR, followed by $DEFAULT-LANG in lang-custom.xqy.
 : @return A string wrapped in (html) span tags.
 :)
declare function this:html($key as xs:string, $tokens as xs:string*, 
    $lang as xs:string)
as element(span)
{
    let $path := this:path($lang)
    return
        if (not(doc-available($path))) then
            <span>lang file [{ $path }] not found</span>
        else
            let $value := this:value($path, $key)
            let $value :=
                if ($value) then
                    this:html-substitution($value, $tokens)/node()
                else ()
            return
                <span>{
                    if ($value) then $value
                    else concat('[', $key, ']')
                }</span>
};

declare function this:html($key as xs:string, $tokens as xs:string*)
as element(span)
{
    let $lang := $cfg:default-lang
    return this:html($key, $tokens, $lang)
};

declare function this:html($key as xs:string)
as element(span)
{
    this:html($key, ())
};

declare function this:path($lang as xs:string)
as xs:string
{
    concat($cfg:storage-dir, '/', $cfg:file-prefix, $lang, '.xml')
};

declare function this:value($path as xs:string, $key as xs:string)
as element(le:value)?
{
    doc($path)/le:lang/le:value[@key eq $key]
};

declare function this:html-substitution($value as element(), 
    $tokens as xs:string*)
as node()*
{
    if (fn:not($value/node())) then
        $value
    else
        let $value := 
            element { fn:node-name($value) } {
                $value/@*, xdmp:unquote($value/node(), "", "repair-full")
            }
        let $output := ()
        let $work :=
            for $node in $value/node()
            return
                if (xdmp:node-kind($node) eq 'text') then
                    let $text := fn:string($node)
                    let $substitutions := 
                        for $token at $i in $tokens
                        return
                            xdmp:set($text, fn:replace($text, fn:concat('\[', 
                                $i, '\]'), $token))
                    return xdmp:set($output, ($output, text { $text } ))
                else
                    xdmp:set($output, ($output, this:html-substitution($node, 
                        $tokens)))
        return
            element { fn:node-name($value) } { $value/@*, $output }
};