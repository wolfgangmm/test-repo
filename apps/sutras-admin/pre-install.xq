xquery version "1.0";
(:~ The pre-install runs before the actual install and deploy.
 :
 : @version 1.0.0
 :)
import module namespace xdb="http://exist-db.org/xquery/xmldb";

(: The following external variables are set by the repo:deploy function :)

(: file path pointing to the exist installation directory :)
declare variable $home external;
(: path to the directory containing the unpacked .xar package :)
declare variable $dir external;
(: the target collection into which the app is deployed :)
declare variable $target external;

(: store the collection configuration :)
xdb:store-files-from-pattern("/db/system/config/db", $dir, "*.xconf")
