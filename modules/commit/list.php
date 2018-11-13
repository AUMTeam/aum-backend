<?php
/**
 * Created by PhpStorm.
 * User: User
 * Date: 05/11/2018
 * Time: 19:17
 */

$init = function (array $data) : array { return [
    'functions' => [
        'to_int' => function ($i) : int {
            return (int) $i;
        }
    ]
]; };

$exec = function (array $data, array $data_init) : array {

    global $db;

    if(!isset($data['sort']))
        $data['sort'] = [
            'order' => "DESC",
            'parameter' => "timestamp"
        ];

    if(!isset($data['limit']))
        throw new InvalidRequestException("limit cannot be blank", 3000);

    if(!isset($data['page']))
        throw new InvalidRequestException("page cannot be blank", 3000);

    if(!isset($data['sort']['order']))
        $data['sort']['order'] = "DESC";

    if(!isset($data['sort']['parameter']))
        $data['sort']['parameter'] = "timestamp";

    $req = $data;

    $data = $db->query(
        "SELECT users_m.username, commit_m.*
        FROM commit_m, users_m
        WHERE commit_m.author_user_id = users_m.user_id
        ORDER BY {$data['sort']['parameter']} {$data['sort']['order']}"
    );

    $out = [
        'count' => 0,
        'commit_list' => [],
        'page' => $req['page'],
        'page_total' => 0
    ];

    $max_page = count($data) / $req['limit'];

    if(is_float($max_page))
        $max_page = $data_init['functions']['to_int']($max_page) + 1;

    $out['page_total'] = $max_page;

    for( $i=($req['page'] * $req['limit']); $i<(($req['page']+1) * $req['limit']); $i++ ) {
        $entry = $data[$i];

        if ($entry == NULL)
            break;

        $out['commit_list'][] = [
            'id' => $entry['commit_id'],
            'description' => $entry['description'],
            'timestamp' => strtotime($entry['timestamp']),
            'approval_status' => $entry['is_approved'],
            'author' => [
                'user_id' => $entry['author_user_id'],
                'username' => $entry['username']
            ]
        ];
    }

    $out['count'] = count($out['commit_list']);

    return [
        "response_data" => $out,
        "status_code" => 200
    ];
};