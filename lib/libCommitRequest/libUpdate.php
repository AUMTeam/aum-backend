<?php

/**
 * Check if there are new commits/requests for the current user,
 * given a timestamp
 */
function getUpdates(array $data, string $type) : array {    
    //Check parameters presence
    if(!isset($data['latest_update_timestamp']) || empty($data['section']))
        throw new InvalidRequestException();

    //Check $type
    switch ($type) {
        case TYPE_COMMIT:
        case TYPE_REQUEST:
            break;
        default:
            throw new InvalidRequestException("Impossible to use the endpoint");
    }

    global $db;
    global $user;
    $last = null;
    $out = [];
    
    //Check the latest update timestamp based on the section the user is visiting
    switch ($data['section']) {
        case ROLE_DEVELOPER:    //A developer sees only its commits
            $last = $db->preparedQuery("SELECT GREATEST(MAX(creation_timestamp), MAX(approvation_timestamp)) as last FROM $type WHERE author_user_id=?", [$user['user_id']]);
            break;
        case ROLE_TECHAREA:     //A member of a tech area sees all the commits from its area
            $area = $db->preparedQuery("SELECT area_id FROM users WHERE user_id=?", [$user['user_id']])[0]['area_id'];

            $last = $db->preparedQuery("SELECT GREATEST(MAX(creation_timestamp), MAX(approvation_timestamp)) as last FROM $type WHERE (SELECT area_id FROM users WHERE author_user_id=user_id) = {$area}");
            break;
        case ROLE_REVOFFICE:    //A member of the revision office sees all the approved requests
            $last = $db->preparedQuery("SELECT GREATEST(MAX(approvation_timestamp), MAX(send_timestamp)) as last FROM requests WHERE approval_status IN ('1')");
            break;
        case ROLE_CLIENT:       //A client sees only its updates 
            $last = $db->preparedQuery("SELECT MAX(send_timestamp) as last FROM requests, requests_clients WHERE client_user_id=?", [$user['user_id']]);
            break;
        default:
            throw new InvalidRequestException("Invalid section parameter!");
            break;
    }

    //Convert date to string if present, otherwise keep NULL as the result
    $last = (count($last) > 0) ? strtotime($last[0]['last']) : null;

    $out = [
        "latest_update_timestamp" => $last,
        "updates_found" => $last > $data['latest_update_timestamp'] //Boolean: true or false
    ];

    return $out;
}