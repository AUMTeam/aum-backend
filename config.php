<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/10
 * Time: 16:32
 */

//DB mode (SQLite3 or MySQL)
$db_usage = "SQLITE3"; //Uncomment this for SQLite3 usage
//$db_mode = "MYSQL"; //Uncomment this for MYSQL usage

//SQLite3 mode DB name
$sqlite3_name = "./db/main.db_";

//MySQL mode configuration
$config = [
    'server' => "",
    'username' => "",
    'password' => "",
    'database' => "my_aum"
];

//Flag for debug/release mode
$release_mode = true;