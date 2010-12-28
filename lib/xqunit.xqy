xquery version "1.0-ml";

module namespace xqunit = "http://marklogic.com/xqunit";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:mapping "false";

(: Copyright 2002-2009 Mark Logic Corporation.  All Rights Reserved. :)

(: Commonly-used functions for unit testing. :)

declare function xqunit:assert-equal($name, $actual as item()*, $expected as item()*) {
    if (fn:deep-equal($expected, $actual)) then 
        <pass test="{$name}"/>
    else 
        <fail test="{$name}">
             <expected>{$expected}</expected>
             <actual>{$actual}</actual>
        </fail>
};

declare function xqunit:assert-schema-valid($name, $node) {
    let $result := try { validate { $node } }
                   catch ($e) { <fail test="{$name}">{$e}</fail> }
    return if (fn:local-name($result) eq 'fail')
           then $result
           else <pass test="{$name}"/>
};

(: if you have a persistently non-passing test, DO NOT just fake the expected results to make it pass.
   Intead, use this function to pass it over, while leaving an explicit marker in the code that something is not passing.
   Grep for "assertKnownFailure" to find instances of this. :)
declare function xqunit:assert-known-failure($name, $actual, $expected) {
    if (deep-equal($expected, $actual))
    then <fail test="{$name}" condition="Known Failure did not fail!">
             <expected>{$expected}</expected>
             <actual>{$actual}</actual>
         </fail>
    else <pass test="{$name}"/>
};

