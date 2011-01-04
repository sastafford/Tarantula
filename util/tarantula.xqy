xquery version "1.0-ml";

declare namespace res = "xdmp:http";
declare namespace eval = "xdmp:eval";
declare namespace tara = "http://www.marklogic.com/tarantula";

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
                    let $props := xdmp:document-set-properties($url, $response[1])
                    let $log := xdmp:log(fn:concat("INSERT: ", $url), "info")
                    return xdmp:invoke("/util/link-queue.xqy", 
                                              (xs:QName("url"), $url),
                                              <options xmlns="xdmp:eval">
                                                <isolation>different-transaction</isolation>
                                                <prevent-deadlocks>false</prevent-deadlocks>
                                              </options>)
                 (: Else the content type is not recognized :)    
                 else 
                    xdmp:log(fn:concat("CONTENT TYPE NOT RECOGNIZED: ", $content-type, ", ", $url), "notice")
        else
            xdmp:log(fn:concat("HTTP-GET FAIL: ", $url), "notice")

else (:Tarantula crawler turned off :)
    xdmp:log(fn:concat("SWITCH OFF: "), "info")
    
