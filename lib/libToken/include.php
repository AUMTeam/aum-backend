<?php

function getTokenExpire() {
    global $db;
    global $token;

    $result = $db->preparedQuery("SELECT token_expire FROM users_tokens WHERE token=?", [$token]);
    if(is_bool($result) or count($result) == 0)
        throw new InvalidTokenException("Token is not valid");

    if(time() > $result[0]['token_expire']) {
        $db->preparedQuery("DELETE FROM users_tokens WHERE token=?", [$token]);
        throw new InvalidTokenException("Token is not valid anymore. Please remake login.");
    }

    return $result[0]['token_expire'];
}

function increaseTokenExpire() {
    global $db;
    global $token;
    global $printDebug;

    if($printDebug->isDebug()) // DEBUG PURPOSE ONLY
        $new_expire = time() + (60 * 30); //Valid for 30 minutes for debugging multiple timeout
    else
        $new_expire = time() + ((60*60) * 4); //Token Valid for more 4hours from now.

    $db->preparedQuery("UPDATE users_tokens SET token_expire=? WHERE token=?", [$new_expire, $token]);

    if($printDebug->isDebug()) $response['response_data']['debug']['expire'] = $new_expire;
}