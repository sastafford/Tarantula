xquery version "1.0-ml";
import module namespace xqmvc = "http://scholarsportal.info/xqmvc/core" at "../../system/xqmvc.xqy";
declare variable $data as map:map external;

<div>
    <p>
        <a href="http://code.google.com/p/xqmvc">
            Website / Documentation
        </a>
    </p>
    <table>
        <tr>
            <td>Time:</td><td>{ xdmp:strftime("%a %d %b %Y %I:%M %p", xs:dateTime(map:get($data, 'time'))) }</td>
        </tr>
        <tr>
            <td>Architecture:</td><td>{ map:get($data, 'arch') }</td>
        </tr>
        <tr>
            <td>Platform:</td><td>{ map:get($data, 'plat') }</td>
        </tr>
        <tr>
            <td>MarkLogic:</td><td>{ map:get($data, 'vers') }</td>
        </tr>
    </table>
    <p><a href="{ xqmvc:link('user', 'list') }">User Manager example &raquo;</a></p>
    <p><a href="{ xqmvc:plugin-link('langedit', 'editor', 'index') }">LangEdit i18n editor &raquo;</a></p>
</div>