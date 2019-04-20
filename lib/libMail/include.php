<?php

define("TYPE_APPROVED", 1);
define("TYPE_NEW_COMMIT", 2);

foreach (scandir(__DIR__) as $file) {
    switch ($file){
        case ".":
        case "..":
        case "include.php":
            break;
        default:
            if (strpos($file, ".php"))
                require_once __DIR__ . "/" . $file;
            break;
    }
}

function send($from_user_token, $to_user_id, $commit_id, $type) {
    global $db;
    $from = getUserData($db, $from_user_token)[0]['user_real_name'];
    $to = getUserData($db, null, array(user_id=>$to_user_id))[0]['user_real_name'];
    $mail;

    switch($type) {
        case TYPE_APPROVED:
            $mail = new ApprovedMail($from, $to, $commit_id);
        case TYPE_NEW_COMMIT:
            $mail = new NewCommitMail($from, $to, $commit_id);
        default:
            throw new Exception("ERRORE: Tipo non riconosciuto!");
    }

    $subject = getSubject();
    $message = getMsg();

    $headers = "MIME-Version: 1.0" . "\r\n";
    $headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
    $headers .= "From: <${from['email']}>" . "\r\n";

    mail("aum.coopcisf@gmail.com", $subject, $message, $headers);
}