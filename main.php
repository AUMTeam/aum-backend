<?php
$warnings = [];

if(!file_exists(__DIR__ . "/log/"))
    mkdir(__DIR__ . "/log/");

date_default_timezone_set('Europe/Rome');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, X-Auth-Header, Accept-Encoding");
header("Content-Encoding: gzip");

include_once __DIR__ . "/lib/libCatcher/include.php";

register_shutdown_function("envi_shutdown_catcher");
set_error_handler("envi_error_catcher", E_STRICT);    //Catch on PHP Fatal error
set_error_handler("envi_warning_catcher", E_WARNING); //Catch on PHP Warning
set_error_handler("envi_notice_catcher", E_NOTICE);   //Catch on PHP Notice

//Import important libraries
include_once __DIR__ . "/lib/libDatabase/include.php";
include_once __DIR__ . "/lib/libExceptionRequest/include.php";
include_once __DIR__ . "/lib/libPrintDebug/PrintDebug.php";

//small libs for actions
include_once __DIR__ . "/lib/libList/include.php";
include_once __DIR__ . "/lib/libUserInfo/include.php";

//Import configuration data
include_once "./config.php";

//Initializing debug mode
$printDebug = new PrintDebug($debug_mode);

//GZIP compression
if(!ob_start("ob_gzhandler")) ob_start();

//Reporting server version
header("Server-Version: $version");

if (!($_SERVER['REQUEST_METHOD'] === 'POST')) {
    if($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        //Necessary to comunicate the allowed methods through the OPTIONS method
        http_response_code(200);
        header("Access-Control-Allow-Methods: POST, OPTIONS");
        $printDebug->printDebug("OPTIONS MESSAGE SENT\n");
        ob_end_flush();
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
            <img src="/img/not_post_req.jpg">
        </body>
    </html>
    ');
    ob_end_flush();
    exit;
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

        try{
            //Set up database connection
            if($db_usage == "SQLITE3")
                //SQLite3 usage
                $db = new SQLite3DatabaseWrapper($sqlite3_name);
            else if ($db_usage == "MYSQL")
                //MySQL usage
                $db = new MySQLDatabaseWrapper($config);
            else
                //Invalid string
                throw new Exception("Invalid DB setup");

            //Decodes JSON if present
            $request = json_decode(file_get_contents("php://input"), true);

            //Checks if not valid JSON
            if($request == null or $request == false)
                throw new InvalidRequestException("Request is not a JSON");

            //BETA: Module/Action on URL
            $url_data = explode("/", $_SERVER['REQUEST_URI']);
            if(count($url_data) >= 4)
            {
                $main_posi = 0;

                while($url_data[$main_posi] !== "main.php")
                    if($url_data[$main_posi] !== "main.php")
                        $main_posi++;
                    else
                        break;

                $module = $url_data[$main_posi+1];
                $action = $url_data[$main_posi+2];
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
                //Preparing an empty object as default request
                $request['request_data'] = [];
            }

            //Saving data on easy variables
            $request_data = $request['request_data'];

            //Getting all headers from request
            $headers = getallheaders();

            //Ignoring token check only when special entrypoints are called
            if(($module == "auth" and $action == "login") or ($module == "data") ){
                $token = null;
                //The only action which token is not needed
                goto bypass_header_check;
            }

            //Checks if token is on the header
            if(!isset($headers['X-Auth-Header']) && !isset($headers['x-auth-header']))
                //No token found
                throw new NoTokenException("Token can't be omitted here" . $printDebug->getDebugString(json_encode($headers)));
            else{

                //Saving the token on somewhere more easy to retreive later
                if(isset($headers['X-Auth-Header']))
                    $token = $headers['X-Auth-Header'];
                else
                    $token = $headers['x-auth-header'];

                //Checks if token is active or valid
                $result = $db->query("SELECT token_expire FROM users_tokens WHERE token = '{$token}'");
                if(is_bool($result) or count($result) == 0)
                    throw new InvalidTokenException("Token is not valid");

                if(time() > $result[0]['token_expire']){
                    $db->query("DELETE FROM users_tokens WHERE token = '{$headers['X-Auth-Header']}'");
                    throw new InvalidTokenException("Token is not valid anymore. Please remake login.");
                }
            }

            //Saving the token on somewhere more easy to retreive later
            $token = $headers['X-Auth-Header'];

            bypass_header_check:

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
            if(isset($token) || isset($response['response_data']['token'])){
                //Take the new generated token if you generated one
                if(isset($response['response_data']['token']))
                    $token = $response['response_data']['token'];

                //Write the new token expire
                if($printDebug->isDebug()) // DEBUG PURPOSE ONLY
                    $new_expire = time() + (60 * 30); //Valid for 30 minutes for debugging multiple timeout
                else
                    $new_expire = time() + ((60*60) * 4); //Token Valid for more 4hours from now.

                $db->query("UPDATE users_tokens SET token_expire = $new_expire WHERE token = '$token'");

                if($printDebug->isDebug()) $response['response_data']['debug']['expire'] = $new_expire;
            }

        }catch (ExceptionRequest $invalidRequestException){
            //Simple error
            $response = $invalidRequestException->getErrorResponse();
        }catch (Exception $exception){
            fatal_error:
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
    ob_end_flush();
    exit;
}