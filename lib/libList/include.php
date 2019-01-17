<?php

function to_int($i) : int {
    return (int) $i;
}

function get_list_data(string $type, array $data, DatabaseWrapper $db, $cur_user_id, $cur_user_role) {
    $req = $data;
    $type = strtolower($type);

    //Execute the query based on $type parameter
    //The LIKE part looks like this: attribute _/NOT LIKE %valueMatches%
    switch ($type){
        case "commit":
            $query = "SELECT users_v2.username, users_v2.name, commits_v2.*
            FROM commits_v2, users_v2
            WHERE commits_v2.author_user_id = users_v2_v2.user_id AND {$data['filter']['attribute']} {$data['filter']['negate']} LIKE '%{$data['filter']['valueMatches']}%'";
            
            //If the user is part of the tech area or is a programmer, select only users_v2 in the same area
            if ($cur_user_role[0] == 2 || $cur_user_role[4]) {  // Tech Area
                $area = $db->query("SELECT area_id FROM users_v2 WHERE user_id = {$cur_user_id}")[0]['area_id'];
                $query = $query . " AND (SELECT area_id FROM users_v2 WHERE author_user_id = user_id) = {$area}";
            }

            //Append the last part of the query and execute it
            $query .= " ORDER BY {$data['sort']['parameter']} {$data['sort']['order']}";
            $data = $db->query($query);

            $id = "commit_id";
            break;
        case "request":
            $query = "SELECT users_v2.username, users_v2.name, requests_v2.*
            FROM requests_v2, users_v2
            WHERE requests_v2.author_user_id = users_v2.user_id AND {$data['filter']['attribute']} {$data['filter']['negate']} LIKE '%{$data['filter']['valueMatches']}%'
            ORDER BY {$data['sort']['parameter']} {$data['sort']['order']}";

            //If the user is part of the tech area or is a programmer, select only users_v2 in the same area
            if ($cur_user_role[0] == 2 || $cur_user_role[4]) {  // Tech Area
                $area = $db->query("SELECT area_id FROM users_v2 WHERE user_id = {$cur_user_id}")[0]['area_id'];
                $query = $query . " AND (SELECT area_id FROM users_v2 WHERE author_user_id = user_id) = {$area}";
            }

            //Append the last part of the query and execute it
            $query .= " ORDER BY {$data['sort']['parameter']} {$data['sort']['order']}";
            $data = $db->query($query);
            
            $id = "request_id";
            break;
        default:
            throw new Exception("Impossible to use the list");
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
                'user_id' => $entry['author_user_id'],
                'username' => $entry['username'],
                'name' => $entry['name']
            ]
        ];

        $out['list'][] = $temp;
    }

    $out['count'] = count($out['list']);

    return $out;
}