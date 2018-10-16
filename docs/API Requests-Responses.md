# Request/Response pattern

## Errori globali

Gli errori globali possono apparire in ogni azione (salvo alcune per svariate eccezioni).

#### Risposte

* Token assente.
```json
{
    "response_data":{
        "error_code":100
    },
    "status_code":401
}
```

* Token invalido. L'utente deve rifare l'accesso.
```json
{
    "response_data":{
        "error_code":102
    },
    "status_code":401
}
```

* Azione richiesta non implementata. Controllare che si stia cercando di accedere ad un'azione implementata.
```json
{
    "response_data":{
        "error_code":103
    },
    "status_code":404
}
```

* Utente bloccato. L'utente è stato bloccato dall'amministratore. Di conseguenza, non ha più accesso alla piattaforma (temporaneo/permanente). L'utente deve contattare l'amministratore. (UNUSED?)
```json
{
    "response_data":{
        "error_code":104
    },
    "status_code":423
}
```

## auth/login
### Accedere utilizzando username e password. Il token in questa richiesta non è obbligatorio.

#### Richiesta
```json
{
    "module":"auth",
    "access":"login",
    "request_data":{
        "username":"<username>",
        "hash_pass":"<hash della password>"
    }
}
```

#### Risposte

* Login eseguito con successo. Viene fornito un nuovo token dal server che verrà usato per la sessione.
```json
{
    "response_data":{
        "success":true,
        "token":"<random hashed bytes>",
        "user_id":1
    },
    "status_code":200
}
```

* Login fallito. Credenziali errate.
```json
{
    "response_data":{
        "error_code":1000
    },
    "message":"Credenziali errate",
    "status_code":401
}
```

* Login fallito. Non sono state fornite le credenziali in modo corretto.
```json
{
    "response_data":{
        "error_code":1001
    },
    "message":"Richiesta invalida",
    "status_code":400
}
```

* Login fallito. L'utente è stato bloccato dall'amministratore. (UNUSED?)
```json
{
    "response_data":{
        "error_code":1003
    },
    "message":"Utente bloccato da amministratore",
    "status_code":423
}
```

## auth/validateToken

Verifica che il token sia (ancora) valido. Se così non fosse, allora richiedere di fare l'accesso. Il token deve essere presente nell'header.

#### Richiesta
```json
{
    "module":"auth",
    "access":"validateToken",
    "request_data":{}
}
```

#### Risposte

* Token valido. L'utente può proseguire con la sessione.
```json
{
    "response_data":{},
    "status_code":200
}
```

* Token invalido. L'utente deve rifare l'accesso.
```json
{
    "response_data":{
        "error_code":1002
    },
    "message":"Credenziali errate",
    "status_code":401
}
```

## user/info

*NOTA: La risposta è prototipata. Azione soggetta a cambiamenti.*

Ottenere i dati di un'utente. La risposta sarà più completa per quanto riguarda l'utente appartenente al token inviato.

#### Richiesta
```json
{
    "module":"user",
    "access":"info",
    "request_data":{
        "user_id":1
    }
}
```

#### Risposte

* Utente trovato. (Utente proprietario del token)
```json
{
    "response_data":{
        "user_data":{
            "user_id":1,
            "name":"Mario",
            "surname":"Mario",
            "url_propic":"https://<url>",
            "creation_date":"10-10-2018 15:14:59",
            "access_level":"developer",
            "last_access":"10-10-2018 15:15:00"
        }
    },
    "status_code":200
}
```

* Utente trovato.
```json
{
    "response_data":{
        "user_data":{
            "user_id":2,
            "name":"Luigi",
            "surname":"Mario",
            "url_propic":"https://<url>",
            "last_access":"10-10-2018 15:15:00"
        }
    },
    "status_code":200
}
```

* Utente non trovato
```json
{
    "response_data":{
        "error_code":2000
    },
    "status_code":404
}
```