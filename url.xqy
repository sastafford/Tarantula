xquery version "1.0-ml";

module namespace url = "http://www.marklogic.com/tarantula/util";

declare function rel-to-abs($absPath as xs:string, $relPath as xs:string) as xs:string
{
    (: DETERMINE SCHEME AND DOMAIN :)
    let $tokenAbsPath := fn:tokenize($absPath, "/")
    let $scheme := fn:concat($tokenAbsPath[1], "//")
    let $domain := $tokenAbsPath[3]
    
    (: DETERMINE FOLDER STRUCTURE :)
    let $tokenFolder := fn:subsequence($tokenAbsPath, 4, fn:count($tokenAbsPath)-4)
    
    (: FIND PARENT DIRECTORY INDICATORS '../' :)
    let $tokenRelPath := fn:tokenize($relPath, "\.\./")
    let $newTokenFolder := fn:subsequence($tokenFolder, 1, fn:count($tokenFolder) - (fn:count($tokenRelPath) - 1))
    let $newFolder := 
        if (fn:empty($newTokenFolder)) then ()
        else fn:concat("/", fn:string-join($newTokenFolder, "/"))

    (: Remove all instances of './' from the relative string :)
    let $newRelPath := fn:replace($tokenRelPath[fn:count($tokenRelPath)], "\./", "")

    return 
        if (fn:starts-with($relPath, "/")) then
            fn:concat($scheme, $domain, $relPath)
        else if (fn:starts-with($relPath, "?") or fn:starts-with($relPath, "#")) then
            fn:concat($absPath, $relPath)
        else if (fn:contains($relPath, "://")) then
            $relPath
        else 
            fn:concat($scheme, $domain, $newFolder, "/", $newRelPath)

};





