<?php

$init = function (array $data) : array { return []; };

$exec = function (array $data, array $data_init) : array {

    global $db;

    if(!isset($data['search']))
        throw new InvalidRequestException("search cannot be blank", 3001);

    if(strlen($data['search']) == 0)
        throw new InvalidRequestException("search parameter must have at least length one byte");

    $search = $data['search'];
    $data['sort']['parameter'] = "timestamp";
    $data['sort']['order'] = "DESC";
    $data['limit'] = 99999;
    $data['page'] = 0;

    $data = get_list_data("commit", $data, $db);

    $out = [
        "count" => 0,
        "list" => []
    ];

    foreach ($data['list'] as $commit){
        if(!is_bool(strpos($commit['description'], $search)))
            $out['list'][] = $commit;
    }

    $out['count'] = count($out['list']);

    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};