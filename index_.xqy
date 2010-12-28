xquery version "1.0-ml";

declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace http="xdmp:http";

import module namespace t = "http://www.marklogic.com/tarantula" at "/modules/tarantula.xqy";

declare variable $optionsHTTP := 
    <options xmlns="xdmp:http">
        <authentication method="digest">
            <username>sstafford</username>
            <password>narrows</password>
        </authentication>
    </options>;

(: Need to explicitly set variables and return values :)
declare function local:process-html($url)
{
    if (fn:empty(fn:doc($url))) then
        ()
    else
        let $response := xdmp:http-get($url, $optionsHTTP)
        return
            if ($response/http:message eq "OK") then
            (xdmp:document-load($url, <options xmlns="xdmp:document-load">
                                            <repair>full</repair>
                                            <format>xml</format>                                            
                                           </options>), 
                xdmp:document-set-properties($url, $response[1]),
                <p>OK</p>)
            else <p>NOT OK</p>
};

declare function local:result-controller()
{
    if (xdmp:get-request-field("url")) then 
        local:process-html(xdmp:get-request-field("url"))
    else (<p>Nothing</p>) 
};

xdmp:set-response-content-type("text/html; charset=utf-8"),
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Tarantula</title>
</head>

<body>
<div id="wrapper">
<div id="header"><a href="index.xqy">Tarantula</a></div>
<div id="leftcol">
  
</div>
<div id="rightcol">
  <form name="form1" method="get" action="index.xqy" id="form1">
  <div id="searchdiv">
    <input type="text" name="url" id="url" value="{xdmp:get-request-field("url")}" size="55"/>
    <input type="submit" id="submitbtn" name="submitbtn" value="search"/>
  </div>
  <div id="detaildiv">
    {local:result-controller()}
  </div>
  </form>
</div>
<div id="footer"></div>
</div>
</body>

</html>