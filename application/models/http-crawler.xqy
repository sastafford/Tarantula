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

declare function crawl($url as xs:string)
{
    let $linkQ := xdmp:invoke("/util/tarantula.xqy", (xs:QName("url"), $url),
                        <options xmlns="xdmp:eval">
                            <isolation>different-transaction</isolation>
                            <prevent-deadlocks>false</prevent-deadlocks>
                        </options>)
    for $q in $linkQ
    return crawl($q/tara:link/text())     
};