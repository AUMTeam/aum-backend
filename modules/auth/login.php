<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/10
 * Time: 15:11
 */

$init = function (array $data) : array {
    return [
        'generateToken' => function() : string {
            //Get now's timestamp
            $now = time();
            //Get end's timestamp
            $finish = dechex($now + 86400);
            $now = dechex($now);

            $token = bin2hex(random_bytes(2));

            $temp = "";
            //STRING MUST BE 10 CHARACTERS FIXED
            if(strlen($now)<10){
                for($i=0;$i<(10-strlen($now));$i++)
                    $temp = "$temp"."0";
            }

            $token = "$token$temp$now";

            $temp="";
            if(strlen($finish)<10){
                for($i=0;$i<(10-strlen($finish));$i++)
                    $temp = "$temp"."0";
            }

            //Finishing generating token
            $token = "$token" . bin2hex(random_bytes(2)) . "$temp$finish" . bin2hex(random_bytes(4));

            return $token;
        }
    ];
};

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

    //$token = sha1(random_bytes(64));

    $token = $data_init['generateToken']();
    $db->query("UPDATE users SET token = '$token' WHERE user_id = $user_id");

    return [
        "response_data" => [
            "token" => $token,
            "user_id" => $user_id
        ],
        "status_code" => 200
    ];

};