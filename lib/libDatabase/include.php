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
                if ($db_type == "sqlite")
                    $this->handler = new PDO("{$db_type}:{$config['db_name']}", $options);
                
                else
                    $this->handler = new PDO("{$db_type}:host={$config['server']};dbname={$config['db_name']}", $config['username'], $config['password'], $options);

        } catch (PDOException $e) {
            throw new InvalidRequestException("Error connecting to the database using PDO: " . $e->getMessage());
        }
    }

    //Execute a query. WARNING: this is SQL-Injection unsafe
    public function query(string $query) : array {
        $out = [];

        try {
            //We need to get results only from SELECT queries
            if (strpos($query, "SELECT") !== false) {
                $stmt = $this->handler->query($query);
                $out = $stmt->fetchAll(PDO::FETCH_ASSOC);
            }
            else
                $this->handler->exec($query);
        } catch (PDOException $e) {
            throw new Exception("Error in executing query '$query' : ". $e->getMessage());
        }

        return $out;
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
            throw new DBException("Error in executing query: '$query' -- Message: " . $ex->getMessage());
        }
    }

    public function __destruct() {
        $this->handler = null;
    }
}