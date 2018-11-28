<?php
/**
 * Created by PhpStorm.
 * User: User
 * Date: 28/11/2018
 * Time: 23:15
 */

function to_int($i) : int {
    return (int) $i;
}

function get_commit_list_data(array $data, DatabaseWrapper $db){

    $req = $data;

    $data = $db->query(
        "SELECT users_m.username, commit_m.*
        FROM commit_m, users_m
        WHERE commit_m.author_user_id = users_m.user_id
        ORDER BY {$data['sort']['parameter']} {$data['sort']['order']}"
    );

    $out = [
        'count' => 0,
        'count_total' => count($data),
        'list' => [],
        'page' => $req['page'],
        'page_total' => 0
    ];

    $max_page = count($data) / $req['limit'];

    if(is_float($max_page))
        $max_page = to_int($max_page) + 1;

    $out['page_total'] = $max_page;

    for( $i=($req['page'] * $req['limit']); $i<(($req['page']+1) * $req['limit']); $i++ ) {
        $entry = $data[$i];

        if ($entry == NULL)
            break;

        $out['list'][] = [
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

    $out['count'] = count($out['list']);

    return $out;
}