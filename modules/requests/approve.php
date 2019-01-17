<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $db;
    global $token;

    //Checks fields integrity
    if(!isset($data['id']))
        throw new InvalidRequestException("Request ID cannot be omitted", 3007);
    if(!isset($data['approve_flag']) || ($data['approve_flag'] != -1 && $data['approve_flag'] != 1))    //1: Approved / -1: Rejected
        throw new InvalidRequestException("Invalid approved flag!", 3007);

    //Check whether the current user is a part of the revision office or not
    $user_id = getUserData($db, $token)['user_id'];
    $userAreas = $db->query("SELECT role_id FROM users WHERE user_id=$user_id");
    if (!strpos($userAreas[0]['role_id'], '3'))  //This should be changed soon
        throw new InvalidRequestException("The current user is not authorized to perform this action!", 103, 401);    //TODO: New error code?

    //Check if request_id is valid and whether the commit has already been approved
    $query = $db->query("SELECT is_approved FROM requests WHERE request_id={$data['id']}");
    if (count($query) == 0)
        throw new InvalidRequestException("Request_id doesn't refer to a valid commit!", 3007);
    else if ($query[0]['is_approved'] != 0)
        throw new InvalidRequestException("Commit already approved!", 3007);

        $approvation_comment = NULL;
        if (isset($data['approvation_comment'])) $approvation_comment = $data['approvation_comment'];
    
    
        $db->query("UPDATE requests SET is_approved = {$data['approve_flag']}, approvation_comment = {$approvation_comment}, approver_user_id={$user_id}  WHERE commit_id={$data['id']}");

    return [
        "response_data" => [],
        "status_code" => 200,
    ];
};