xquery version "1.0-ml";

declare namespace html = "http://www.w3.org/1999/xhtml";
declare namespace res = "xdmp:http";
declare namespace eval = "xdmp:eval";

import module namespace url = "http://www.marklogic.com/tarantula/util" at "/util/url.xqy";

declare option xdmp:update "true";

declare variable $switch as xs:boolean := 
  if (fn:doc("/config/tarantula.xml")//tara:switch/text() eq "on") then
    fn:true()
  else
    fn:false();
    
declare variable $url as xs:string external;

declare function local:queue-links() 
as element()
{
    <q xmlns="http://www.marklogic.com/tarantula">
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
    </q>
    
};

(: The switch variable turns the crawler on/off.  Read in from config file :)
if ($switch) then
    let $response := xdmp:http-get($url)
    let $headers := $response[1]
    return 
        (: Check to see if the response is OK :)
        if ($headers/res:message/text() eq "OK") then
            let $content-type := $headers/res:headers/res:content-type/text()
            return 
                if (fn:contains($content-type, "text/html") or fn:contains($content-type, "text/htm")) then
                    let $tidyResponse := xdmp:tidy($response[2])[2]
                    let $insert := xdmp:document-insert($url, $tidyResponse)
                    (: Store headers into the properties file :)
                    let $b := xdmp:document-set-properties($url, $response[1])
                    let $log := xdmp:log(fn:concat("INSERT: ", $url), "info")
                    let $linkQueue := local:queue-links()
                    let $recursion := for $unit in $linkQueue//tara:link
                                      return xdmp:invoke("/util/tarantula.xqy", 
                                                        (xs:QName("url"), $unit/text()),
                                                        <options xmlns="xdmp:eval">
                                                            <isolation>different-transaction</isolation>
                                                            <prevent-deadlocks>true</prevent-deadlocks>
                                                        </options>)
                    return fn:true()
                else 
                    xdmp:log(fn:concat("HTTP-GET PASS: ", $url), "notice")
               
        else
            let $_ := xdmp:log(fn:concat("HTTP-GET FAIL: ", $url), "notice")
            return fn:false()
else
    fn:true()   



