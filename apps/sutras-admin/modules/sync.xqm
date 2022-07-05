xquery version "3.1";

module namespace trigger="http://exist-db.org/xquery/trigger";

import module namespace config="http://stonesutras.org/sutras-admin/config" at "config.xqm";
import module namespace git="http://stonesutras.org/sutras-admin/git" at "git.xqm";

declare function trigger:after-update-document($uri as xs:anyURI) {
    let $log := util:log("info", "new trigger:after-update-document: " || $uri)
    return
        trigger:commit-and-push("UPDATE", $uri)
};

declare function trigger:after-create-document($uri as xs:anyURI) {
    let $log := util:log("info", "xml trigger:after-create-document: " || $uri)
    return
        trigger:commit-and-push("ADD", $uri)
};

declare function trigger:commit-and-push($action as xs:string, $uri as xs:anyURI) {
    let $user := sm:id()//sm:real/sm:username/text()
    let $log := util:log('INFO', ('$user=', $user))
    let $collection := replace($uri, "^(.*)/[^/]+$", "$1")
    return
        system:as-user(
            $config:DBA_USER, 
            $config:DBA_PASS,
            git:commit($action || ": " || $uri || " by " || $user, $collection)
        )
};