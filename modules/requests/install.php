<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {
    global $db;
    global $token;

    $info = getMyInfo($token);
    $now = time();

    if (in_array(4, $info['role'])) {
        if (isset($data['id'])) {
            $feedback = "";
            if (isset($data['feedback']))
                $feedback = $data['feedback'];

            $db->query("UPDATE requests_clients SET comment='$feedback', install_date=FROM_UNIXTIME($now) WHERE request_id={$data['id']} AND client_user_id={$info['user_id']}");
        }
    }
    

    return [
        "response_data" => [ ],
        "status_code" => 200
    ];
};