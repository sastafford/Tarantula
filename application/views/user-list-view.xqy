xquery version "1.0-ml";
import module namespace xqmvc = "http://scholarsportal.info/xqmvc/core" at "../../system/xqmvc.xqy";
import module namespace user = "http://user.manager.com" at "../models/user-model.xqy";
declare variable $data as map:map external;

<div>
    { xqmvc:view('user-creation-form') }
    <table>
        <tr>
            <th>&nbsp;</th>
            <th>Email</th>
            <th>First</th>
            <th>Last Name</th>
            <th>Created</th>
        </tr>
        {
            for $user in user:list()
            order by $user/last-name
            return
                <tr>
                    <td>
                        <a href="{ xqmvc:link('user', 'view', ('id', $user/@id)) }">view</a>
                        &nbsp;
                        <a href="{ xqmvc:link('user', 'delete', ('id', $user/@id)) }">delete</a>
                        &nbsp;
                    </td>
                    <td>{ $user/email/text() }</td>
                    <td>{ $user/first-name/text() }</td>
                    <td>{ $user/last-name/text() }</td>
                    <td>{ xdmp:strftime("%a %d %b %Y %I:%M%P", xs:dateTime($user/created/text())) }</td>
                </tr>
        }
    </table>
    <p><a href="{ xqmvc:link('welcome', 'index') }">&laquo; back to the Welcome Page</a></p>
</div>