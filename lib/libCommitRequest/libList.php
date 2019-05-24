<?php

//Type of the list (commit/request/client)
$listType;
$idType;

//Validate the user input
function validateInput(array $data) : array {
    global $listType;

    //Check is fundamental fields are present
    if(!isset($data['limit']))
        throw new InvalidRequestException("limit cannot be blank", "ERROR_COMMIT_LIST_NO_LIMIT");
    if(!isset($data['page']))
        throw new InvalidRequestException("page cannot be blank", "ERROR_COMMIT_LIST_NO_LIMIT");

    
    /* **SORTING**
     * If no sorting option was chosen, sort the commits by timestamp (descending)
     */
     if(empty($data['sort']) || empty($data['sort']['parameter'])) {
        $data['sort'] = [
            'order' => "DESC",
            'parameter' => ["approvation_timestamp, creation_timestamp"]
        ];
        if ($listType == TYPE_CLIENT)   //Sort by send_timestamp for client list
            $data['sort']['parameter'] = "send_timestamp";
        else if (!empty($data['role']) && $data['role'] == ROLE_REVOFFICE)
            $data['sort']['parameter'] = ["send_timestamp, approvation_timestamp"];
    //Else convert the parameter name from the API one to the DB one
    } else {
        $data['sort']['parameter'] = translateName($data['sort']['parameter'], $listType);
        if(empty($data['sort']['order'])) $data['sort']['order'] = "DESC";
    }

    /* --SEARCH--
     * Structure: filter ["attribute", "valueMatches" or "valueDifferentFrom"];
     * The search operations are handled by SQL' LIKE function this way: "... AND 'attribute' 'negate' LIKE %'valueMatches'%"
     * If 'valueMatches' is present, the 'negate' field will have no content ("")
     * If 'valueDifferentFrom' is present, 'negate' will contain "NOT" and the content of 'valueDifferentFrom' will be copied into 'valueMatches'
     */ 
    if (!empty($data['filter'])) {
        foreach($data['filter'] as &$elem) {
            //valueDifferentFrom was passed 
            if(isset($elem['valueDifferentFrom'])) {
                $elem['valueMatches'] = $elem['valueDifferentFrom'];
                $elem['negate'] = "NOT";
            //valueMatches was passed
            } else if(isset($elem['valueMatches'])) {
                $elem['negate'] = "";
            } else
                throw new InvalidRequestException("valueMatches nor valueDifferentFrom were specified!");

            //OK - convert the attribute name from the API one to the DB one
            $elem['attribute'] = translateName($elem['attribute'], $listType);
        }
    }
    return $data;
}

//Translates the names from the API one to the DB one
function translateName(string $attribute) : string {
    global $listType;
    
    //Check for attributes allowed only in request
    if ($listType==TYPE_REQUEST) {
        if ($attribute=="send_timestamp" || $attribute=="install_type" 
                || $attribute=="install_link")
            return $attribute;
    }

    //Check for attributes allowed only in client list
    if ($listType==TYPE_CLIENT) {
        if ($attribute=="send_timestamp" || $attribute=="install_timestamp" || $attribute=="install_status" || $attribute=="install_type" 
                || $attribute=="install_link" || $attribute=="install_comment")
            return $attribute;
    }

    switch($attribute) {
        case "id":
            if ($listType == TYPE_COMMIT)
                return TYPE_COMMIT_ID;
            else
                return TYPE_REQUEST_ID;
        case "title":
        case "description":
        case "approval_status":
        case "components":
            return $attribute;
        case "timestamp":
            return "creation_timestamp";
        case "update_timestamp":
            return "approvation_timestamp";
        case "author":
            return "author_user_id";
        case "approver":
            return "approver_user_id";
        case "branch":
            return "branch_id";
        default:
            throw new InvalidRequestException("Invalid sorting/filtring parameter '$attribute'");
    }
}

/**
 * Build the query based on $type parameter
 */
function getQuery(string $type, array $data, array &$params) : string { 
    $id = '';
    //Check the $type parameter
    switch ($type) {
        case TYPE_COMMIT:
            $id = TYPE_COMMIT_ID;
            break;
        case TYPE_REQUEST:
            $id = TYPE_REQUEST_ID;
            break;
        case TYPE_CLIENT:
            break;
        default:
            throw new InvalidRequestException("Impossible to use the list");
    }
    
    global $listType, $db, $user, $idType;
    $listType = $type;
    $idType = $id;
    $data = validateInput($data);
    $query;

    //Calculate the starting ID (number of commits per page * number of page)
    $data['limit'] = intval($data['limit']);
    $offset = $data['limit'] * intval($data['page']);

    //Get the query from the above functions
    if ($listType == TYPE_CLIENT)
        $query = getClientQuery($user['user_id'], $params);
    else
        $query = getInternalQuery($data, $user['user_id'], $user['role_name'], $params);
    
    //If filter was set, add it to the query
    if (!empty($data['filter'])) {   //Attribute and Negate are safe
        foreach($data['filter'] as $elem) {
            $query .= " AND {$elem['attribute']} {$elem['negate']} LIKE ?";
            $params[] = "%{$elem['valueMatches']}%";
        }
    }
    
    //Order the result based on 'sort' array in request (parameter and order are safe)
    $order = $data['sort']['parameter'];
    if (is_array($order))
        $order = "COALESCE(" . implode(", ", $data['sort']['parameter']) . ")"; //parameter can hold more than one attribute
    $query .= " ORDER BY {$order} {$data['sort']['order']}";

    //Limit the query from the offset to the number of elements requested
    $query .= " LIMIT ?";
    $params[] = $data['limit'];
    $query .= " OFFSET ?";
    $params[] = $offset;

    return $query;
}

