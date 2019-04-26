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

* Dati impostati in modo scorretto
```json
{
    "response_data":{
        "error_code":1001
    },
    "message":"Richiesta invalida",
    "status_code":400
}
```

## auth/login
Accede utilizzando username e password. Il token non è richiesto.

#### Richiesta
```json
{
    "module":"auth",
    "access":"login",
    "request_data":{
        "username":"<username>",
        "password":"<password>"
    }
}
```

#### Risposte

* Login eseguito con successo. Viene fornito un nuovo token dal server che verrà usato per la sessione.
```json
{
    "response_data":{
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
    "response_data":{
        "token_expire":123463345
    },
    "status_code":200
}
```

* Token invalido. L'utente deve rifare l'accesso.
```json
{
    "response_data":{
        "error_code":1002
    },
    "message":"Token non valido",
    "status_code":401
}
```

## commit/add

Utilizzato per aggiungere un nuovo commit al database. Tutti i campi sono obbligatori.

#### Richiesta
```json
{
    "module":"commit",
    "access":"add",
    "request_data":{
        "title":"title",
        "description":"description string",
        "components":"component description",
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
    "status_code":403
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

E' poi possibile impostare facoltativamente un **filtro** di ricerca. Si specifica *attribute* (parametro sul quale ricercare; l'elenco di parametri ammessi è lo stesso di quelli di sorting) e valueMatches (query da ricercare) oppure valueDifferentFrom (il valore deve essere diverso da).

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

*count* contiene il conteggio degli elementi nella risposta per la pagina corrente, mentre *count_total* contiene il numero totale di elementi per la query effettuata. Il conteggio per *page* e *page_total* parte da 0. *approval_status* è uguale a *0* se il commit deve essere ancora valutato, *1* se è stato approvato e *-1* se è stato respinto.

```json
{
    "response_data": {
        "count": 5,
        "count_total": 35,
        "list": [
            {
                "id": 67,
                "title": "Silverleaf Mountain Gum",
                "description": "Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.",
                "timestamp": 1537610451,
                "update_timestamp": 1531140258,
                "components": "Sed ante. Vivamus tortor. Duis mattis egestas metus.",
                "branch": 2,
                "approval_status": "1",
                "author": {
                    "user_id": 1,
                    "username": "admin",
                    "name": "Test Admin"
                },
                "approver": {
                    "user_id": 2,
                    "username": "dev.test",
                    "name": "Test Developer"
            }
            [...]
        ],
        "page": 6,
        "page_total": 6
    },
    "status_code": 200
}
```

## commit/update

Utilizzato per richiedere se vi sono nuovi commit data una certa data.
E' necessario specificare latest_update_timestamp, il timestamp dall'ultimo aggiornamento ricevuto.

#### Richiesta
```json
{
    "module":"commit",
    "access":"update",
    "request_data":{
        "latest_update_timestamp":1555745875
    }
}
```

#### Risposte

* Aggiornamenti trovati

```json
{
  "response_data": {
    "latest_update_timestamp": 1555745875,
    "new_count": 65,
    "updates_found": true
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

## data/areas
Restituisce l'elenco delle aree funzionali

#### Richiesta
```json
{
	"module":"data",
	"action":"areas"
}
```

#### Risposta
```json
{
  "response_data": [
    {
      "area_id": 1,
      "area_string": "Area 1"
    },
    [...]
  ],
  "status_code": 200
}
```

## data/branch
Restituisce l'elenco delle branch

#### Richiesta
```json
{
	"module":"data",
	"action":"branch"
}
```

#### Risposta
```json
{
  "response_data": [
    {
      "id": 1,
      "name": "Tres-Zap"
    },
    [...]
  ],
  "status_code": 200
}
```

## data/clients
Restituisce l'elenco dei clienti

#### Richiesta
```json
{
	"module":"data",
	"action":"clients"
}
```

#### Risposta
```json
{
  "response_data": [
    {
      "email": "client@aum.com",
      "role": [
        4
      ],
      "area": null,
      "user_id": 3,
      "name": "Test Client User"
    },
    [...]
  ],
  "status_code": 200
}
```

## data/installType
Restituisce i tipi di installazione

#### Richiesta
```json
{
	"module":"data",
	"action":"installType"
}
```

#### Risposta
```json
{
  "response_data": [
    {
      "id": 0,
      "desc": "A Caldo"
    },
    {
      "id": 1,
      "desc": "A Freddo"
    }
  ],
  "status_code": 200
}
```

## data/roles
Restituisce l'elenco dei ruoli in uso

#### Richiesta
```json
{
	"module":"data",
	"action":"roles"
}
```

#### Risposta
```json
{
  "response_data": [
    {
      "role_id": 1,
      "role_string": "Developer"
    },
    [...]
  ],
  "status_code": 200
}
```

## request/add

Utilizzato per aggiungere una nuova richiesta di invio al database.
*install_type* indica il tipo di installazione: 0 (A Caldo) / 1 (A Freddo); *dest_clients* gli ID degli utenti destinatari e *commits* l'elenco dei commit inclusi nella richiesta di invio.

Tutti i campi tranne *commits* sono obbligatori.

#### Richiesta
```json
{
    "module":"request",
    "access":"add",
    "request_data":{
        "title":"title string",
        "description":"description string",
        "install_type":1,
        "dest_clients":[1,2,3],
        "commits":[34,56,23],
        "components":"component description",
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

## request/approve

Vedasi commit/approve

#### Richiesta
```json
{
    "module":"request",
    "access":"approve",
    "request_data":{
        "id":1,
        "approve_flag":1
    }
}
```
## requests/install

Segnala l'avvenuta installazione di una patch. Eseguibile solo da utenti del gruppo client; il campo 'feedback' è facoltativo

#### Richiesta
```json

	"module":"requests",
	"action":"install",
	"request_data": {
		"id":4,
		"feedback":"Test Feedback"
	}
}
```

#### Risposta

* Inserimento andato a buon fine
```json
{
  "response_data": [],
  "status_code": 200
}
```

## request/list

Il funzionamento è uguale a quello di *commit/list*, eccezione fatta per il campo obbligatorio 'role' nella richiesta. Se tale campo è impostato a '4' (cliente), l'endpoint ritornerà la lista delle richieste di invio a suo carico. Per qualsiasi altro valore, l'endpoint ritornerà la lista delle richieste in modo simile a quello dei commit.

#### Richiesta

```json
{
    "module":"request",
    "access":"list",
    "role":4,
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

```json
{
  "response_data": {
    "count": 1,
    "count_total": 1,
    "list": [
      {
        "id": "4",
        "title":"title",
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
Uguale a *commit/list* con l'eccezione di *approval_status*: è uguale a *0* se la richiesta deve essere ancora valutata, *1* se è stata approvata e *-1* se è stata respinta e **2** se è stata inviata ai clienti.
```json
{
    "response_data": {
        "count": 5,
        "count_total": 35,
        "list": [
            {
                "id": 84,
                "title": "Mariposa Pussypaws",
                "description": "Morbi porttitor lorem id ligula.",
                "timestamp": 1539402365,
                "update_timestamp": 1555237944,
                "components": "Suspendisse potenti. In eleifend quam a odio.",
                "branch": 1,
                "approval_status": "-1",
                "author": {
                    "user_id": 2,
                    "username": "dev.test",
                    "name": "Test Developer"
                },
                "approver": {
                    "user_id": 2,
                    "username": "dev.test",
                    "name": "Test Developer"
                },
                "install_link": "http:\/\/geocities.jp\/blandit\/mi\/in\/porttitor\/pede\/justo.json",
                "install_type": "1"
            },
            [...]
        ],
        "page": 6,
        "page_total": 6
    },
    "status_code": 200
}
```

## requests/send

Invia una richiesta di invio ai clienti designati. Solo i membri dell'ufficio revisioni possono effettuare tale azione.

#### Richiesta

```json
{
	"module":"requests",
	"action":"send",
	"request_data": {
		"id":4
	}
}
```

#### Risposta

* Invio andato a buon fine 
```json
{
  "response_data": [],
  "status_code": 200
}
```

* L'utente non è autorizzato ad eseguire questa azione
```json
{
    "response_data":{
        "error_code":103
    },
    "message":"Unhautorized",
    "status_code":403
}
```

## request/update

Vedasi *commit/update*

#### Richiesta
```json
{
    "module":"request",
    "access":"update",
    "request_data":{
        "latest_update_timestamp":1555745875
    }
}
```

## user/info

Otteiene i dati di un'utente. Se user_id non viene specificato, vengono ritornate le informazioni dell'utente proprietario del token inviato nella richiesta. 

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

* Utente trovato
```json
{
    "response_data":{
        "user_data":{
            "user_id":1,
            "name":"Mario",
            "email":"test@example.com",
            "role":[1,2,3],
            "area":1
        }
    },
    "status_code":200
}
```

* Utente non trovato
```json
{
    "response_data":{
        "error_code":104,
        "error_message":"Utente non trovato"
    },
    "status_code":404
}
```