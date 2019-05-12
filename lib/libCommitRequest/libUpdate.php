<?php

/**
 * Check if there are new commits/requests for the current user,
 * given a timestamp
 */
function getUpdates(array $data, string $type) : array {
    global $db;
    global $user;
    $last = null;
    $out = [];
    
    //Check parameters presence
    if(!isset($data['latest_update_timestamp']) || empty($data['section']))
        throw new InvalidRequestException("latest_update_timestamp cannot be blank", "ERROR_COMMIT_UPDATE_NO_TIMESTAMP");

    //Check $type
    $id_name;
    switch ($type) {
        case TYPE_COMMIT:
            $id_name = TYPE_COMMIT_ID;
            break;
        case TYPE_REQUEST:
            $id_name = TYPE_REQUEST_ID;
            break;
        default:
            throw new Exception("Impossible to use the endpoint");
    }
    
    //Check the latest update timestamp based on the section the user is visiting
    switch ($data['section']) {
        case ROLE_DEVELOPER:    //A developer sees only its commits
            $creat = $db->preparedQuery("SELECT MAX(creation_timestamp) as last FROM $type WHERE author_user_id=?", [$user['user_id']])[0]['last'];
            $last = $db->preparedQuery("SELECT MAX(approvation_timestamp) as last FROM $type WHERE author_user_id=?", [$user['user_id']])[0]['last'];
            if ($creat > $last) $last = $creat;
        case ROLE_TECHAREA:     //A member of a tech area sees all the commits from its area
            $area = $db->preparedQuery("SELECT area_id FROM users WHERE user_id=?", [$user['user_id']])[0]['area_id'];

            $creat = $db->preparedQuery("SELECT MAX(creation_timestamp) as last FROM $type WHERE (SELECT area_id FROM users WHERE author_user_id=user_id) = {$area}")[0]['last'];
            $last = $db->preparedQuery("SELECT MAX(approvation_timestamp) as last FROM $type WHERE (SELECT area_id FROM users WHERE author_user_id=user_id) = {$area}")[0]['last'];
            if ($creat > $last) $last = $creat;
            break;
        case ROLE_REVOFFICE:    //A member of the revision office sees all the approved requests
            $last = $db->preparedQuery("SELECT MAX(approvation_timestamp) as last FROM requests WHERE approval_status IN ('1')")[0]['last'];
            $send = $db->preparedQuery("SELECT MAX(send_timestamp) as last FROM requests")[0]['last'];
            if ($send > $last) $last = $send;
            break;
        case ROLE_CLIENT:       //A client sees only its updates 
            $last = $db->preparedQuery("SELECT MAX(send_timestamp) as last FROM requests, requests_clients WHERE client_user_id=?", [$user['user_id']])[0]['last'];
            break;
        default:
            throw new InvalidRequestException("Invalid section parameter!");
            break;
    }

    //Convert date to string if present, otherwise keep NULL as the result
    $last = ($last != null) ? strtotime($last) : null;

    $out = [
        "latest_update_timestamp" => $last,
        "updates_found" => $last > $data['latest_update_timestamp']
    ];

    return $out;
}