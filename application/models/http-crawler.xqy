xquery version "1.0-ml";

module namespace crawl = "http://www.marklogic.com/tarantula/crawler";

import module namespace tara = "http://www.marklogic.com/tarantula" at "/util/tarantula.xqy";
 
declare function init()
as empty-sequence()
{
    xdmp:document-insert("/config/tarantula.xml",
    <tarantula>
        <switch>on</switch>
    </tarantula>)

};

declare function turnOn()
as xs:boolean
{
    let $config := xdmp:node-replace(fn:doc("/config/tarantula.xml")/switch, 
                   <switch>on</switch>)
    return fn:true()
};
 

 declare function turnOff()
 as xs:boolean
 {
    let $config := xdmp:node-replace(fn:doc("/config/tarantula.xml")/switch, 
                   <switch>off</switch>)
    return fn:true()
 };