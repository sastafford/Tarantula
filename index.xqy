xquery version "1.0-ml";

import module namespace crawl = "http://www.marklogic.com/tarantula/crawl" at "crawl-model.xqy";

declare function local:controller()
{
    if (xdmp:get-request-field("crawl")) then 
        if (xdmp:get-request-field("cardinality") eq "one") then
            crawl:visit(xdmp:get-request-field("url"))
        else if (xdmp:get-request-field("cardinality") eq "many") then
            crawl:breadth-crawl(<queue xmlns="http://www.marklogic.com/tarantula">
                                    <link>
                                        <absolute>{ xdmp:get-request-field("url") }</absolute>
                                    </link>
                                </queue>,0)  
        else ()
    else if (xdmp:get-request-field("empty")) then
        crawl:emptyDatabase()
    else ()
};

xdmp:set-response-content-type("text/html; charset=utf-8"),
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Tarantula</title>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
    <link href="css/screen.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/custom.js" />
</head>

<body>
<div id="hd">
    <h2>Tarantula</h2>
</div>
        
<div id="crawldiv">
    <form action="index.xqy" method="post">
        URL SEED: <input type="text" name="url" id="url" value="{xdmp:get-request-field("url")}" size="55"/>
        <input type="submit" name="crawl" value="CRAWL" />
        <input type="submit" name="stop" value="STOP" />
        <input type="submit" name="empty" value="EMPTY" />
        <br/>
        <input type="radio" name="cardinality" value="one" />One
        <br />
        <input type="radio" name="cardinality" value="many" />Many
    </form>
</div>     

<div id="results">
{ local:controller() }
</div> 
<div id="ft">
    <img src="./img/logo.gif"></img>
</div>
</body>

</html>
