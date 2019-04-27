<?php

/**
 * Mail used to communicate that there's a new commit/request to the tech area members
 */
class NewCommitMail extends AbstractMail {
    private $title;
    private $desc;
    private $typeCommit;

    public function __construct(string $from, string $to, string $type, string $id, int $commit_id) {
        parent::__construct($from, $to, $commit_id);
        global $db;
        $out = $db->preparedQuery("SELECT title, description FROM $type WHERE $id=?", [$commit_id])[0];
        $this->title = $out['title'];
        $this->desc = $out['description'];
        $this->typeCommit = $type;
    }

    public function getSubject() : string {
        if ($this->typeCommit==TYPE_COMMIT)
            return "AUM - Nuovo commit pubblicato da " . $this->to;
        else
            return "AUM - Nuova richiesta di invio pubblicata da " . $this->to;
    }

    public function getTitle() : string {
        if ($this->typeCommit==TYPE_COMMIT)
            return "$this->from ha pubblicato un nuovo commit";
        else
            return "$this->from ha pubblicato una nuova richiesta di invio";
    }
    
    public function getContent() : string {
        return "
            <h4>Contenuto:</h4>
            <table>
            <tr><td><b>Titolo: </b></td><td>$this->title</td></tr>
            <tr><td><b>Descrizione: </b></td><td>$this->desc</td></tr>
            <tr><td><b>Autore: </b></td><td>$this->from</td></tr>
            </table>";
    }
}