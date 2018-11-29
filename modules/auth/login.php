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
    global $printDebug;

    if(!isset($data['username']))
        throw new InvalidRequestException("'username' field cannot be blank");

    if(!isset($data['password']))
        throw new InvalidRequestException("'password' field cannot be blank");

    $result = $db->query("SELECT user_id FROM users_m WHERE username = '{$data['username']}'");

    if(is_bool($result) or count($result) == 0)
        throw new InvalidCredentialsException("Credentials seems be wrong" . $printDebug->getDebugString(" (1)"));

    $user_id = $result[0]['user_id'];

    $hash_pass = saltHash($user_id, $data['username'], hash("sha256",$data['password']));

    $result = $db->query("SELECT user_id FROM users_m WHERE hash_pass = '$hash_pass'");

    if(is_bool($result) or count($result) == 0)
        throw new InvalidCredentialsException("Credentials are wrong" . $printDebug->getDebugString(" (2) : $hash_pass"));

    $token = sha1(random_bytes(64));

    #$db->query("UPDATE users_m SET token = '$token' WHERE user_id = $user_id");
    $tokens = $db->query("SELECT token, token_expire FROM users_token_m WHERE user_id = $user_id ORDER BY token_expire ASC");

    if(count($tokens) >= 5)
        $db->query("UPDATE users_token_m SET token = '$token' WHERE token_expire = {$tokens[0]['token_expire']} AND user_id = $user_id");
    else
        $db->query("INSERT INTO users_token_m(user_id,token) VALUES($user_id,'$token')");

    return [
        "response_data" => [
            "token" => $token,
            "user_id" => $user_id
        ],
        "status_code" => 200
    ];

};