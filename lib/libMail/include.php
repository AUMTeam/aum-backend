<?php

define("MAIL_APPROVED", 1);
define("MAIL_NEW_ENTRY", 2);
define("MAIL_NEW_PATCH", 3);

//Include all the mail files
$dir = scandir(__DIR__);
foreach ($dir as $file) {
    switch ($file){
        case ".":
        case "..":
        case "include.php":
            break;
        default:
            if (strpos($file, ".php"))
                require_once __DIR__ . "/$file";
            break;
    }
}

/**
 * Send a mail from the current user to '$to_user_id' user,
 *  with a specific '$type'
 */
function sendMail(int $to_user_id, string $mailType, $id = null, string $typeCommit = TYPE_REQUEST) : void {
    global $db;
    global $user;

    $idType;
    switch($typeCommit) {
        case TYPE_COMMIT:
            $idType = TYPE_COMMIT_ID;
            break;
        case TYPE_REQUEST:
            $idType = TYPE_REQUEST_ID;
            break;
    }

    //Get the user infos
    $from = $user;
    $to = getUserInfo($to_user_id);
    
    //Istantiate the mail class based on the $mailType parameter
    $mail;
    switch($mailType) {
        case MAIL_APPROVED:
            $mail = new ApprovedMail($from['name'], $to['name'], $typeCommit, $idType, $id);
            break;
        case MAIL_NEW_ENTRY:
            $mail = new NewCommitMail($from['name'], $to['name'], $typeCommit, $idType, $id);
            break;
        case MAIL_NEW_PATCH:
            $mail = new NewPatchMail($from['name'], $to['name']);
            break;
        default:
            throw new InvalidRequestException("Invalid mail type!");
            break;
    }

    //Build the mail with the given fields
    $subject = $mail->getSubject();
    $message = $mail->getMsg();

    $headers = "MIME-Version: 1.0" . "\r\n";
    $headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
    $headers .= "From: <${from['email']}>" . "\r\n";

    //Send the mail - TODO: change the destination address
    mail("aum.coopcisf@gmail.com", $subject, $message, $headers);
}