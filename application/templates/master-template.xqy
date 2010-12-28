xquery version "1.0-ml";
import module namespace xqmvc = "http://scholarsportal.info/xqmvc/core" at "../../system/xqmvc.xqy";
declare variable $data as map:map external;

xdmp:set-response-content-type('text/html'),

$xqmvc:doctype-xhtml-1.1,

<html>
    <head>
        <title>{ map:get($data, 'browsertitle') }</title>
        <link rel="stylesheet" type="text/css" media="screen" href="{ $xqmvc:resource-dir }/css/style.css"/>
    </head>
    <body>
        <div id="hd">
            <h2>Tarantula</h2>
        </div>
        
        <hr />
        
        <div>{ map:get($data, 'body') }</div>
        
        <hr />
        
        <div id="ft">
            <img src="{ $xqmvc:resource-dir }/img/logo.gif"></img>
        </div>
    </body>
</html>