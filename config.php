<?php

//Version of the server
$version = "0.30b";

//DB mode (SQLite3 or MySQL)
//$db_usage = "SQLITE3"; //Uncomment this for SQLite3 usage
$db_usage = "MYSQL"; //Uncomment this for MYSQL usage

//SQLite3 mode DB name
$sqlite3_name = "./db/main.db_";

//MySQL mode configuration
$config = [
    'server' => "",
    'username' => "",
    'password' => "",
    'db_name' => "my_aum"
];

//Flag for debug/release mode
$debug_mode = false;

//Flag for maintenance mode
$maintenance_state = false;