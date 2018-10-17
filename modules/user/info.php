<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/12
 * Time: 19:06
 */

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    //TODO REAL IMPLEMENTATION

    global $db;
    global $token;

    $user_data = $db->query("SELECT * FROM users WHERE token = '$token'");

    if(is_bool($user_data) || is_null($user_data))
        throw new UserNotFoundException("User not found");

    $out = $user_data[0];



    return [
        "response_data" => $user_data[0],
        "status_code" => 200
    ];
};