<?php

/**
 * Returns the expiration date (UNIX timestamp) of the token
 */
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

/**
 * Increases the current token' expiration date
 */
function increaseTokenExpire() : void {
    global $db;
    global $token;
    global $printDebug;
    global $response;
    global $token_validity_debug;
    global $token_validity_release;

    if($printDebug->isDebug())
        $new_expire = time() + (60 * $token_validity_debug); //Valid for 30 minutes
    else
        $new_expire = time() + (60 * $token_validity_release); //Token valid for more 4hours from now.

    $db->preparedQuery("UPDATE users_tokens SET token_expire=? WHERE token=?", [$new_expire, $token]);

    if($printDebug->isDebug())
        $response['response_data']['debug']['expire'] = $new_expire;
}