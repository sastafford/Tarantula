xquery version "1.0-ml";
xdmp:set-response-content-type("text/xml; charset=utf-8"),
<count xmlns="http://www.marklogic.com/tarantula">
{ xdmp:estimate(doc()) }
</count>