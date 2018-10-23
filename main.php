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

//Import important libraries
include_once "./lib/libDatabase/include.php";
include_once "./lib/libExceptionRequest/include.php";
include_once "./lib/libPrintDebug/PrintDebug.php";

//Import configuration data
include_once "./config.php";

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

        //Decodes JSON if present
        $request = json_decode(file_get_contents("php://input"), true);

        //Checks if not valid JSON
        if($request == null or $request == false)
            throw new InvalidRequestException("Request is not a JSON");

        //BETA: Module/Action on URL
        $url_data = explode("/", $_SERVER['REQUEST_URI']);
        if(count($url_data) == 4)
        {
            $module = $url_data[2];
            $action = $url_data[3];
            goto module_action_got;
        }

        //Checks if fields are empty or absent
        if(!isset($request['module']) or $request['module'] == "")
            throw new InvalidRequestException("Module can't be left blank");

        if(!isset($request['action']) or $request['action'] == "")
            throw new InvalidRequestException("Action can't be left blank");

        //Saving data on easy variables
        $module = $request['module'];
        $action = $request['action'];

        module_action_got:

        if(!isset($request['request_data']) or is_null($request['request_data'])){
            $addon = "";
            if(is_null($request['request_data']))
                $addon = " | Actual: " . json_encode($request['request_data']);
            throw new InvalidRequestException("Request data can't be left blank$addon");
        }

        //Saving data on easy variables
        $request_data = $request['request_data'];

        //Checks if token is on the header
        $headers = getallheaders();
        if(!isset($headers['X-Auth-Header']))
            if($module == "auth" and $action == "login")
                //The only action which token is not needed
                goto bypass_header_check;
            else
                //No token found
                throw new NoTokenException("Token can't be omitted here");
        else{
            //Checks if token is active or valid
            $result = $db->query("SELECT token_expire FROM users_token_m WHERE token = '{$headers['X-Auth-Header']}'");
            if(is_bool($result) or count($result) == 0)
                throw new InvalidTokenException("Token is not valid");

            if(time() > $result[0]['token_expire']){
                $db->query("DELETE FROM users_token_m WHERE token = '{$headers['X-Auth-Header']}'");
                throw new InvalidTokenException("Token is not valid anymore. Please remake login. " . $printDebug->getDebugString($result[0]['token_expire']));
            }
        }

        $token = $headers['X-Auth-Header'];

        bypass_header_check:

        //Checks if you can find the module
        if(!file_exists(__DIR__ . "/modules/$module/$action.php"))
            throw new NotImplementedException("Module $module/$action not implemented");

        //Initializing essentials variables for actions
        $init = function() { return []; };
        $exec = function (array $data, array $data_init) : array {
            return [
                "response_data" => [],
                "message" => "You are not supposed to see this",
                "status_code" => 500
            ];
        };

        //Bringing the action which we wanted
        require_once __DIR__ . "/modules/$module/$action.php";

        //Made for init data
        if(isset($init))
            $data_init = $init($request_data);
        else
            $data_init = [];

        //Get the response you need
        $response = $exec($request_data, $data_init);

        if(isset($token) || isset($response['response_data']['token'])){
            //Take the new generated token if you generated one
            if(isset($response['response_data']['token']))
                $token = $response['response_data']['token'];
            //Write the new token expire
            if($printDebug->isDebug()) // DEBUG PURPOSE ONLY
                $new_expire = time() + (60 * 1); //Valid for one minute for debugging multiple timeout
            else
                $new_expire = time() + ((60*60) * 4); //Token Valid for more 4hours from now.
            $db->query("UPDATE users_token_m SET token_expire = $new_expire WHERE token = '$token'");
        }

    }catch (ExceptionRequest $invalidRequestException){
        //Simple error
        $response = $invalidRequestException->getErrorResponse();
    }catch (Exception $exception){
        //Fatal error
        $response = [
            'response_data' => [],
            'status_code' => 500
        ];

        //DEBUG ENVIRONMENT ONLY
        if($printDebug->isDebug()){
            $response['dev_message'] = [
                'message' => $exception->getMessage(),
                'stack_trace' => $exception->getTrace(),
            ];
            $response['message'] = "Internal Server Error";
        }
    }

    //Here ends the request with HTTP Code and JSON-ifying of a response
    http_response_code($response['status_code']);
    echo json_encode($response);
    exit;
}