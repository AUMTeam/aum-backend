# Request/Response pattern

In tutte le richieste, salvo quella di login, è necessario specificare il token nell'header **X-Auth-Header**.

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
### Accedere utilizzando username e password. Il token in questa richiesta non è richiesto.

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
        "token":"<random hashed SHA1 bytes>",
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

Verifica che il token sia (ancora) valido. Se così non fosse, allora richiedere di fare l'accesso. Il token deve essere presente nell'header "X-Auth-Header".

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

## commit/approve

Va specificato l'ID del commit ed il flag di approvazione (1: Approvato / -1: Non Approvato)

#### Richiesta
```json
{
    "module":"commit",
    "access":"approve",
    "request_data":{
        "id":1,
        "approve_flag":1
    }
}
```

#### Risposte

* Commit approvato correttamente
```json
{
    "response_data":{},
    "status_code":200
}
```

* L'utente non è autorizzato ad eseguire questa azione
```json
{
    "response_data":{
        "error_code":103
    },
    "message":"The current user is not authorized to perform this action!",
    "status_code":401
}
```

* L'ID del commit non è valido
```json
{
    "response_data":{
        "error_code":3007
    },
    "message":"Commit_id doesn't refer to a valid commit!",
    "status_code":400
}
```

* Il commit è già stato approvato
```json
{
    "response_data":{
        "error_code":3007
    },
    "message":"Commit already approved!",
    "status_code":400
}
```

## commit/list

Restituisce la lista dei commit presenti nel database sotto forma di pagine. E' necessario specificare *limit* (numero di elementi per pagina) e *page* (numero di pagina).

Facoltativamente è possibile specificare **l'ordinamento** ascendente o discendente (order=ASC/DESC) secondo secondo i parametri:  id (id dei commit), description, timestamp (data creazione), update_timestamp (data di ultima modifica), author, reviewer, approval_status, component, branch. Se *sort* non è specificato, la lista viene ordinata in maniera discendente secondo l'id dei commit.

E' poi possibile impostare (facoltativamente) un **filtro** di ricerca. Si specifica *attribute* (parametro sul quale ricercare; l'elenco di parametri ammessi è lo stesso di quelli di sorting) e valueMatches (query da ricercare) oppure valueDifferentFrom (il valore deve essere diverso da).

#### Richiesta
```json
{
    "module":"commit",
    "access":"list",
    "request_data":{
        "limit":5,
        "page":6,
        "sort":{
            "parameter":"id",
            "order":"DESC"
        },
        "filter":{
            "attribute":"",
            "valueMatches":"",
            "valueDifferentFrom":"",
        }
    }
}
```

#### Risposte

*count* contiene il conteggio degli elementi nella risposta. *count_total* contiene il numero totale di elementi presenti nel database.

```json
{
    "response_data": {
        "count": 5,
        "count_total": 35,
        "list": [
            {
                "approval_status": "0",
                "author": {
                    "name": "Test of Client user",
                    "user_id": "3",
                    "username": "client.test"
                },
                "description": "Self-enabling systematic analyzer",
                "id": "27",
                "timestamp": 1520488563
            },
            [...]
        ],
        "page": 6,
        "page_total": 6
    },
    "status_code": 200
}
```

#commit/update

Utilizzato per richiedere se vi sono nuovi commit data una certa data.
E' necessario specificare latest_update_timestamp, il timestamp dall'ultimo aggiornamento ricevuto.

#### Richiesta
```json
{
    "module":"commit",
    "access":"update",
    "request_data":{
        "latest_update_timestamp":"..."
    }
}
```

#### Risposte

* Aggiornamenti trovati

```json
{
    "response_data": {
        "updates_found":true
    },
    "status_code": 200
}
```

* Aggiornamenti non trovati

```json
{
    "response_data": {
        "updates_found":false
    },
    "status_code": 200
}
```

#commit/add

Utilizzato per aggiungere un nuovo commit al database. Tutti i campi sono obbligatori.

#### Richiesta
```json
{
    "module":"commit",
    "access":"add",
    "request_data":{
        "description":"description string",
        "component":4,
        "branch":1
    }
}
```

#### Risposte

* Inserimento andato a buon fine

```json
{
    "response_data": {},
    "status_code": 200
}
```

* Almeno un campo è mancante
```json
{
    "response_data":{
        "error_code":1001
    },
    "message":"Richiesta invalida",
    "status_code":400
}
```

#request/add

Utilizzato per aggiungere una nuova richiesta di invio al database.
*install_type* indica il tipo di installazione: 0 (A Caldo) / 1 (A Freddo); *dest_clients* gli ID degli utenti destinatari e *commits* l'elenco dei commit inclusi nella richiesta di invio.

Tutti i campi tranne *commits* sono obbligatori.

#### Richiesta
```json
{
    "module":"request",
    "access":"add",
    "request_data":{
        "description":"description string",
        "install_type":1,
        "install_link":"ftp://site.com",
        "dest_clients":[1,2,3],
        "commits":[34,56,23],
        "component":4,
        "branch":1
    }
}
```

#### Risposte

* Inserimento andato a buon fine

```json
{
    "response_data": {},
    "status_code": 200
}
```

* Almeno un campo è mancante
```json
{
    "response_data":{
        "error_code":1001
    },
    "message":"Richiesta invalida",
    "status_code":400
}

## request/list

Il funzionamento è uguale a quello di *commit/list*, eccezione fatta per il campo obbligatorio 'role_id' nella richiesta. Se tale campo è impostato a '4' (cliente), l'endpoint ritornerà la lista delle richieste di invio a suo carico. Per qualsiasi altro valore, l'endpoint ritornerà la lista delle richieste in modo simile a quello dei commit.

#### Richiesta
```json
{
    "module":"request",
    "access":"list",
    "role_id":4,
    "request_data":{
        "limit":5,
        "page":6,
        "sort":{
            "parameter":"id",
            "order":"DESC"
        },
        "filter":{
            "attribute":"",
            "valueMatches":"",
            "valueDifferentFrom":"",
        }
    }
}
```

#### Risposte

##### Risposta con role_id=4
**Soggetto a variazioni**
```json
{
  "response_data": {
    "count": 1,
    "count_total": 1,
    "list": [
      {
        "id": "4",
        "description": "Assimilated intangible functionalities",
        "timestamp": "2019-03-14 16:02:36",
        "install_type": "0",
        "install_link": "https://example.com",
        "install_date": "2019-03-18 13:52:25",
        "install_comment": null
      }
    ],
    "page": 0,
    "page_total": 0
  },
  "status_code": 200
}
```

##### Risposta con role_id!=4
```json
{
    "response_data": {
        "count": 5,
        "count_total": 35,
        "list": [
            {
                "approval_status": "0",
                "author": {
                    "name": "Test of Client user",
                    "user_id": "3",
                    "username": "client.test"
                },
                "description": "Self-enabling systematic analyzer",
                "id": "27",
                "timestamp": 1520488563
            },
            [...]
        ],
        "page": 6,
        "page_total": 6
    },
    "status_code": 200
}
```