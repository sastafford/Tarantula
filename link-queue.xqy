xquery version "1.0-ml";

declare namespace html = "http://www.w3.org/1999/xhtml";

import module namespace url = "http://www.marklogic.com/tarantula/util" at "url.xqy";

declare variable $url as xs:string external;

<queue xmlns="http://www.marklogic.com/tarantula">
    <url>{$url}</url>
{
    for $a in fn:doc($url)//html:a
    let $href := url:rel-to-abs($url, fn:string($a/@href))
    return 
        if (fn:string($a/@href) ne "") then
        (: Don't include relative links with '#' :)
            if (fn:not(fn:contains($href, "#"))) then
                (: If it is not already in the database then add :)
                 if (fn:not(fn:doc-available($href))) then
                    <link xmlns="http://www.marklogic.com/tarantula">
                        <absolute>{ $href }</absolute>
                        <relative>{ fn:string($a/@href) }</relative>
                    </link>
                 else ()
            else ()
        else ()
}
</queue>