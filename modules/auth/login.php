<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/10
 * Time: 15:11
 */

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {

    global $db;

    if(!isset($data['username']))
        throw new InvalidRequestException("'username' field cannot be blank");

    if(!isset($data['hash_pass']))
        throw new InvalidRequestException("'hash_pass' field cannot be blank");

    $result = $db->query("SELECT user_id FROM users WHERE username = '{$data['username']}' AND hash_pass = '{$data['hash_pass']}'");

    if(is_bool($result) or count($result) == 0)
        throw new InvalidCredentialsException("Credentials are wrong");

    $user_id = $result[0]['user_id'];

    //TODO REAL TOKEN ALGORITHM
    $token = sha1(random_bytes(64));
    $db->query("UPDATE users SET token = '$token' WHERE user_id = $user_id");

    return [
        "response_data" => [
            "token" => $token,
            "user_id" => $user_id
        ],
        "status_code" => 200
    ];

};