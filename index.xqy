xquery version "1.0-ml";

xdmp:set-response-content-type("text/html; charset=utf-8"),
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
<html>
<head>
    <title>Tarantula</title>
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
        
<div id="ft">
    <img src="./img/logo.gif"></img>
</div>
</body>

</html>


