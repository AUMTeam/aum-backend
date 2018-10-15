<?php
/**
 * Created by PhpStorm.
 * User: Utente
 * Date: 2018/10/10
 * Time: 15:11
 */

date_default_timezone_set('Europe/Rome');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, X-Auth-Header");

include_once "config.php";
include_once "lib/libDatabase/include.php";
include_once "lib/libExceptionRequest/include.php";
include_once "lib/libPrintDebug/PrintDebug.php";

if (!($_SERVER['REQUEST_METHOD'] === 'POST')){
    if($_SERVER['REQUEST_METHOD'] === 'OPTIONS'){
        //Necessary to comunicate the allowed methods through the OPTIONS method
        http_response_code(200);
        header("Access-Control-Allow-Methods: POST, OPTIONS");
        $printDebug->printDebug("OPTIONS MESSAGE SENT\n");
        exit;
    }
    //Easter egg for whom don't use POST method for access
    http_response_code(405);
    $printDebug->printDebug('
    <html>
        <head>
            <style>
                img { width: 100%; height: auto; }
            </style>
        </head>
        <body>
            <img src="./img/not_post_req.jpg">
        </body>
    </html>
    ');
    exit;
}else{

    header("Content-Type: application/json");
    $response = NULL;
    $db = new SQLite3DatabaseWrapper("./db/main.db_");
    //$db = new MySQLDatabaseWrapper($config);

    try{
        //Checks if the request has the JSON
        //if(!isset($_POST['json']))
            //throw new InvalidRequestException("Request data not found");

        //Decodes JSON if present
        $request = json_decode(file_get_contents("php://input"), true);

        //Checks if not valid JSON
        if($request == null or $request == false)
            throw new InvalidRequestException("Request is not a JSON");

        //Checks if fields are empty or absent
        if(!isset($request['module']) or $request['module'] == "")
            throw new InvalidRequestException("Module can't be left blank");

        if(!isset($request['action']) or $request['action'] == "")
            throw new InvalidRequestException("Action can't be left blank");

        if(!isset($request['request_data']) or is_null($request['request_data'])){
            $addon = "";
            if(is_null($request['request_data']))
                $addon = " | Actual: " . json_encode($request['request_data']);
            throw new InvalidRequestException("Request data can't be left blank$addon");
        }

        //Saving data on easy variables
        $module = $request['module'];
        $action = $request['action'];
        $request_data = $request['request_data'];

        //Checks if token is on the header
        $headers = getallheaders();
        if(!isset($headers['X-Auth-Header']))
            if($module == "auth" and $action == "login")
                //The only action which token is not needed
                goto bypass_header_check;
            else
                throw new NoTokenException("");
        else{
            //Checks if token is active or valid
            $result = $db->query("SELECT user_id FROM users WHERE token = '{$headers['X-Auth-Header']}'");
            if(is_bool($result) or count($result) == 0)
                throw new InvalidTokenException("Token is not valid");
        }

        bypass_header_check:

        //Checks if you can find the module
        if(!file_exists(__DIR__ . "/modules/$module/$action.php"))
            throw new NotImplementedException("Module $module/$action not implemented");

        $init = function() { return [];};
        $exec = function (array $data, array $data_init) : array {
            return [
                "response_data" => [],
                "message" => "You are not supposed to see this",
                "status_code" => 500
            ];
        };

        require_once __DIR__ . "/modules/$module/$action.php";

        //Made for init data
        if(isset($init))
            $data_init = $init($request_data);
        else
            $data_init = [];

        //Get the response you need
        $response = $exec($request_data, $data_init);

    }catch (ExceptionRequest $invalidRequestException){
        $response = $invalidRequestException->getErrorResponse();
    }catch (Exception $exception){
        $response = [
            'response_data' => [],
            'dev_message' => [
                'message' => $exception->getMessage(),
                'stack_trace' => $exception->getTrace(),
            ],
            'message' => "Internal Server Error",
            'status_code' => 500
        ];
    }

    end_request:

    http_response_code($response['status_code']);
    echo json_encode($response);
    exit;
}