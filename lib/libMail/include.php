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
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

/**
 * Send a mail from the current user to '$to_user_id' user,
 *  with a specific '$type'
 */
function sendMail(int $to_user_id, string $mailType, $id = null, string $typeCommit = TYPE_REQUEST) : void {
    global $mail_config;

    if ($mail_config['enabled']) {
        global $db;
        global $user;
        global $printDebug;

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

        //Try to create a parallel process
        $pid;
        if (!function_exists("pcntl_fork") || ($pid = pcntl_fork()) == -1) { //Cannot fork, send the mail on the main process
            $printDebug->printDebugJSON(array("mail" => "Warning: Mail is sent on the main process. Expect slowdowns!"));
            sendPHPMailer($from, $to, $subject, $message);
        }
        else if ($pid != 0) //Successfully forked, we are the children
            sendPHPMailer($from, $to, $subject, $message);
    }
}

//Send a mail using PHPMailer
function sendPHPMailer(array $from, array $to, string $subject, string $message) : void {
    global $mail_config;

    $mail = new PHPMailer(TRUE);
    try {
        //Server parameters configuration
        $mail->IsSMTP();
        $mail->Host = $mail_config['server'];
        $mail->SMTPSecure = $mail_config['protocol'];
        $mail->Port = $mail_config['port'];
        $mail->SMTPAuth = TRUE;
        $mail->Username = $mail_config['username'];
        $mail->Password = $mail_config['password'];

        //Mail parameters configuration
        $mail->setFrom($from['email'], $from['name']);
        $mail->addAddress("aum.coopcisf@gmail.com", $to['name']);   //TODO: change mail address
        $mail->isHTML(TRUE);
        $mail->Subject = $subject;
        $mail->Body = $message;
        $mail->AltBody = "Questa mail richiede l'utilizzo di un client con supporto ad HTML";
    
        //Finally, send the mail
        $mail->send();
    } catch (Exception $e) {
        throw new MailException("Error while sending mail: ". $e->errorMessage());
    }
}
