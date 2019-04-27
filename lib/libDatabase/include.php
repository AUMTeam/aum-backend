<?php

/**
 * Class used to communicate to the DataBase
 */
class DatabaseWrapper {
    //PDO object
    private $handler;

    //Istantiate the PDO object using values from 'config.php' file
    public function __construct(string $db_type, array $config) {
        $options = [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_EMULATE_PREPARES => false];

        try {
            if (array_key_exists("db_name", $config)) {
                if ($db_type == "sqlite") {
                    $this->handler = new PDO("{$db_type}:{$config['db_name']}", $options);
                } else if (array_key_exists("server", $config) && array_key_exists("username", $config) && array_key_exists("password", $config)) {
                    $this->handler = new PDO("{$db_type}:host={$config['server']};dbname={$config['db_name']}", $config['username'], $config['password'], $options);
                }
            }
        } catch (PDOException $e) {
            throw new InvalidRequestException("Error connecting to the database using PDO: " . $e->getMessage());
        }
    }

    //Execute a query. WARNING: this is SQL-Injection insafe
    public function query(string $query) : array {
        try {
            if (strpos($query, "SELECT") !== false) {
                $result = $this->handler->query($query);
                $out = [];

                while($row = $result->fetch(PDO::FETCH_ASSOC))
                    $out[] = $row;

                return $out;
            }
            else
                $this->handler->exec($query);
        } catch (PDOException $e) {
            throw new Exception("Error in executing query '$query' : ". $e->getMessage());
        }
    }

    //Executes a parametrized query, SQL Injection Safe
    public function preparedQuery(string $query, array $params = null) : array {
        try {
            $out = [];
            $stmt = $this->handler->prepare($query);

            if ($params != null) {
                //Bind the params with their respective data types
                for($i=0;$i<count($params); $i++) {
                    $elem = $params[$i];
                    $type = PDO::PARAM_STR;

                    if (is_string($elem) || is_float($elem))    //PARAM_FLOAT is not supported
                        $type = PDO::PARAM_STR;
                    else if (is_int($elem))
                        $type = PDO::PARAM_INT;
                    else if (is_bool($elem))
                        $type = PDO::PARAM_BOOL;

                    $stmt->bindParam($i+1, $elem, $type);
                }
            } else
                $params = [];

            //Execute the query
            $stmt->execute($params);

            //We need to get results only from SELECT queries
            if (strpos($query, "SELECT") !== false)
                $out = $stmt->fetchAll(PDO::FETCH_ASSOC);

            return $out;
        
        } catch(PDOException $ex) {
            //Print the exception in the JSON response
            throw new DBException("Error in executing query: " + $ex->getMessage());
        }
    }

    public function __destruct() {
        $this->handler = null;
    }
}