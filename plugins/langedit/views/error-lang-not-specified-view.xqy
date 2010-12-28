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
    <p>Language not specified, please choose one from above, 
        or create a new one below.</p>
    <form method="get">
        { xqmvc:plugin-formlink($cfg:plugin-name, 'editor', 'index') }
        <div>
            <input id="focus" type="text" name="lang" value="" />
            <input type="submit" value="create lang" />
        </div>
    </form>
</div>