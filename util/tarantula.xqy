xquery version "1.0-ml";

declare namespace html = "http://www.w3.org/1999/xhtml";
declare namespace res = "xdmp:http";
declare namespace eval = "xdmp:eval";
declare namespace tara = "http://www.marklogic.com/tarantula";

import module namespace url = "http://www.marklogic.com/tarantula/util" at "/util/url.xqy";

declare option xdmp:update "true";

declare variable $url as xs:string external;

declare variable $switch as xs:boolean := 
  if (fn:doc("/config/tarantula.xml")//tara:switch/text() eq "on") then
    fn:true()
  else
    fn:false();
    
(: The switch variable turns the crawler on/off.  Read in from config file :)
if ($switch) then
    let $response := xdmp:http-get($url)
    let $headers := $response[1]
    return 
        (: Check to see if the response is OK :)
        if ($headers/res:message/text() eq "OK") then
            let $content-type := $headers/res:headers/res:content-type/text()
            return
                (: If the content type is text/htm or text/html :)
                if (fn:contains($content-type, "text/html") or fn:contains($content-type, "text/htm")) then 
                    let $tidyResponse := xdmp:tidy($response[2])[2]
                    let $insert := xdmp:document-insert($url, $tidyResponse)
                    (: Store headers into the properties file :)
                    let $b := xdmp:document-set-properties($url, $response[1])
                    return xdmp:log(fn:concat("INSERT: ", $url), "info")
                    (: Else the content type is not recognized :)    
                else 
                    xdmp:log(fn:concat("CONTENT TYPE NOT RECOGNIZED: ", $content-type, ", ", $url), "notice")
        else
            xdmp:log(fn:concat("HTTP-GET FAIL: ", $url), "notice")
 else (:Tarantula crawler turned off :)
    xdmp:log(fn:concat("SWITCH OFF: "), "info")