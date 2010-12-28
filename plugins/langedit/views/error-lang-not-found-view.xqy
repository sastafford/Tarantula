xquery version "1.0-ml";
import module namespace xqmvc = "http://scholarsportal.info/xqmvc/core" at "../../../system/xqmvc.xqy";
import module namespace cfg = "http://scholarsportal.info/xqmvc/langedit/config" at "../config/config.xqy";
declare variable $data as map:map external;

<div xmlns="http://www.w3.org/1999/xhtml">
    <div class="langs">{
        xqmvc:plugin-view($cfg:plugin-name, 'langs-view', (
            'current', map:get($data, 'lang')
        ))
    }</div>
    <form action="{ xqmvc:plugin-link($cfg:plugin-name, 'editor', 'lang-create') }" method="post">
        <p>
            Language [{ map:get($data, 'lang') }] not found, please choose one from above, or
            <input type="hidden" name="lang" value="{ map:get($data, 'lang') }" />
            <input id="focus" type="submit" value="create [{ map:get($data, 'lang') }]" />
        </p>
    </form>
</div>