xquery version "1.0-ml";

module namespace crawl = "http://www.marklogic.com/tarantula/crawler";

import module namespace url = "http://www.marklogic.com/tarantula/util" at "/util/url.xqy";

declare namespace html = "http://www.w3.org/1999/xhtml";

declare function init()
as empty-sequence()
{
    (xdmp:document-insert("/config/tarantula.xml",
    <tarantula xmlns="http://www.marklogic.com/tarantula">
        <switch>on</switch>
    </tarantula>), emptyQueue())

};

declare function turnOn()
{
    (xdmp:log("Tarantula On", "info"), 
    xdmp:node-replace(fn:doc("/config/tarantula.xml")//tara:switch, 
                   <switch xmlns="http://www.marklogic.com/tarantula">on</switch>))
};
 

declare function turnOff()
{
    (xdmp:log("Tarantula Off", "info"), 
    xdmp:node-replace(fn:doc("/config/tarantula.xml")//tara:switch, 
                   <switch xmlns="http://www.marklogic.com/tarantula">off</switch>))
};

declare function emptyQueue()
{
    (xdmp:log("Empty Queue", "info"), 
    xdmp:document-insert("/config/queue.xml", <queue xmlns="http://www.marklogic.com/tarantula" />))
};

declare function emptyDatabase()
{
    let $_ := xdmp:log("Tarantula DB Delete", "info")
    for $d in fn:doc()
    return xdmp:document-delete(fn:document-uri($d)) 
};

declare function link-queue($url)
as element()
{
    <queue xmlns="http://www.marklogic.com/tarantula">
    {
        for $a in fn:doc($url)//html:a
        let $href := fn:string($a/@href)
        return 
            if ($href ne "") then
            (: Don't include relative links with '#' :)
                if (fn:not(fn:contains($href, "#"))) then
                (: If it is not already in the database then add :)
                    if (fn:not(fn:doc-available($href))) then
                        <link xmlns="http://www.marklogic.com/tarantula">{url:rel-to-abs($url, $href)}</link>
                    else ()
                else ()
            else ()
    }
    </queue>

};

declare function crawl($url as xs:string)
{
    let $a := xdmp:invoke("/util/tarantula.xqy", (xs:QName("url"), $url))
    return 
        (: Insert the document into the database :)
        if (fn:doc-available($url)) then
            for $link in link-queue($url)
            return crawl($link/tara:link/text())
        else 
            xdmp:log(fn:concat("CRAWL URL NOT AVAILABLE: ", $url), "debug")
};