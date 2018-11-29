<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/12
 * Time: 19:06
 */

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {

    global $db;
    global $token;

    //We are done here
    return [
        "response_data" => getUserData($db, $token, $data),
        "status_code" => 200
    ];
};