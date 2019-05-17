<?php

//--DB CONFIGURATION--
//$db_type = "pgsql"; //Uncomment this for PostgreSQL usage
//$db_type = "sqlite"; //Uncomment this for SQLite3 usage
$db_type = "mysql"; //Uncomment this for MySQL usage

//--DB CONFIGURATION--
$db_config = [
    'server' => '127.0.0.1',
    'port' => '5432',
    'db_name' => 'my_aum',
    'username' => '',
    'password' => ''
];


//--MAIL CONFIGURATION--
//URL to the Front-End, used in mails
$gui_url = "https://coopcisf.github.io/aum-frontend/";
//Mail server parameters
$mail_config = [
    'enabled' => false,
    'server' => 'smtp.gmail.com',
    'protocol' => 'tls', //or ssl
    'port' => 587,
    'username' => '',
    'password' => ''
];

//--LDAP CONFIGURATION--
$ldap_config = [
    'enabled' => false,
    'server' => 'ldaps://localhost:389',
    'domain' => 'mydomain',
    'tld' => '.com'
];