<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/12
 * Time: 20:21
 */

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    //TODO LOGOUT REAL CODE

    global $db;
    global $token;

    $user_id = $db->query("SELECT user_id FROM users WHERE token = '$token'");

    if(is_bool($user_id) || is_null($user_id))
        throw new UserNotFoundException("User not found");

    $db->query("UPDATE users SET token = '' WHERE user_id = $user_id");

    return [
        "response_data" => [],
        "status_code" => 200
    ];
};