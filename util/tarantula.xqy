xquery version "1.0-ml";

module namespace tara = 'http://www.marklogic.com/tarantula';

declare namespace html = "http://www.w3.org/1999/xhtml";
declare namespace res = "xdmp:http";

import module namespace url = "http://www.marklogic.com/tarantula/util" at "/util/url.xqy";

declare variable $switch as xs:boolean := fn:true();
declare variable $test as xs:integer external;

declare function tester()
as xs:integer
{
    $test  
};

declare function get-page($url as xs:string)
as xs:boolean
{
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
};


