<?php

//Version of the server
$version = "0.30b";

//DB type
//$db_type = "pgsql"; //Uncomment this for PostgreSQL usage
//$db_type = "sqlite"; //Uncomment this for SQLite3 usage
$db_type = "mysql"; //Uncomment this for PDO usage

//SQLite3 configuration
/*$config = [
    'db_name' => "./db/main.db_",
];*/

//MySQL configuration
$config = [
    'server' => "127.0.0.1",
    'username' => "root",
    'password' => "",
    'db_name' => "my_aum",
];

//Flag for debug/release mode
$debug_mode = true;

//Flag for maintenance mode
$maintenance_state = false;