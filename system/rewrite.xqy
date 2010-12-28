xquery version "1.0-ml";

(:
 : Copyright 2009 Ontario Council of University Libraries
 : 
 : Licensed     under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 : 
 :    http://www.apache.org/licenses/LICENSE-2.0
 : 
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)

(:~
 : Rewrites URLs to execute index.xqy.
 : 
 : From: host.com/controller/function.html?key=val
 : To: host.com/index.xqy?c=controller&f=function&key=val
 :)

import module namespace xqmvc-conf = "http://scholarsportal.info/xqmvc/config" at "../application/config/config.xqy";
import module namespace xqmvc = "http://scholarsportal.info/xqmvc/core" at "xqmvc.xqy";

let $url := xdmp:get-request-url()
return
if (matches($url, concat("^", $xqmvc:resource-dir)) 
            or matches($url, concat("^", $xqmvc:library-dir))) then
        $url
    else
        let $suffix := replace($xqmvc-conf:url-suffix, '\.', '\\.')
        let $standard-pattern := concat("^", $xqmvc-conf:app-root, "/([\w\.-]+)/([\w\.-]*)", $suffix, "((\?)(.*))?$")
        let $plugin-pattern := concat("^", $xqmvc-conf:app-root, "/([\w\.-]+)/([\w\.-]+)/([\w\.-]*)", $suffix, "((\?)(.*))?$")
        return
        
            (: standard url rewriting :)
            if (matches($url, $standard-pattern)) then
                
                let $from := $standard-pattern
                let $to := concat($xqmvc-conf:app-root, "/?",
                    $xqmvc-conf:controller-querystring-field, "=$1&amp;",
                    $xqmvc-conf:function-querystring-field, "=$2&amp;",
                    "$5")
                let $new := replace($url, $from, $to)
                return
                    $new
                    
            (: plugin url rewriting :)
            else if (matches($url, $plugin-pattern)) then
                
                let $from := $plugin-pattern
                let $to := concat($xqmvc-conf:app-root, "/?",
                    $xqmvc-conf:controller-querystring-field, "=$2&amp;",
                    $xqmvc-conf:function-querystring-field, "=$3&amp;",
                    $xqmvc-conf:plugin-querystring-field, "=$1&amp;",
                    "$6")
                let $new := replace($url, $from, $to)
                return
                    $new
            else
                $url