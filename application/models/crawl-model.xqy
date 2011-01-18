xquery version "1.0-ml";

module namespace crawl = "http://www.marklogic.com/tarantula/crawl";

import module namespace url = "http://www.marklogic.com/tarantula/util" at "/util/url.xqy";

declare namespace html = "http://www.w3.org/1999/xhtml";

declare variable $MAX := 12;

declare function init()
as empty-sequence()
{
    xdmp:document-insert("/config/tarantula.xml",
        <tarantula xmlns="http://www.marklogic.com/tarantula">
            <switch>on</switch>
        </tarantula>)

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

declare function emptyDatabase()
{
    let $_ := xdmp:log("Tarantula DB Delete", "info")
    for $d in fn:doc()
    return xdmp:document-delete(fn:document-uri($d)) 
};

declare function crawl($url as xs:string, $counter as xs:integer)
{
    (: If the URL is successfully inserted into the database :)
    if (xdmp:invoke("/util/tarantula.xqy", (xs:QName("url"), $url),
                    <options xmlns="xdmp:eval">
                        <isolation>different-transaction</isolation>
                        <prevent-deadlocks>false</prevent-deadlocks>
                    </options>)) then
        (: Get the links in the page :)
        let $linkQ := xdmp:invoke("/util/link-queue.xqy", (xs:QName("url"), $url),
                                    <options xmlns="xdmp:eval">
                                        <isolation>different-transaction</isolation>
                                        <prevent-deadlocks>false</prevent-deadlocks>
                                    </options>)
        for $q in $linkQ
        return crawl($q/tara:link/tara:absolute/text(), $counter+1)
    else ()
    
};