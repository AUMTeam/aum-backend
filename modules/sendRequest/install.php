<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $db;
    global $token;

    if (!isset($data['id']))
        throw new InvalidRequestException();

    $info = getMyInfo($token);
    $now = time();

    if (in_array(4, $info['role'])) {
        $feedback = "";
        if (isset($data['feedback']))
            $feedback = $data['feedback'];

        $db->preparedQuery("UPDATE requests_clients SET comment=?, install_date=FROM_UNIXTIME(?)
            WHERE request_id=? AND client_user_id=?", [$feedback, $now, $data['id'], $info['user_id']]);
    }
    

    return [
        "response_data" => [ ],
        "status_code" => 200
    ];
};