xquery version "1.0-ml";
import module namespace xqmvc = "http://scholarsportal.info/xqmvc/core" at "../../system/xqmvc.xqy";
declare variable $data as map:map external;

<div>
  <div id="crawldiv">
    SEED URL: 
    <input type="text" name="url" id="url" value="{xdmp:get-request-field("url")}" size="55"/>
    <p><a href="{ xqmvc:link('crawl', 'start') }">START</a></p>
    <p><a href="{ xqmvc:link('crawl', 'stop') }">STOP</a></p>
    
  </div>   
</div>