function getClientQuery(int $cur_user_id, array &$params) : string {
    $params = [$cur_user_id];
    
    return "SELECT requests.request_id as id, title, description, install_type, install_status, install_timestamp, 
        comment, install_link, branch_name, send_timestamp, author.name as au_name, approver.name as ap_name, components
        FROM requests_clients, requests, branches, users as approver, users as author
        WHERE requests_clients.request_id=requests.request_id AND branches.branch_id=requests.branch_id AND approver.user_id=requests.approver_user_id
            AND author.user_id=requests.author_user_id AND approval_status='2' AND client_user_id=?";
}

function getInternalQuery(array $data, int $cur_user_id, array $cur_user_role, array &$params) : string {
    global $db;
    global $listType;
    $query;
    
    //Base query - $listType is safe and prepared statements could not be used in FROM anyway
    $query = "SELECT author.email as au_email, author.name as au_name,
    approver.email as ap_email, approver.name as ap_name, $listType.*, branch_name
    FROM $listType LEFT JOIN users as approver ON $listType.approver_user_id=approver.user_id, users as author, branches
    WHERE $listType.author_user_id=author.user_id AND branches.branch_id=$listType.branch_id";

    //If the user is part of the tech area (2), select only users in the same area  TODO: Tech Area users can access also other areas' requests
    if (!empty($data['role']) && $data['role'] == ROLE_REVOFFICE) {
        $query .= " AND approval_status IN ('1','2')";
    } else if (in_array(ROLE_TECHAREA, $cur_user_role)) {
        $area = $db->preparedQuery("SELECT area_id FROM users WHERE user_id=?", [$cur_user_id])[0]['area_id'];
        $query .= " AND (SELECT area_id FROM users WHERE author_user_id = user_id) = {$area}";
    //If the user is a programmer (1), show only his commits
    } else if (in_array(ROLE_DEVELOPER, $cur_user_role)) {
        $query .= " AND author_user_id=?";
        $params[] = $cur_user_id;
    }

    return $query;
}

//Get the total number of elements
function getCount(string $query, array $data, array $queryResult, array $params) : array {
    global $db;
    $out = [];

    //Remove last two elements of params array (LIMIT part)
    array_pop($params);
    array_pop($params);
    
    //Query string manipulation - we want to have only SELECT COUNT(*) FROM ...
    $countQuery = substr($query, strpos($query, 'FROM'));                //Strip SELECT * part
    $countQuery = substr($countQuery, 0, strpos($countQuery, 'ORDER'));  //Strip ORDER BY part

    $countQuery = "SELECT COUNT(*) AS c " . $countQuery;           //Add COUNT in SELECT
    //Get the total number of elements
    $countTotal = (int) $db->preparedQuery($countQuery, $params)[0]['c'];

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

/**
 * Build the response for commits / send requests / client send requests
 */
function get_list(string $type, array $data) : array {
    $params = [];
    $out = [];
    global $db, $listType, $idType;
    $query = getQuery($type, $data, $params);

    //Execute the query and get the count of elements
    $queryResult = $db->preparedQuery($query, $params);
    $out = getCount($query, $data, $queryResult, $params);
    
    //Populate the response array based on $listType
    if ($listType == TYPE_CLIENT) {
        foreach($queryResult as $entry) {
            $temp = [
                'id' => $entry['id'],
                'title' => $entry['title'],
                'description' => $entry['description'],
                'branch' => $entry['branch_name'],
                'components' => $entry['components'],
                'install_type' => $entry['install_type'],
                'install_link' => $entry['install_link'],
                'install_timestamp' => is_null($entry['install_timestamp']) ? null : strtotime($entry['install_timestamp']),
                'send_timestamp' => is_null($entry['send_timestamp']) ? null : strtotime($entry['send_timestamp']),
                'install_status' => $entry['install_status'],
                'install_comment' => $entry['comment'],
                'resp' => [
                    $entry['ap_name'],
                    $entry['au_name']
                ]
            ];
            $out['list'][] = $temp;
        }
    } else {
        //Populate the response array with each element of the chosen page
        foreach ($queryResult as $entry) {
            $temp = [
                'id' => $entry[$idType],
                'title' => $entry['title'],
                'description' => $entry['description'],
                'timestamp' => strtotime($entry['creation_timestamp']),
                'update_timestamp' => is_null($entry['approvation_timestamp']) ? null : strtotime($entry['approvation_timestamp']),
                'components' => $entry['components'],
                'branch' => $entry['branch_name'],
                'approval_status' => $entry['approval_status'],
                'author' => [
                    'name' => $entry['au_name'],
                    'email' => $entry['au_email']
                ]
            ];

            //Add the approver infos if the element was approved
            if ($temp['approval_status'] != 0)
                $temp += [
                    'approver' => [
                        'name' => $entry['ap_name'],
                        'email' => $entry['ap_email']
                    ],
            ];

            if ($listType==TYPE_REQUEST) {
                //Get the install type and link
                $temp += [
                    'install_link' => $entry['install_link'],
                    'install_type' => $entry['install_type'],
                    'send_timestamp' => is_null($entry['send_timestamp']) ? 0 : strtotime($entry['send_timestamp'])
                ];

                //Get the list of commits
                $temp += [
                    'commits' => $db->preparedQuery("SELECT commits.commit_id as id, title FROM commits, requests_commits
                    WHERE commits.commit_id=requests_commits.commit_id AND request_id=?", [$temp['id']])
                ];

                //Get the destination clients
                $temp += [
                    'clients' => $db->preparedQuery("SELECT name, email FROM users, requests_clients
                    WHERE users.user_id=requests_clients.client_user_id AND request_id=?", [$temp['id']])
                ];

            }
            $out['list'][] = $temp;
        }
    }

    return $out;
}