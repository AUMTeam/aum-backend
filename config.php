<?php

//Version of the server
$version = "0.30b";

//DB mode (SQLite3 or MySQL)
//$db_usage = "SQLITE3"; //Uncomment this for SQLite3 usage
//$db_usage = "MYSQL"; //Uncomment this for MYSQL usage
$db_usage = "PDO"; //Uncomment this for PDO usage

//SQLite3 mode DB name
$sqlite3_name = "./db/main.db_";

//MySQL mode configuration
$config = [
    'server' => "127.0.0.1",
    'username' => "root",
    'password' => "",
    'db_name' => "my_aum",
    'db_type' => "mysql"
];

//Flag for debug/release mode
$debug_mode = true;

//Flag for maintenance mode
$maintenance_state = false;