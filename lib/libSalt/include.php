<?php

function saltHash(int $user_id, string $username, string $password /** password is already an hash */) : string {

    /** Module for make sure that user_id is under 64 bytes */
    $user_id = $user_id % 64;

    /** Creating the salt */
    $crc_user = crc32($username) . crc32(strrev($username));

    /** Crafting the new hash */
    $out = substr($password, 0, $user_id) . $crc_user . substr($password, $user_id + strlen($crc_user));

    /** String's length MUST BE 64 bytes */
    if(strlen($out) !== 64){
        $temp = substr($out,64);
        $out = substr($out,0,64);
        $out = $temp . substr($out, strlen($temp));
    }

    /** Let's make it base64-alike */
    return substr($out,0,62) . "==";

}