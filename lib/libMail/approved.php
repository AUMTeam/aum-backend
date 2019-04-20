<?php

class ApprovedMail extends AbstractMail {
    private $commitTitle;

    public function __construct(string $from, string $to, string $commit_id) {
        parent::__construct();
        $this->commitTitle = $db->query("SELECT description FROM commits WHERE commit_id=$commit_id")[0]['description'];
    }

    public function getSubject() : string {
        return "AUM - Commit Approvato da " . $to;
    }

    public function getTitle() : string {
        return "Un tuo commit è stato approvato!";
    }
    
    public function getContent() : string {
        return "
            <h4>Contenuto:</h4>
            <p>Titolo: <i>$commitTitle</i><br>
               Approvato da: <i>$to</i></p>";
    }
}