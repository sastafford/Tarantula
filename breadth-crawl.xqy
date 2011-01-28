xquery version "1.0-ml";

declare namespace tara = "http://www.marklogic.com/tarantula";

declare variable $depth as xs:integer external;

(: Get the uncrawled pages from the database :)
let $uncrawled-pages := fn:collection("uncrawled")
return
    for $page in $uncrawled-pages
    let $anchors := xdmp:invoke("link-queue.xqy", (xs:QName("url"), fn:base-uri($page)),
                                    <options xmlns="xdmp:eval">
                                        <isolation>different-transaction</isolation>
                                        <prevent-deadlocks>false</prevent-deadlocks>
                                    </options>)
    let $crawl :=
        for $a in $anchors/tara:link
        return xdmp:invoke("tarantula.xqy", (xs:QName("url"), $a/tara:absolute/text()),
                    <options xmlns="xdmp:eval">
                        <isolation>different-transaction</isolation>
                        <prevent-deadlocks>false</prevent-deadlocks>
                   </options>)
    let $crawl-unflag := xdmp:document-remove-collections(fn:base-uri($page), "uncrawled")
    let $crawl-flag := xdmp:document-add-collections(fn:base-uri($page), "crawled")
    return ()
(: return xdmp:spawn("breadth-crawl.xqy", (xs:QName("queue"), $nextLevelQueue, xs:QName("depth"), $depth+1)) :)
