<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $db;
    global $token;

    //Checks fields integrity
    if(!isset($data['id']))
        throw new InvalidRequestException("Commit ID cannot be omitted", 3007);
    if(!isset($data['approve_flag']) || ($data['approve_flag'] != -1 && $data['approve_flag'] != 1))     //1: Approved / -1: Rejected
        throw new InvalidRequestException("Invalid approved flag!", 3007);

    //Check whether the current user is a technical area manager or not
    $user = getUserData($db, $token);
    $user_id = $user['user_id'];
    $role_id = $user['role'];


    if (!in_array(2, $role_id))
        throw new InvalidRequestException("The current user is not authorized to perform this action $role_id $role_id[0]!", 103, 401);    //TODO: New error code?

    //Check if commit_id is valid and whether the commit has already been approved
    $query = $db->query("SELECT is_approved FROM commits WHERE commit_id={$data['id']}");
    if (count($query) == 0)
        throw new InvalidRequestException("Commit_id doesn't refer to a valid commit!", 3007);
    else if ($query[0]['is_approved'] != 0)
        throw new InvalidRequestException("Commit already approved!", 3007);

    $approvation_comment = "";
    if (isset($data['approvation_comment'])) $approvation_comment = $data['approvation_comment'];


    $db->query("UPDATE commits SET is_approved={$data['approve_flag']}, approvation_comment='{$approvation_comment}', approver_user_id={$user_id}  WHERE commit_id={$data['id']}");

    return [
        "response_data" => [],
        "status_code" => 200,
    ];
};