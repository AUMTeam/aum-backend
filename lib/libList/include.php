<?php

function to_int($i) : int {
    return (int) $i;
}

function get_list_data(string $type, array $data, DatabaseWrapper $db, $cur_user_id){
    $req = $data;
    $type = strtolower($type);

    //Execute the query based on $type parameter
    //The LIKE part looks like this: attribute _/NOT LIKE %valueMatches%
    switch ($type){
        case "commit":
            $data = $db->query(
            "SELECT users.username, users.name, commit.*
             FROM commit, users
             WHERE commit.author_user_id = users.user_id AND {$data['filter']['attribute']} {$data['filter']['negate']} LIKE '%{$data['filter']['valueMatches']}%'
             ORDER BY {$data['sort']['parameter']} {$data['sort']['order']}"
            );
            $id = "commit_id";
            $author = "author_user_id";
            break;
        case "request":
            $data = $db->query(
            "SELECT users.username, users.name, requests.*
             FROM requests, users
             WHERE requests.requester = users.user_id AND {$data['filter']['attribute']} {$data['filter']['negate']} LIKE '%{$data['filter']['valueMatches']}%'
             ORDER BY {$data['sort']['parameter']} {$data['sort']['order']}"
            );
            $id = "request_id";
            $author = "requester";
            break;
        default:
            throw new Exception("Impossible to use the list");
        //AND ((SELECT area_id FROM users WHERE author_user_id = user_id) LIKE (SELECT area_id FROM users WHERE user_id = $cur_user_id))
    }

    
    //Calculate the number of max pages based on the limit (if it's a float number, round by excess)
    $max_page = count($data) / $req['limit'];
    if(is_float($max_page))
        $max_page = to_int($max_page) + 1;

    //The page count starts from 0: lower the max_page value
    $max_page = $max_page - 1;
    
    //Verify if the chosen page number is above the total number of pages: in that case, output the latest available page
    $page = (int) $req['page'];
    if ($page > $max_page) $page = $max_page;

    //Prepopulate the response array
    $out = [
        'count' => 0,
        'count_total' => count($data),
        'list' => [],
        'page' => $page,
        'page_total' => $max_page
    ];

    //Populate the response array with the commit elements of the chosen page
    for ($i=($page * $req['limit']); $i<(($page+1) * $req['limit']); $i++) {
        $entry = $data[$i];

        if ($entry == NULL)
            break;

        $temp = [
            'id' => $entry[$id],
            'description' => $entry['description'],
            'timestamp' => strtotime($entry['timestamp']),
            'approval_status' => $entry['is_approved'],
            'author' => [
                'user_id' => $entry[$author],
                'username' => $entry['username'],
                'name' => $entry['name']
            ]
        ];

        $out['list'][] = $temp;
    }

    $out['count'] = count($out['list']);

    return $out;
}