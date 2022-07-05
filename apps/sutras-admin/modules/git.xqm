xquery version "3.1";

module namespace git="http://stonesutras.org/sutras-admin/git";

import module namespace config="http://stonesutras.org/sutras-admin/config" at "config.xqm";

declare function git:sync($collection as xs:anyURI) {
    let $relpath := substring-after($collection, "/db/")
    let $synced :=
        file:sync($collection, $config:REPO_DIR || "/" || $relpath, ())
    return
        util:log('INFO', $synced)
};

declare function git:commit($message as xs:string, $collection as xs:anyURI) {
    git:sync($collection),
    let $relpath := substring-after($collection, "/db/")
    let $add := process:execute(
        ( "git", "add", $relpath || "/**" ), 
        <options><workingDir>{ $config:REPO_DIR }</workingDir></options>
    )
    return
        if ($add/@exitCode = "0") then
            let $commit := process:execute((
                    "git",
                    "commit",
                    "--no-gpg-sign",
                    "--all",
                    "--message='" || $message || "'"
                ),
                <options><workingDir>{ $config:REPO_DIR }</workingDir></options>
            )
            return
                if ($commit/@exitCode = "0") then
                    util:log('INFO', git:push())
                else
                    util:log('ERROR', $commit)
        else
            util:log('ERROR', $add)
};

declare function git:push() {
    process:execute((
            "git",
            "push",
            "-f",
            "origin",
            "master"
        ),
        <options><workingDir>{ $config:REPO_DIR }</workingDir></options>
    )
};