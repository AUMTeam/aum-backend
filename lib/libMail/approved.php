<?php

function getSubject() : string {
    return "Valutazione Avvenuta";
}

function getMsg() : string {
    return "
    <html>
        <head>
            <title>". getSubject() ."</title>
        </head>
        <body>
            <h2>Nuovo commit è stato valutato</h2>
            <p id='info'></p>
        </body>
    </html>";
}