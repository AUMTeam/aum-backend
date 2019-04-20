<?php

abstract class AbstractMail {
    //Name of destinatary
    private $from;
    //Name of sender
    private $to;
    private $commit_id;

    public function __construct(string $from, string $to, $commit_id) {
        $this->from = $from;
        $this->to = $to;
        if ($commit_id != null)
            $this->commit_id = $commit_id;
    }
    
    public abstract function getSubject() : string;

    public abstract function getTitle() : string;

    public abstract function getContent() : string;

    public function getMsg() : string {
        return "
        <html>
        <head>
            <title>". getSubject() ."</title>
        </head>
        <body>
            <h2>". getTitle() ."</h2>
            " . getContent() . "
            <p>Maggiori informazioni <a href='$gui_url'>sul sito di AUM</a></p>
        </body>
        </html>";
    }
}