xquery version "1.0-ml";

declare namespace html = "http://www.w3.org/1999/xhtml";
declare namespace res = "xdmp:http";

import module namespace url = "http://www.marklogic.com/tarantula/util" at "/util/url.xqy";

declare variable $switch as xs:boolean := 
  if (fn:doc("/config/tarantula.xml")//tara:switch/text() eq "on") then
    fn:true()
  else
    fn:false();
    
declare variable $url as xs:string external;

if ($switch) then
    let $response := xdmp:http-get($url)
    let $headers := $response[1]
    let $tidyResponse := xdmp:tidy($response[2])[2]
    return 
        if ($headers/res:message/text() eq "OK") then
            let $insert := xdmp:document-insert($url, $tidyResponse)
            let $b := xdmp:document-set-properties($url, $response[1])
            let $log := xdmp:log(fn:concat("INSERT: ", $url), "info")
            return fn:true()
        else
            let $_ := xdmp:log(fn:concat("HTTP-GET FAIL: ", $url), "notice")
            return fn:false()
else
    fn:true()   



