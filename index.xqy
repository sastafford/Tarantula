xquery version "1.0-ml";

(:
 : Copyright 2009 Ontario Council of University Libraries
 : 
 : Licensed under the Apache License, Version 2.0 (the "License");
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
 : The entry-point into the framework.  Executes a function within a controller.
 :)

import module namespace xqmvc = "http://scholarsportal.info/xqmvc/core" at "system/xqmvc.xqy";
import module namespace xqmvc-conf = "http://scholarsportal.info/xqmvc/config" at "application/config/config.xqy";

let $controller := xqmvc:current-controller()
let $function := xqmvc:current-function()
let $plugin := xqmvc:current-plugin()
let $log := if ($xqmvc-conf:debug) then xqmvc:log-status() else ()
return
    if ($plugin) then
        xqmvc:plugin-controller($plugin, $controller, $function)
    else
        xqmvc:controller($controller, $function)