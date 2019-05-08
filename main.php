<?php
require_once __DIR__ . "/config.php";
require_once __DIR__ . "/configPsw.php";    //File containing passwords for mail and DB

//Initializing debug mode
require_once __DIR__ . "/lib/libPrintDebug/PrintDebug.php";
$printDebug = new PrintDebug($debug_mode);

//Set the error reporting system
$warnings = [];
require_once __DIR__ . "/lib/libCatcher/include.php";
set_error_handler("envi_error_catcher", E_STRICT);    //Catch on PHP Fatal error
set_error_handler("envi_warning_catcher", E_WARNING); //Catch on PHP Warning
set_error_handler("envi_notice_catcher", E_NOTICE);   //Catch on PHP Notice


//Import other libraries
require_once __DIR__ . "/lib/libExceptionRequest/include.php";
require_once __DIR__ . "/lib/libDatabase/include.php";
require_once __DIR__ . "/lib/libToken/include.php";
require_once __DIR__ . "/lib/libUserInfo/include.php";
require_once __DIR__ . "/lib/libMail/include.php";
require_once __DIR__ . "/vendor/autoload.php";


//Set basic headers
date_default_timezone_set('Europe/Rome');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, X-Auth-Header, Accept-Encoding");
header("Server-Version: $version");
if($printDebug->isDebug())
    header("Server-Mode: AUM API - Debug");
else
    header("Server-Mode: AUM API - Release");


//GZIP compression
//header("Content-Encoding: gzip");
if(!ob_start("ob_gzhandler")) ob_start();


if (!($_SERVER['REQUEST_METHOD'] === 'POST')) {

    if($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {  //OPTIONS Method -> communicate the allowed methods
        http_response_code(200);
        header("Access-Control-Allow-Methods: POST, OPTIONS");
        $printDebug->printDebug("Options message sent\n");

    } else if ($_SERVER['REQUEST_METHOD'] === 'GET') {
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
    } else      //Other methods - Not allowed
        http_response_code(405);

//POST Method
} else {
    header("Content-Type: application/json");

    //Check if the server is in maintenance state
    if (!$maintenance_state) {

        $db = null;
        try {
            //Connect to the database
            $db = new DatabaseWrapper($db_type, $db_config);

            //**JSON Parsing**
            //Decodes JSON if present
            $request = json_decode(file_get_contents("php://input"), true);

            //Checks if not valid JSON
            if(empty($request))
                throw new InvalidRequestException("Request is not a JSON");


            //Defining some useful variables
            $module = null;
            $action = null;
            $response = null;
            $token = null;
            $user = null;
            $request_data = [];

            //Module and Action can be specified either in the URL (main.php/module/action) or JSON elements (module=; action=)
            //#1: Handle module and action in JSON
            if(!empty($request['action']) && !empty($request['module'])) {
                //Save data on variables
                $module = $request['module'];
                $action = $request['action'];
            
            //#2: Handle module and action on URL
            } else {    
                $url_data = explode("/", $_SERVER['REQUEST_URI']);
                $file_path = explode("/", $_SERVER['SCRIPT_NAME']);
                if(count($url_data) == count($file_path) + 2) {    //Check if request has more fields than this file
                    $main_posi = 0;

                    while($url_data[$main_posi] !== "main.php")
                        $main_posi++;

                    //Save data on variables
                    $module = $url_data[$main_posi+1];
                    $action = $url_data[$main_posi+2];

                //Fail
                } else
                    throw new InvalidRequestException("Module and Action can't be left blank");
            }

            //Save the payload if present
            if(empty($request['request_data'])) {
                //Preparing an empty object as default request
                $request['request_data'] = [];
            }
            $request_data = $request['request_data'];

            //Saving the token on somewhere more easy to retreive later
            if(!empty($_SERVER["HTTP_X_AUTH_HEADER"]))
                $token = $_SERVER["HTTP_X_AUTH_HEADER"];

            //Ignoring token check only when special entrypoints are called
            if(!(($module == "auth" && $action == "login") || ($module == "data" && $action == "roles"))) {
                //Checks if token is on the header
                if($token == null)
                    //No token found
                    throw new NoTokenException("Token can't be omitted here");
                else {
                    getTokenExpire();   //We aren't interested in the return value
                    $user = getMyInfo();  //Get the user infos (used in many points)
                }
            }


            //Checks if the module is present
            if(!file_exists(__DIR__ . "/modules/$module/$action.php"))
                throw new NotImplementedException("Module $module/$action not implemented");

            //Initializing essentials variables for actions
            //$init = function (array $data) { return []; };
            $init = null;
            $exec = function (array $data, array $data_init) : array {
                return [
                    "response_data" => [],
                    "message" => "You are not supposed to see this",
                    "status_code" => 500
                ];
            };

            //Bringing the action which we wanted
            require_once __DIR__ . "/modules/$module/$action.php";

            //Execute the init function if present
            if(!is_null($init))
                $data_init = $init($request_data);
            else
                $data_init = [];

            //Get the response you need
            $response = $exec($request_data, $data_init);

            //Write the new token expire
            increaseTokenExpire();

        } catch (ExceptionRequest $ex) {    //ExceptionRequest are managed exceptions
            //Simple error
            $response = $ex->getErrorResponse();
        } catch (Exception $exception) {    //Unmanaged exceptions - print the message if in debug mode
            //Fatal error
            $response = [
                'response_data' => [],
                'status_code' => 500,
                'message' => "Internal Server Error"
            ];

            //DEBUG ENVIRONMENT ONLY
            if($printDebug->isDebug()){
                $response['dev_message'] = [
                    'message' => $exception->getMessage(),
                    'stack_trace' => $exception->getTrace(),
                ];
            }
        }

        //Get the warnings on a response
        if(count($warnings) > 0)
            $response['debug']['warnings'] = $warnings;

    } else {    //if (!$maintenance_state)
        $response = [
            "status_code" => 503,
            "message" => "Server in manutenzione",
        ];
    }

    //End the request with HTTP Code and JSON-ify the response
    http_response_code($response['status_code']);
    echo json_encode($response);
}

//Terminate the server for all the methods
ob_end_flush();
exit;