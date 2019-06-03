<?php

//Version of the server
$version = "1.0";

//Flag for maintenance mode
$maintenance_state = false;

//Flag for debug/release mode
$debug_mode = true;

//Log path
$log_path = __DIR__ . "/log";
if($debug_mode == false && !file_exists($log_path))
    mkdir($log_path);


//Token validity times (in minutes)
$token_validity_debug = 30;
$token_validity_release = 240;  //4 hours

//Max number of sessions per user
$max_sessions = 5;


//Types for commit/request
define("TYPE_COMMIT", "commits");
define("TYPE_COMMIT_ID", "commit_id");
define("TYPE_REQUEST", "requests");
define("TYPE_REQUEST_ID", "request_id");
define("TYPE_CLIENT", "client");

//User types
define("ROLE_DEVELOPER", "programmer");
define("ROLE_TECHAREA", "technicalAreaManager");
define("ROLE_REVOFFICE", "revisionOfficeManager");
define("ROLE_CLIENT", "client");
define("ROLE_POWERUSER", "powerUser");