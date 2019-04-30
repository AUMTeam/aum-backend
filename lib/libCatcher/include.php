<?php

/**
 * Functions used to catch errors/warnings/notices and print then in 
 *  JSON response (debug=true) or in log files (debug=false)
 * @param $errno Level of the error
 * @param $errstr Error message
 * @param $errfile Filename where the error was raised at
 * @param $errline Line in the file
 */

//Fatal error handling
function envi_error_catcher(int $errno, string $errstr, string $errfile, int $errline) : bool {
    global $printDebug;
    global $log_path;

    $out = [
        "message" => "A Fatal error was triggered from server."
    ];

    //Detailed message error on response in case of debug mode
    if($printDebug->isDebug()) {
        $out['dev_message'] = [
            "error_number" => $errno,
            "error_string" => $errstr,
            "error_line" => $errline,
            "error_file" => $errfile,
            "error_message" => "Custom error: [$errno] $errstr. Error on line $errline in $errfile"
        ];
        http_response_code(500);
        die(json_encode($out));
    } else {
        file_put_contents($log_path."/Error_" . date("d-m-y") . ".log", time() . " - Error: [$errno] $errstr. Error on line $errline in $errfile");
        
        $fp=fopen("php://output","w");
        fwrite($fp,json_encode($out));
        http_response_code(500);
        die(fclose($fp));
    }

    return true;
}

function envi_shutdown_catcher() : void {
    global $printDebug;

    if($printDebug->isDebug()) {
        $out = [
            'message' => "Shutdown function called"
        ];
    }
}

//Warning handling
function envi_warning_catcher(int $errno, string $errstr, string $errfile, int $errline) : bool {
    global $printDebug;
    global $warnings;
    global $log_path;

    if($printDebug->isDebug()) {
        $warnings[] = [
            "dev_message" => "Warning triggered: [$errno] $errstr. Error on line $errline in $errfile"
        ];
    } else {
        file_put_contents($log_path."/Warning_".date("d-m-y").".log", time()." - Warning triggered: [$errno] $errstr. Error on line $errline in $errfile");
    }

    return true;
}

//Notices handling
function envi_notice_catcher(int $errno, string $errstr, string $errfile, int $errline) : bool {
    global $printDebug;
    global $warnings;
    global $log_path;

    if($printDebug->isDebug()) {
        $warnings[] = [
            "dev_message" => "Notice triggered: [$errno] $errstr. Error on line $errline in $errfile"
        ];
    } else {
        file_put_contents($log_path."/Notice_".date("d-m-y").".log", time()." - Notice triggered: [$errno] $errstr. Error on line $errline in $errfile", FILE_APPEND);
    }
    return true;
}