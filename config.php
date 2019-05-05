<?php

//Version of the server
$version = "0.50b";

//Flag for maintenance mode
$maintenance_state = false;


//--DB CONFIGURATION--
//$db_type = "pgsql"; //Uncomment this for PostgreSQL usage
//$db_type = "sqlite"; //Uncomment this for SQLite3 usage
$db_type = "mysql"; //Uncomment this for MySQL usage

//DB configuration
$db_config = [
    'server' => "127.0.0.1",
    'port' => "5432",
    'username' => "",
    'password' => "",
    'db_name' => "my_aum",
];


//--MAIL CONFIGURATION--
//Flag to indicate whether mail sending is enabled or not
$mail_enabled = false;
//URL to the Front-End, used in mails
$gui_url = "https://coopcisf.github.io/aum-frontend/";
//Mail server parameters
$mail_config = [
    'server' => 'smtp.google.com',
    'protocol' => 'tls', //or ssl
    'port' => 587,
    'username' => '',
    'password' => ''
];

//--LDAP Configuration--
$ldap_config = [
    'enabled' => false,
    'server' => "ldaps://localhost:389",
    'domain' => 'mydomain',
    'tld' => '.com'
];

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
define("ROLE_DEVELOPER", "developer");
define("ROLE_TECHAREA", "technicalAreaManager");
define("ROLE_REVOFFICE", "revisionOfficeManager");
define("ROLE_CLIENT", "client");