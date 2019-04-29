<?php

$init = function (array $data) : array { return []; };

/**
 * Log the user into the application
 */
$exec = function (array $data, array $data_init) : array {
    global $db;
    global $max_sessions;

    //Check fields presence
    if(!isset($data['username']) || !isset($data['password']))
        throw new InvalidRequestException();

    //Verify if the user is present in the DB
    $result = $db->preparedQuery("SELECT user_id, hash_pass FROM users WHERE username=?", [$data['username']]);
    if(count($result) == 0)
        throw new UserNotFoundException();
    
    //Verify if the password correspond
    if(!password_verify($data['password'], $result[0]['hash_pass']))
        throw new InvalidCredentialsException("Credentials are wrong");


    //Get the ID of the user
    $user_id = $result[0]['user_id'];

    //Generate a random access token
    $token = sha1(random_bytes(64));

    //Get the current user's token list
    $tokens = $db->preparedQuery("SELECT token, token_expire FROM users_tokens WHERE user_id=? ORDER BY token_expire ASC", [$user_id]);
    $expire = time() + (60*30);     //This is a placeholder: expiration time is increased later, see main.php/increaseTokenExpire()

    //If there are more than 5 tokens, overwrite one of them (max 5 sessions are allowed); else add it to the list
    if(count($tokens) >= $max_sessions)
        $db->preparedQuery("UPDATE users_tokens SET token=? WHERE token=?", [$token, $tokens[0]['token']]);
    else
        $db->preparedQuery("INSERT INTO users_tokens(user_id, token, token_expire) VALUES(?, ?, ?)", [$user_id, $token, $expire]);

    return [
        "response_data" => [
            "token" => $token,
            "user_id" => $user_id
        ],
        "status_code" => 200
    ];
};