xquery version "1.0-ml";

module namespace crawl = "http://www.marklogic.com/tarantula/crawler";

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
    xdmp:node-replace(fn:doc("/config/tarantula.xml")//tara:switch, 
                   <switch xmlns="http://www.marklogic.com/tarantula">on</switch>)
};
 

declare function turnOff()
{
    xdmp:node-replace(fn:doc("/config/tarantula.xml")//tara:switch, 
                   <switch xmlns="http://www.marklogic.com/tarantula">off</switch>)
};