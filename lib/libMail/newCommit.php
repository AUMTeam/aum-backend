<?php


function getSubject() : string {
    return "Nuovo Commit";
}

function getMsg() : string {
    return "
    <html>
    <head>
        <title>". getSubject() ."</title>
    </head>
    <body>
        <h2>Un nuovo commit è stato pubblicato!</h2>
        <p id='info'></p>
    </body>
    </html>";
}