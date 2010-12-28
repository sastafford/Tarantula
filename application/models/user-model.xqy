xquery version "1.0-ml";
module namespace user = "http://user.manager.com";

declare variable $db := '/users.xml';

declare function db-exists()
{
    fn:doc-available($db) and fn:exists(fn:doc($db)/users)
};

declare function db-create()
{
    if (fn:not(db-exists())) then
        xdmp:document-insert($db, <users/>)
    else ()
};

declare function list() as element(user)*
{
    fn:doc($db)/users/user
};

declare function create($email as xs:string, $first-name as xs:string, 
    $last-name as xs:string)
{
    if (fn:not(db-exists())) then ()
    else
        let $user :=
            <user id="{ xdmp:random() }">
                <email edit="yes">{ $email }</email>
                <first-name edit="yes">{ $first-name }</first-name>
                <last-name edit="yes">{ $last-name }</last-name>
                <created>{ fn:current-dateTime() }</created>
            </user>
        return
            xdmp:node-insert-child(fn:doc($db)/users, $user)
};

declare function get($id as xs:string)
{
    if (fn:not(db-exists())) then ()
    else
        fn:doc($db)/users/user[@id eq $id]
};

declare function exists($id as xs:string)
as xs:boolean
{
    fn:exists(get($id))
};

declare function save($id as xs:string, $email as xs:string, 
    $first-name as xs:string, $last-name as xs:string)
{
    if (fn:not(db-exists())) then ()
    else
        if (fn:not(exists($id))) then ()
        else (
            xdmp:node-replace(fn:doc($db)/users/user[@id eq $id]/email, <email edit="yes">{ $email }</email>),
            xdmp:node-replace(fn:doc($db)/users/user[@id eq $id]/first-name, <first-name edit="yes">{ $first-name }</first-name>),
            xdmp:node-replace(fn:doc($db)/users/user[@id eq $id]/last-name, <last-name edit="yes">{ $last-name }</last-name>)
        )
};

declare function delete($id as xs:string)
{
    if (fn:not(db-exists())) then ()
    else
        if (fn:not(exists($id))) then ()
        else
            xdmp:node-delete(fn:doc($db)/users/user[@id eq $id])
};