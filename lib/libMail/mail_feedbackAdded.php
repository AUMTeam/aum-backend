<?php

/**
 * Mail used to communicate that a client has installed an update
 */
class FeedbackAddedMail extends AbstractMail {
    private $sender;
    private $author;
    private $approver;
    private $installStatus;
    private $installFeedback;

    public function __construct(string $from, string $to, string $typeCommit, string $idType, int $id) {
        parent::__construct($from, $to, $typeCommit, $idType, $id);
        global $db;

        //Get infos from the send request
        $data = $db->preparedQuery("SELECT author_user_id, sender_user_id, approver_user_id, install_status, comment
            FROM requests, requests_clients WHERE requests.request_id=? AND requests.request_id=requests_clients.request_id", [$id])[0];

        //Get the sender (revision office member)
        $this->sender = $db->preparedQuery("SELECT name FROM users WHERE user_id=?", [$data['sender_user_id']])[0]['name'];
        //Get the original author (the programmer)
        $this->author = $db->preparedQuery("SELECT name FROM users WHERE user_id=?", [$data['author_user_id']])[0]['name'];
        //Get the approver
        $this->approver = $db->preparedQuery("SELECT name FROM users WHERE user_id=?", [$data['approver_user_id']])[0]['name'];

        $this->installFeedback = (empty($data['comment'])) ? "-" : $data['comment'];
        $this->installStatus = ($data['install_status'] == 1) ? "Riuscita" : "Non Riuscita";
    }

    public function getSubject() : string {
        return "AUM - Patch installata dal cliente " . $this->from;
    }

    public function getTitle() : string {
        return "$this->from ha appena installato un aggiornamento ";
    }
    
    public function getContent() : string {
        return "
            <table>
            <tr><td><b>Titolo: </b></td><td>$this->title</td></tr>
            <tr><td><b>Descrizione: </b></td><td>$this->desc</td></tr>
            <tr></tr>
            <tr><td><b>Autore: </b></td><td>$this->author</td></tr>
            <tr><td><b>Approvata da: </b></td><td>$this->approver</td></tr>
            <tr><td><b>Inviata da: </b></td><td>$this->sender</td></tr>
            <tr></tr>
            <tr><td><b>Stato installazione: </b></td><td>$this->installStatus</td></tr>
            <tr><td><b>Feedback del cliente: </b></td><td>$this->installFeedback</td></tr>
            </table>";
    }
}