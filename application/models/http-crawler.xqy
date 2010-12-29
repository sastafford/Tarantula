xquery version "1.0-ml";

module namespace crawl = "http://www.marklogic.com/tarantula/crawler";

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
    xdmp:node-replace(fn:doc("/config/tarantula.xml")//tara:switch, 
                   <switch xmlns="http://www.marklogic.com/tarantula">on</switch>)
};
 

declare function turnOff()
{
    xdmp:node-replace(fn:doc("/config/tarantula.xml")//tara:switch, 
                   <switch xmlns="http://www.marklogic.com/tarantula">off</switch>)
};

declare function emptyQueue()
{
    xdmp:document-insert("/config/queue.xml", <queue xmlns="http://www.marklogic.com/tarantula" />)
};

declare function startCrawler($url as xs:string)
{
    xdmp:invoke("/util/tarantula.xqy", 
                (xs:QName("url"), $url),
                <options xmlns="xdmp:eval">
                    <isolation>different-transaction</isolation>
                    <prevent-deadlocks>true</prevent-deadlocks>
                </options>)

};