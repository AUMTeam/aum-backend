<?php

define("TYPE_APPROVED", 1);
define("TYPE_NEW_COMMIT", 2);

function send(DatabaseWrapper $db, $from_user_token, $to_user_id, $type) {
    $from = getUserData($db, $from_user_token);
    $to = getUserData($db, null, array(user_id=>$to_user_id));

    switch($type) {
        case TYPE_APPROVED:
            require_once "approved.php";
        case TYPE_NEW_COMMTI:
            require_once "newCommit.php";
        default:
            throw new Exception("ERRORE: Tipo non riconosciuto!");
    }

    $subject = getSubject();

    $message = getMsg();
    $pre = substr($message, strpos($message, "'fo'>") + 4);
    $post = substr($message, strpos($message, "<p>"));

    $message = $pre . " Info di Test " . $post;

    $headers = "MIME-Version: 1.0" . "\r\n";
    $headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
    $headers .= "From: <${from['email']}>" . "\r\n";

    mail("aum.coopcisf@gmail.com", $subject, $message, $headers);
}