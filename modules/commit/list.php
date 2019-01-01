<?php

$init = function (array $data) : array { return [
    'functions' => [
        'to_int' => function ($i) : int {
            return (int) $i;
        }
    ]
]; };

$exec = function (array $data, array $data_init) : array {
    global $db;
    global $token;

    //Check is fundamental fields are present
    if(!isset($data['limit']))
        throw new InvalidRequestException("limit cannot be blank", 3000);

    if(!isset($data['page']))
        throw new InvalidRequestException("page cannot be blank", 3000);

    //If no sorting option was chosen, sort the commits by timestamp (descending)
    if(!isset($data['sort']) || !isset($data['sort']['parameter']))
        $data['sort'] = [
            'order' => "DESC",
            'parameter' => "timestamp"
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
    //If no search was meant to be done, populate the 'filter' values with placeholder elements, otherwise the query will fail
    // (the query portion will look like this: "... AND id LIKE %%", which will be then removed by the DB query optimizer)
    if (!isset($data['filter']['attribute'])) {
        $data['filter']['attribute'] = "id";
        $data['filter']['valueMatches'] = "";
    //Filter was present
    } else {
        if(isset($data['filter']['valueDifferentFrom']) && isset($data['filter']['valueMatches']))
            throw new InvalidRequestException("valueMatches and valueDifferentFrom cannot be specified in the same request!");
        //valueDifferentFrom was passed 
        else if(isset($data['filter']['valueDifferentFrom'])) {
            $data['filter']['valueMatches'] = $data['filter']['valueDifferentFrom'];
            $data['filter']['negate'] = "NOT";
        //valueMatches was passed
        } else
            $data['filter']['negate'] = "";

        if (strlen($data['filter']['valueMatches']) == 0)
            throw new InvalidRequestException("search parameter must have at least length one byte");
    }

    //Convert the attribute name from the API one to the DB one
    $data['filter']['attribute'] = translateName($data['filter']['attribute']);

    $user_id = getUserData($db, $token)['user_id'];

    return [
        "response_data" => get_list_data("commit", $data, $db, $user_id),
        "status_code" => 200,
    ];
};

function translateName($attribute) : string {
    switch($attribute) {
        case "id":
            return "commit_id";
        case "description":
            return "description";
        case "timestamp":
            return "timestamp";
        case "author":
            return "author_user_id";
        case "approval_status":
            return "is_approved";
        default:
            throw new InvalidRequestException("Invalid parameter");
    }
}