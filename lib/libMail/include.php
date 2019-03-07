<?php


function send(DatabaseWrapper $db, $from_user_token, $to_user_id) {
    $from = getUserData($db, $from_user_id);
    $to = $db->query("SELECT user_id, name, area_id, email FROM users WHERE user_id = {$to_user_id}");

    $subject = "Test email";

    $message = "
    <html>
    <head>
    <title>Test email</title>
    </head>
    <body>
    <p>Email inviata da ${from['name']} - ${from['email']} a ${to['name']} - ${to['email']}</p>
    </body>
    </html>
    ";

    $headers = "MIME-Version: 1.0" . "\r\n";
    $headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
    $headers .= "From: <${from['email']}>" . "\r\n";

    mail("aum.coopcisf@gmail.com", $subject, $message, $headers);
}