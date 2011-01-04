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

module namespace xqmvc-controller = "http://scholarsportal.info/xqmvc/controller";
import module namespace xqmvc = "http://scholarsportal.info/xqmvc/core" at "../../system/xqmvc.xqy";

import module namespace crawl = "http://www.marklogic.com/tarantula/crawl" at "../models/crawl-model.xqy";

declare function crawl($url as xs:string)
{
    crawl:crawl($url)
};

declare function stop()
{
    (crawl:turnOff(),
    xqmvc:template('master-template', ('body', xqmvc:view('seed-view'))))
};

declare function start()
{
    (crawl:turnOn(),
    xqmvc:template('master-template', ('body', xqmvc:view('seed-view')))) 
};