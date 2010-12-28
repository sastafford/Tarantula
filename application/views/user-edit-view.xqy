xquery version "1.0-ml";
import module namespace xqmvc = "http://scholarsportal.info/xqmvc/core" at "../../system/xqmvc.xqy";
declare variable $data as map:map external;

(:~
 : Converts 'first-name' into 'First Name'
 :)
declare function local:pretty($str as xs:string)
as xs:string
{
    fn:string-join(
        for $word in fn:tokenize(fn:replace($str, '-', ' '), ' ')
        return fn:concat(fn:upper-case(fn:substring($word, 1, 1)), fn:substring($word, 2))
        , " "
    )
};

<div>
    <form action="{ xqmvc:link('user', 'save') }" method="post">
        <table>
            {
                for $field in map:get($data, 'user')/element()
                where $field/@edit eq 'yes'
                return
                    <tr>
                        <td>{ local:pretty(fn:name($field)) }</td>
                        <td>
                            <input type="text" name="{ fn:name($field) }" value="{ $field/text() }"/>
                        </td>
                    </tr>
            }
            <tr>
                <td>&nbsp;</td>
                <td>
                    <input type="hidden" name="id" value="{ map:get($data, 'user')/@id }"/>
                    <input type="submit" value="Save"/>
                </td>
            </tr>
        </table>
    </form>
    <p><a href="{ xqmvc:link('user', 'list') }">&laquo; back to the User List</a></p>
</div>