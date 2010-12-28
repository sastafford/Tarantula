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
 : Plugin-level configuration.
 :)
module namespace this = "http://scholarsportal.info/xqmvc/langedit/config";

(:
 : Directory in MarkLogic database to store language files, WITHOUT trailing 
 : slash.
 : 
 : eg: '/lang'
 :
 : CAUTION: Do not change this variable after creating language files/values,
 : unless you're prepared to move/rename existing languages files to a new
 : location in the DB.
 :)
declare variable $storage-dir as xs:string := '/langedit';

(:
 : Optionally prefix language filenames.
 : 
 : eg: 'lang-' means language file 'en' will be store as 'lang-en.xml'.
 :
 : CAUTION: Do not change this variable after creating language files/values,
 : unless you're prepared to move/rename existing languages files to a new
 : location in the DB.
 :)
declare variable $file-prefix as xs:string := '';

(:
 : The default language to fetch phrases from.  Note that 
 : xdmp:get-session-field is useful here.
 :
 : eg: 'en'
 : eg: xdmp:get-session-field('lang', 'en')
 :)
declare variable $default-lang as xs:string := 'en';

(:
 : Change the name of this plugin if it conflicts with another XQMVC plugin.
 :)
declare variable $plugin-name as xs:string := 'langedit';