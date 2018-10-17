<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/12
 * Time: 20:21
 */

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {

    global $db;
    global $token;

    //One-step token erasing
    $db->query("UPDATE users SET token = null WHERE token = '$token'");

    return [
        "response_data" => [],
        "status_code" => 200
    ];
};