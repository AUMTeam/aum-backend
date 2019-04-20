<?php

function checkToken() {
    global $db;
    global $token;

    $result = $db->query("SELECT token_expire FROM users_tokens WHERE token = '{$token}'");
    if(is_bool($result) or count($result) == 0)
        throw new InvalidTokenException("Token is not valid");

    if(time() > $result[0]['token_expire']) {
        $db->query("DELETE FROM users_tokens WHERE token = '{$token}'");
        throw new InvalidTokenException("Token is not valid anymore. Please remake login.");
    }
}

function increaseTokenExpire() {
    global $db;
    global $token;
    global $printDebug;

    if($printDebug->isDebug()) // DEBUG PURPOSE ONLY
        $new_expire = time() + (60 * 30); //Valid for 30 minutes for debugging multiple timeout
    else
        $new_expire = time() + ((60*60) * 4); //Token Valid for more 4hours from now.

    $db->query("UPDATE users_tokens SET token_expire = $new_expire WHERE token = '$token'");

    if($printDebug->isDebug()) $response['response_data']['debug']['expire'] = $new_expire;
}