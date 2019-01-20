<?php

//Passing by reference!
function validateInput(&$data) {
    //Check is fundamental fields are present
    if(!isset($data['limit']))
        throw new InvalidRequestException("limit cannot be blank", 3000);

    if(!isset($data['page']))
        throw new InvalidRequestException("page cannot be blank", 3000);

    //If no sorting option was chosen, sort the commits by timestamp (descending)
    if(!isset($data['sort']) || !isset($data['sort']['parameter']))
        $data['sort'] = [
            'order' => "DESC",
            'parameter' => "modified_date"
        ];
    //Else convert the parameter name from the API one to the DB one
    else {
        $data['sort']['parameter'] = translateName(strtolower($data['sort']['parameter']));
        if(!isset($data['sort']['order'])) $data['sort']['order'] = "DESC";
    }

    /* --SEARCH--
     * Structure: filter ["attribute", "valueMatches" or "valueDifferentFrom"];
     * The search operations are handled by SQL' LIKE function this way: "... AND 'attribute' 'negate' LIKE %'valueMatches'%"
     * If 'valueMatches' is present, the 'negate' field will have no content ("")
     * If 'valueDifferentFrom' is present, 'negate' will contain "NOT" and the content of 'valueDifferentFrom' will be copied into 'valueMatches'
     */ 
    if (isset($data['filter']['attribute'])) {
        if(isset($data['filter']['valueDifferentFrom']) && isset($data['filter']['valueMatches']))
            throw new InvalidRequestException("valueMatches and valueDifferentFrom cannot be specified in the same request!");
        //valueDifferentFrom was passed 
        else if(isset($data['filter']['valueDifferentFrom'])) {
            $data['filter']['valueMatches'] = $data['filter']['valueDifferentFrom'];
            $data['filter']['negate'] = "NOT";
        //valueMatches was passed
        } else if(isset($data['filter']['valueMatches'])) {
            $data['filter']['negate'] = "";
        } else
            throw new InvalidRequestException("valueMatches nor valueDifferentFrom were specified!");

        if (strlen($data['filter']['valueMatches']) == 0)
            throw new InvalidRequestException("filter parameter must have at least length one byte");
    }

    //Convert the attribute name from the API one to the DB one
    $data['filter']['attribute'] = translateName($data['filter']['attribute']);
}

function translateName($attribute) : string {
    switch($attribute) {
        case "id":
            return "commit_id";
        case "description":
            return "description";
        case "timestamp":
            return "creation_date";
        case "update_timestamp":
            return "modified_date";
        case "author":
            return "author_user_id";
        case "approval_status":
            return "is_approved";
        default:
            throw new InvalidRequestException("Invalid parameter '$attribute'");
    }
}

function get_list_data(string $type, array $data, DatabaseWrapper $db, $cur_user_id, $cur_user_role) {
    $req = $data;
    $type = strtolower($type);
    $msg = is_int($cur_user_role[0]);

    //Execute the query based on $type parameter

    switch ($type) {
        case "commit":
            $id = "commit_id";
            break;
        case "request":
            $id = "request_id";
            break;
        default:
            throw new Exception("Impossible to use the list");
    }

    //The real table names are actually plural
    $table = $type . "s";

    //Base query
    $query = "SELECT users.username, users.name, $table.*
        FROM $table, users
        WHERE $table.author_user_id = users.user_id";

    //Filter parameters set (The LIKE part looks like this: attribute _/NOT LIKE %valueMatches%)
    if (isset($data['filter']['attribute']))
        $query .= "AND {$data['filter']['attribute']} {$data['filter']['negate']} LIKE '%{$data['filter']['valueMatches']}%'";

    //If the user is part of the tech area (2) or is a programmer (4), select only users in the same area
    if ($cur_user_role[0] == 2 || $cur_user_role[0] == 4) {
        $area = $db->query("SELECT area_id FROM users WHERE user_id = {$cur_user_id}")[0]['area_id'];
        $query = $query . " AND (SELECT area_id FROM users WHERE author_id = user_id) = {$area}";
    }
    //Append the last part of the query and executes it
    $query .= " ORDER BY {$data['sort']['parameter']} {$data['sort']['order']}";

    $data = $db->query($query);

    
    //Calculate the number of max pages based on the limit (if it's a float number, round by excess)
    $max_page = count($data) / $req['limit'];
    if(is_float($max_page))
        $max_page = (int) $max_page + 1;

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
        'page_total' => $max_page,
        'msg' => $msg
    ];

    //Populate the response array with the commit elements of the chosen page
    for ($i=($page * $req['limit']); $i<(($page+1) * $req['limit']); $i++) {
        $entry = $data[$i];

        if ($entry == NULL)
            break;

        $temp = [
            'id' => $entry[$id],
            'description' => $entry['description'],
            'timestamp' => strtotime($entry['creation_date']),
            'update_timestamp' => strtotime($entry['modified_date']),
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