<?php

/**
 * Log the user into the application
 */
$exec = function (array $data, array $data_init) : array {
    //Check fields presence
    if(empty($data['username']) || empty($data['password']))
        throw new InvalidRequestException();
    
    global $ldap_config;
    
    if ($ldap_config['enabled'])
        return loginWithLDAP($data);        //Authentication using LDAP
    else
        return loginWithInternalDB($data);  //Authentication using internal DB
};

function loginWithLDAP(array $data) : array {
    global $ldap_config;

    //Connect to the LDAP server
    $ldap = ldap_connect($ldap_config['server']);
    if ($srv) { //Connected successfully

        //Bind the connection
        $r=ldap_bind($ldap, $data['username'], $data['password']);
        if (!$r) {
            ldap_close($ldap);
            return loginWithInternalDB($data);  //Fallback to the local DB
        }

        //Query
        $filter="(sAMAccountName={$data['username']})";
        $search = ldap_search($ldap, "dc={$ldap_config['domain']},dc={$ldap_config['tld']}", $filter);
        $res = ldap_get_entries($ldap, $search);

        
        if($res['count'] == 0) {    //User not found
            ldap_close($ldap);
            return loginWithInternalDB($data);  //Fallback to the local DB
        } else {
            $res = $res[0];
            $user_id = -1;
            ldap_close($ldap);
            return setToken($user_id);
        }
    }
}

//Authenticate users using the internal database
function loginWithInternalDB(array $data) : array {
    global $db;

    //Verify if the user is present in the DB
    $result = $db->preparedQuery("SELECT user_id, hash_pass FROM users WHERE username=?", [$data['username']]);
    if(count($result) == 0)
        throw new UserNotFoundException();
    
    //Verify if the password correspond
    if(!password_verify($data['password'], $result[0]['hash_pass']))
        throw new InvalidCredentialsException("Credentials are wrong");


    //Get the ID of the user
    $user_id = $result[0]['user_id'];

    return setToken($user_id);
}

function setToken(int $user_id) : array {
    global $token;
    global $db;
    global $max_sessions;

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
}