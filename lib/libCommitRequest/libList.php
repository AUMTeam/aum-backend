<?php

$listType;

//Validate the user input
function validateInput(array &$data) : void {
    global $listType;

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
        $data['sort']['parameter'] = translateName(strtolower($data['sort']['parameter']), $listType);
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
            $data['filter']['attribute'] = translateName($data['filter']['attribute'], $listType);
    }
}

//Translates the names from the API one to the DB one
function translateName(string $attribute) : string {
    global $listType;
    
    switch($attribute) {
        case "id":
            if ($listType == TYPE_COMMIT)
                return TYPE_COMMIT_ID;
            else
                return TYPE_REQUEST_ID;
        case "title":
            return "title";
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
        case "components":
            return "components";
        case "branch":
            return "branch_id";
        default:
            throw new InvalidRequestException("Invalid sorting/filtring parameter '$attribute'");
    }
}

function get_list(string $type, array $data, int $cur_user_id, array $cur_user_role) {
    global $listType;
    $listType = $type;
    validateInput($data);
    
    //Execute the query based on $type parameter
    switch ($listType) {
        case TYPE_COMMIT:
            $id = TYPE_COMMIT_ID;
            break;
        case TYPE_REQUEST:
            $id = TYPE_REQUEST_ID;
            break;
        case TYPE_CLIENT:
            break;
        default:
            throw new Exception("Impossible to use the list");
    }

    global $db;
    $query;
    $params = [];
    $out = [];

    //Calculate the starting commit ID (number of commits per page * number of page)
    $data['limit'] = intval($data['limit']);
    $offset = $data['limit'] * intval($data['page']);

    if ($listType == TYPE_CLIENT)
        $query = getClientQuery($cur_user_id, $params);
    else
        $query = getInternalQuery($data, $cur_user_id, $cur_user_role, $params);
    
    if (isset($data['filter']['attribute'])) {   //Attribute and Negate are safe
        $query .= " AND {$data['filter']['attribute']} {$data['filter']['negate']} LIKE ?";
        array_push($params, "%{$data['filter']['valueMatches']}%");
    }
    
    //Order part - safe
    $query .= " ORDER BY {$data['sort']['parameter']} {$data['sort']['order']}";

    //Limit the query from the offset to the number of elements requested
    $query .= " LIMIT ?, ?";
    array_push($params, $offset);
    array_push($params, $data['limit']);

    $queryResult = $db->preparedQuery($query, $params);

    $out = getCount($query, $data, $queryResult, $params);
    

    if ($listType == TYPE_CLIENT) {
        foreach($queryResult as $entry) {
            $temp = [
                'id' => $entry['id'],
                'title' => $entry['title'],
                'description' => $entry['description'],
                'timestamp' => $entry['approvation_date'],
                'branch' => $entry['branch_id'],
                'install_type' => $entry['install_type'],
                'install_link' => $entry['install_link'],
                'install_date' => $entry['install_date'],
                'install_comment' => $entry['comment']
            ];
            $out['list'][] = $temp;
        }
    } else {
        //Populate the response array with each commit element of the chosen page
        foreach ($queryResult as $entry) {
            $temp = [
                'id' => $entry[$id],
                'title' => $entry['title'],
                'description' => $entry['description'],
                'timestamp' => strtotime($entry['creation_date']),
                'update_timestamp' => is_null($entry['approvation_date']) ? 0 : strtotime($entry['approvation_date']),
                'components' => $entry['components'],
                'branch' => $entry['branch_id'],
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
            if ($listType==TYPE_REQUEST) {
                $install = [
                    'install_link' => $entry['install_link'],
                    'install_type' => $entry['install_type']
                ];
                $temp = array_merge($temp, $install);
            }

            $out['list'][] = $temp;
        }
    }

    return $out;
}

function getClientQuery(int $cur_user_id, array &$params) : string {
    $params = [$cur_user_id];
    
    return "SELECT requests.request_id as 'id', title, approvation_date, description, install_type, install_date, comment, install_link, branch_id 
        FROM requests_clients, requests
        WHERE requests_clients.request_id=requests.request_id AND is_approved=2 AND client_user_id=?";
}

function getInternalQuery(array $data, int $cur_user_id, array $cur_user_role, array &$params) : string {
    global $db;
    global $listType;
    $query;
    
    //Base query - $listType is safe and prepared statements could not be used in FROM anyway
    $query = "SELECT author.username as au_username, author.name as au_name,
    approver.username as ap_username, approver.name as ap_name, $listType.*
    FROM $listType LEFT JOIN users as approver ON $listType.approver_user_id=approver.user_id, users as author
    WHERE $listType.author_user_id=author.user_id";

    //If the user is part of the tech area (2), select only users in the same area  TODO: Tech Area users can access also other areas' requests
    if (in_array(2, $cur_user_role)) {
        $area = $db->preparedQuery("SELECT area_id FROM users WHERE user_id=?", [$cur_user_id])[0]['area_id'];
        $query .= " AND (SELECT area_id FROM users WHERE author_user_id = user_id) = {$area}";
    //If the user is a programmer (1), show only his commits
    } else if (in_array(1, $cur_user_role)) {
        $query .= " AND author_user_id=?";
        array_push($params, $cur_user_id);
    }
    return $query;
}

//--Get the total number of commits
function getCount(string $query, array $data, array $queryResult, array $params) : array {
    global $db;
    $out = [];
    //Remove last two elements of params array (LIMIT part)
    array_pop($params);
    array_pop($params);
    
    $countQuery = substr($query, strpos($query, 'FROM'));                //Strip SELECT * part
    $countQuery = substr($countQuery, 0, strpos($countQuery, 'ORDER'));  //Strip ORDER BY part

    $countQuery = "SELECT COUNT(*) AS 'count' " . $countQuery;           //Add COUNT in SELECT
    $countTotal = (int) $db->preparedQuery($countQuery, $params)[0]['count'];

    //Calculate the number of max pages based on the limit (if it's a float number, round by excess)
    if ($countTotal > 0) {
        $max_page = $countTotal / $data['limit'];
        if(is_float($max_page))
            $max_page = (int) $max_page + 1;

        //The page count starts from 0: lower the max_page value by one
        $max_page = $max_page - 1;
    } else      //No elements were found
        $max_page = 0;
    
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

    return $out;
}