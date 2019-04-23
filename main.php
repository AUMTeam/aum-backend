<?php
$warnings = [];

require_once __DIR__ . "/config.php";

//Initializing debug mode
require_once __DIR__ . "/lib/libPrintDebug/PrintDebug.php";
$printDebug = new PrintDebug($debug_mode);

//Set the error reporting system
require_once __DIR__ . "/lib/libCatcher/include.php";
//register_shutdown_function("envi_shutdown_catcher");
set_error_handler("envi_error_catcher", E_STRICT);    //Catch on PHP Fatal error
set_error_handler("envi_warning_catcher", E_WARNING); //Catch on PHP Warning
set_error_handler("envi_notice_catcher", E_NOTICE);   //Catch on PHP Notice

//Import important libraries
require_once __DIR__ . "/lib/libDatabase/include.php";
require_once __DIR__ . "/lib/libExceptionRequest/include.php";
require_once __DIR__ . "/lib/libUserInfo/include.php";
require_once __DIR__ . "/lib/libToken/include.php";

//Set basic headers
date_default_timezone_set('Europe/Rome');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, X-Auth-Header, Accept-Encoding");
header("Content-Encoding: gzip");
header("Server-Version: $version");


//GZIP compression
if(!ob_start("ob_gzhandler")) ob_start();

if (!($_SERVER['REQUEST_METHOD'] === 'POST')) {
    //OPTIONS Method -> communicate the allowed methods
    if($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        http_response_code(200);
        header("Access-Control-Allow-Methods: POST, OPTIONS");
        $printDebug->printDebug("Options message sent\n");
    } else if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        //Other Methods (typically GET) -> show an easter egg if in debug mode
        http_response_code(405);
        $printDebug->printDebug('
        <html>
            <head>
                <title>405 Method NOT Supported - AUM</title>
            </head>
            <body>
                <img style="width:100%; height:auto;" src="/img/not_post_req.jpg">
            </body>
        </html>
        ');
    }
//POST Method
} else {
    header("Content-Type: application/json");

    if (!$maintenance_state) {
        //Header identification server status
        if($printDebug->isDebug())
            header("Server-Mode: Chihiro API");
        else
            header("Server-Mode: AUM API");

        $response = NULL;
        $db = NULL;

        try {
            $db = new DatabaseWrapper($db_type, $config);

            //**JSON Parsing**
            //Decodes JSON if present
            $request = json_decode(file_get_contents("php://input"), true);

            //Checks if not valid JSON
            if($request == null or $request == false)
                throw new InvalidRequestException("Request is not a JSON");


            //Module and Action can be specified either in the URL (main.php/module/action) or JSON elements (module=; action=)
            $module = null;
            $action = null;
            $token = null;
            $request_data = [];

            //#1: Handle module and action on URL
            $url_data = explode("/", $_SERVER['REQUEST_URI']);
            if(count($url_data) >= 4 + (count(explode("/", __DIR__)) - 3)) {    //Base dir is '/membri/aum/'. The 'count' thing is done is cases where main.php is not in the root dir
                $main_posi = 0;

                while($url_data[$main_posi] !== "main.php")
                    $main_posi++;

            //Save data on variables
            $module = $url_data[$main_posi+1];
            $action = $url_data[$main_posi+2];

            //#2: Handle module and action in JSON (or fail if they're not present)
            } else {
                //Checks if fields are empty or absent
                if(!isset($request['module']) or $request['module'] == "")
                    throw new InvalidRequestException("Module can't be left blank");
                if(!isset($request['action']) or $request['action'] == "")
                    throw new InvalidRequestException("Action can't be left blank");

                //Save data on variables
                $module = $request['module'];
                $action = $request['action'];
            }

            //Save the payload if present
            if(!isset($request['request_data']) or is_null($request['request_data'])){
                //Preparing an empty object as default request
                $request['request_data'] = [];
            }
            $request_data = $request['request_data'];

            //Getting all headers from request
            $headers = getallheaders();

            //Saving the token on somewhere more easy to retreive later
            if(isset($headers['X-Auth-Header']))
                $token = $headers['X-Auth-Header'];
            else if(isset($headers['X-Auth-Header']))
                $token = $headers['x-auth-header'];


            //Ignoring token check only when special entrypoints are called
            if(!(($module == "auth" and $action == "login") or ($module == "data"))) {
                //Checks if token is on the header
                if($token == null)
                    //No token found
                    throw new NoTokenException("Token can't be omitted here");
                else
                    getTokenExpire();   //We aren't interested in the return value
            }

            //Checks if you can find the module
            if(!file_exists(__DIR__ . "/modules/$module/$action.php"))
                throw new NotImplementedException("Module $module/$action not implemented");

            //Initializing essentials variables for actions
            $init = function (array $data) { return []; };
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

            //Handling token expiration starts here:
            if(isset($token) || isset($response['response_data']['token'])) {
                //Take the new generated token if you generated one
                if(isset($response['response_data']['token']))
                    $token = $response['response_data']['token'];

                //Write the new token expire
                increaseTokenExpire();
            }

        }catch (ExceptionRequest $ex) {
            //Simple error
            $response = $ex->getErrorResponse();
        }catch (Exception $exception) {
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

        //Get the warnings on a response
        if(count($warnings) > 0)
            $response['response_data']['debug']['warnings'] = $warnings;

    } else {
        $response = [
            "status_code" => 503,
            "message" => "Server in manutenzione",
        ];
    }

    //Here ends the request with HTTP Code and JSON-ifying of a response
    http_response_code($response['status_code']);
    echo json_encode($response);
}

//Terminate the server for all the methods
ob_end_flush();
exit;