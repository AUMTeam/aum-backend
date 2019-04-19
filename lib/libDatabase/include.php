<?php

class DatabaseWrapper {
    private $handler;

    public function __construct(string $db_type, array $config) {
        $options = [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION];

        try {
            if (array_key_exists("db_name", $config)) {
                if ($db_type == "sqlite") {
                    $this->handler = new PDO("{$db_type}:{$config['db_name']}", $options);
                } else if (array_key_exists("server", $config) && array_key_exists("username", $config) && array_key_exists("password", $config)) {
                    $this->handler = new PDO("{$db_type}:host={$config['server']};dbname={$config['db_name']}", $config['username'], $config['password'], $options);
                }
            }
        } catch (PDOException $e) {
            throw new Exception("Error connecting to the database using PDO: " . $e->getMessage());
        }
    }

    public function query(string $query) : array {
        try {
            //$query = $this->handler->quote($query);
            if (strpos("SELECT", $query) !== true) {
                $result = $this->handler->query($query);
                $out = [];

                while($row = $result->fetch())
                    $out[] = $row;

                return $out;
            }
            else
                $this->handler->exec($query);
        } catch (PDOException $e) {
            throw new Exception("Error in executing query '$query' : ". $e->getMessage());
        }
    }

    //Executes a parametrized query (Can throw PDOException)
    public function preparedQuery(string $query, array $params) : array {
        $out = [];
        $stmt = $this->handler->prepare($query);

        for($i=0;$i<count($params); $i++) {
            $elem = $params[$i];
            $type;

            if (is_string($elem) || is_float($elem))    //PARAM_FLOAT is not supported
                $type = PDO::PARAM_STR;
            else if (is_int($elem))
                $type = PDO::PARAM_INT;
            else if (is_bool($elem))
                $type = PDO::PARAM_BOOL;

            $stmt->bindParam($i+1, $elem, $type);
        }

        //Execute the query
        $stmt->execute($params);

        if (strpos($query, "SELECT") !== false)
            $out = $stmt->fetchAll(PDO::FETCH_ASSOC);

        return $out;
    }

    public function __destruct() {
        $this->handler = null;
    }
}