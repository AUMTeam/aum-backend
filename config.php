<?php

//Version of the server
$version = "0.50b";

//DB type
//$db_type = "pgsql"; //Uncomment this for PostgreSQL usage
//$db_type = "sqlite"; //Uncomment this for SQLite3 usage
$db_type = "mysql"; //Uncomment this for MySQL usage

//DB configuration
$config = [
    'server' => "127.0.0.1",
    'username' => "root",
    'password' => "",
    'db_name' => "my_aum",
];

//Flag for debug/release mode
$debug_mode = true;
if($debug_mode == false && !file_exists(__DIR__ . "/log/"))
    mkdir(__DIR__ . "/log/");

//Token validity times (in minutes)
$token_validity_debug = 30;
$token_validity_release = 240;  //4 hours

//Max number of sessions per user
$max_sessions = 5;

//Flag for maintenance mode
$maintenance_state = false;

//URL to the Front-End, used in mails
$gui_url = "https://coopcisf.github.io/aum-frontend/";

//Types for commit/request
define("TYPE_COMMIT", "commits");
define("TYPE_COMMIT_ID", "commit_id");
define("TYPE_REQUEST", "requests");
define("TYPE_REQUEST_ID", "request_id");
define("TYPE_CLIENT", "client");
