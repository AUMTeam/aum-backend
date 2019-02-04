<?php

//Validate the user input
function validateInput(&$data) {    //Passing by reference!
    //Check is fundamental fields are present
    if(!isset($data['limit']))
        throw new InvalidRequestException("limit cannot be blank", 3000);

    if(!isset($data['page']))
        throw new InvalidRequestException("page cannot be blank", 3000);

    //If no sorting option was chosen, sort the commits by timestamp (descending)
    if(!isset($data['sort']) || !isset($data['sort']['parameter'])) {
        $data['sort'] = [
            'order' => "DESC",
            'parameter' => "approvation_date"
        ];
    //Else convert the parameter name from the API one to the DB one
    } else {
        $data['sort']['parameter'] = translateName(strtolower($data['sort']['parameter']), $type);
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
        else
            //Convert the attribute name from the API one to the DB one
            $data['filter']['attribute'] = translateName($data['filter']['attribute'], $type);
    }
}

//Translates the names from the API one to the DB one
function translateName($attribute, $type) : string {
    switch($attribute) {
        case "id":
            return $type;
        case "description":
            return "description";
        case "timestamp":
            return "creation_date";
        case "update_timestamp":
            return "approvation_date";
        case "author":
            return "author_user_id";
        case "reviewrer":
            return "approver_user_id";
        case "approval_status":
            return "is_approved";
        case "component":
            return "component_id";
        case "branch":
            return "branch_id";
        default:
            throw new InvalidRequestException("Invalid parameter '$attribute'");
    }
}

function get_list_data(string $type, array $data, DatabaseWrapper $db, $cur_user_id, $cur_user_role) {
    $type = strtolower($type);

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
    //Calculate the starting commit ID (number of commits per page * number of page)
    $startID = $data['limit'] * $data['page'];

    //Base query
    $query = "SELECT author.username as au_username, author.name as au_name,
        approver.username as ap_username, approver.name as ap_name, $table.*
        FROM $table, users as author, users as approver
        WHERE $id>=$startID AND $table.author_user_id = author.user_id 
        AND $table.approver_user_id = approver.user_id "; //Ex: WHERE commits.commit_id>=0

    //Filter parameters was set (The LIKE part looks like this: attribute _/NOT LIKE %valueMatches%)
    if (isset($data['filter']['attribute']))
        $query .= " AND {$data['filter']['attribute']} {$data['filter']['negate']} LIKE '%{$data['filter']['valueMatches']}%'";

    //If the user is part of the tech area (2) or is a programmer (4), select only users in the same area
    if (in_array(2, $cur_user_role) || in_array(4, $cur_user_role)) {
        $area = $db->query("SELECT area_id FROM users WHERE user_id = {$cur_user_id}")[0]['area_id'];
        $query .= " AND (SELECT area_id FROM users WHERE author_user_id = user_id) = {$area}";
    }
    //Order part
    $query .= " ORDER BY {$data['sort']['parameter']} {$data['sort']['order']}";

    //Limit the query to the number of elements requested
    $query .= " LIMIT {$data['limit']}";

    $queryResult = $db->query($query);


    //Get the total number of commits
    $query = substr($query, strpos($query, 'FROM'));                //Strip SELECT * part
    $queryIniz = substr($query, 0, strpos($query, "WHERE") + 6);    //Strip 'commit_id=$startID' part
    $queryFin = substr($query, strpos($query, "AND") + 3);

    $countQuery = "SELECT COUNT(*) AS 'count' " . $queryIniz . $queryFin;
    $countTotal = (int) $db->query($countQuery)[0]['count'];

    //Calculate the number of max pages based on the limit (if it's a float number, round by excess)
    $max_page = $countTotal / $data['limit'];
    if(is_float($max_page))
        $max_page = (int) $max_page + 1;

    //The page count starts from 0: lower the max_page value by one
    $max_page = $max_page - 1;
    
    //Verify if the chosen page number is above the total number of pages: in that case, output the latest available page
    $page = (int) $data['page'];
    if ($page > $max_page) $page = $max_page;

    //Prepopulate the response array
    $out = [
        'count' => count($queryResult),
        'count_total' => $countTotal,
        'list' => [],
        'page' => $page,
        'page_total' => $max_page,
    ];

    //Populate the response array with each commit element of the chosen page
    foreach ($queryResult as $entry) {

        if ($entry == NULL)
            break;

        $temp = [
            'id' => $entry[$id],
            'description' => $entry['description'],
            'timestamp' => strtotime($entry['creation_date']),
            'update_timestamp' => is_null($entry['approvation_date']) ? 0 : strtotime($entry['approvation_date']),
            'approval_status' => $entry['is_approved'],
            'author' => [
                'user_id' => $entry['author_user_id'],
                'username' => $entry['au_username'],
                'name' => $entry['au_name']
            ],
            'approver' => [
                'user_id' => $entry['approver_user_id'],
                'username' => $entry['ap_username'],
                'name' => $entry['ap_name']
            ]
        ];

        $out['list'][] = $temp;
    }

    return $out;
}