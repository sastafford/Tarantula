xquery version "1.0-ml";
import module namespace xqmvc = "http://scholarsportal.info/xqmvc/core" at "../../system/xqmvc.xqy";
declare variable $data as map:map external;

<div id="crawldiv">
    <form action="{ xqmvc:link('crawl-controller', 'crawl') }" method="post">
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
