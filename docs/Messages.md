# Elenco di richieste e risposte per gli endpoint

Le richieste e le risposte sono strutturate in formato JSON. In tutte le richieste, salvo quella di login, è necessario specificare il token nell'header **X-Auth-Header**.

## Risposte globali

### Risposta positiva

Se la richiesta è andata a buon fine, il risultato sarà il seguente:

```json
{
    "response_data":{},
    "status_code":200
}
```

### Errori globali

Questi errori possono apparire in ogni azione e pertanto non verranno riportati per ogni singolo endpoint.

* Token assente.
```json
{
    "response_data":{},
    "error":"ERROR_GLOBAL_MISSING_TOKEN",
    "status_code":401
}
```

* Token invalido. L'utente deve rifare l'accesso.
```json
{
    "response_data":{},
    "error":"ERROR_GLOBAL_INVALID_TOKEN",
    "status_code":401
}
```

* Azione richiesta non implementata. Controllare che si stia cercando di accedere ad un'azione implementata.
```json
{
    "response_data":{},
    "error":"ERROR_GLOBAL_NOT_IMPLEMENTED",
    "status_code":404
}
```

* Dati impostati in modo scorretto
```json
{
    "response_data":{},
    "error":"ERROR_GLOBAL_INVALID_REQUEST",
    "message":"Invalid Request",
    "status_code":400
}
```

* La richiesta non è un JSON
```json
{
    "response_data":{},
    "error":"ERROR_REQUEST_NOT_JSON",
    "status_code":400
}

* L'utente non è autorizzato ad eseguire questa azione
```json
{
    "response_data":{},
    "error":"ERROR_GLOBAL_UNAUTHORIZED",
    "message":"Unhautorized",
    "status_code":403
}
```



## Elenco degli endpoint

Di seguito verranno riportate solamente risposte dove l'array 'response_data' è valorizzato. 

### auth/login
Accede utilizzando username e password; il token non è richiesto. Se la password è uguale a 'cambiami', è necessario anche specificare la nuova password il campo 'new_password' pena l'esclusione dal sistema.

##### Richiesta
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

##### Risposte
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

* Login fallito. Nome utente o password errati.
```json
{
    "response_data":{},
    "error":"ERROR_LOGIN_INVALID_CREDENTIALS",
    "message":"Credenziali errate",
    "status_code":401
}
```

### auth/logout
Disconnette l'utente eliminando il token della sessione corente

##### Richiesta
```json
{
    "module":"auth",
    "access":"logout"
}
```

### auth/validateToken
Verifica che il token sia (ancora) valido. Se così non fosse, allora richiedere di fare l'accesso. Il token deve essere presente nell'header "X-Auth-Header".

##### Richiesta
```json
{
    "module":"auth",
    "access":"validateToken"
}
```

##### Risposte
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
    "response_data":{},
    "error":"ERROR_LOGIN_INVALID_TOKEN",
    "message":"Token non valido",
    "status_code":401
}
```

### branches/add
Aggiunge un nuovo branch al database, eseguibile solo da utenti amministratori (ruolo Power User)

##### Richiesta
```json
{
	"module":"branches",
	"action":"add",
    "request_data":{
        "branch_name":"test"
    }
}
```

### branches/shortList
Restituisce l'elenco delle branch

##### Richiesta
```json
{
	"module":"branches",
	"action":"shortList"
}
```

##### Risposta
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

### clients/shortList
Restituisce l'elenco dei clienti

##### Richiesta
```json
{
	"module":"clients",
	"action":"shortList"
}
```

##### Risposta
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

### commits/add
Utilizzato per aggiungere un nuovo commit al database. Tutti i campi sono obbligatori; se l'utente è un referente dell'area tecnica, il commit verrà automaticamente approvato.

##### Richiesta
```json
{
    "module":"commits",
    "access":"add",
    "request_data":{
        "title":"title",
        "description":"description string",
        "components":"component description",
        "branch":1
    }
}
```

### commits/approve
Va specificato l'ID del commit ed il flag di approvazione (1: Approvato / -1: Non Approvato)

##### Richiesta
```json
{
    "module":"commits",
    "access":"approve",
    "request_data":{
        "id":1,
        "approve_flag":1
    }
}
```

##### Risposte
* ID non valido
```json
{
    "response_data":{},
    "error":"ERROR_INVALID_ID",
    "message":"id doesn't refer to a valid element!",
    "status_code":400
}
```

* Elemento già approvato
```json
{
    "response_data":{},
    "error":"ERROR_WRONG_APP_STATUS",
    "message":"Already approved!",
    "status_code":400
}
```

### commits/list
Restituisce la lista dei commit presenti nel database sotto forma di pagine.
Se l'utente è un programmatore, verrà restituita la lista di commit creati da lui; se l'utente è un referente di area tecnica, esso vedrà la lista dei commit aggiunti da tutti gli utenti della sua area.

E' necessario specificare *limit* (numero di elementi per pagina - massimo 100) e *page* (numero di pagina).

Facoltativamente è possibile specificare **l'ordinamento** ascendente o discendente (order=ASC/DESC) secondo secondo i parametri:  id, title, description, timestamp (data creazione), update_timestamp (data di ultima modifica), author, approver, approval_status, components, branch. Se *sort* non è specificato, la lista viene ordinata in maniera discendente secondo la data di ultima modifica.

E' poi possibile impostare facoltativamente un **filtro** di ricerca, con la possibilità di filtrare per più campi. Si specifica *attribute* (parametro sul quale ricercare; l'elenco di parametri ammessi è lo stesso di quelli di sorting) e valueMatches (query da ricercare) oppure valueDifferentFrom (il valore deve essere diverso da).

##### Richiesta
```json
{
    "module":"commits",
    "access":"list",
    "request_data":{
        "limit":5,
        "page":6,
        "sort":{
            "parameter":"id",
            "order":"DESC"
        },
        "filter" : [
          {
            "attribute":"",
            "valueMatches":""
          },
          {
            "attribute":"",
            "valueDifferentFrom":""
          }
      ]
    }
}
```

##### Risposta
*count* contiene il conteggio degli elementi per la pagina corrente, mentre *count_total* contiene il numero totale di elementi per la query effettuata (considerando quindi eventuali filtri).
Ugualmente, *page* contiene il numero di pagina e *page_total* il numero di pagine totali; questi due valori partono da 0. *approval_status* è uguale a *0* se il commit deve essere ancora valutato, *1* se è stato approvato e *-1* se è stato respinto.

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
                  "name": "Test Admin",
                  "email": "admin@aum.com"
                },
                "approver": {
                  "name": "Test Admin",
                  "email": "admin@aum.com"
                },
            }
            [...]
        ],
        "page": 6,
        "page_total": 6
    },
    "status_code": 200
}
```

### commits/remove
Rimuove un commit a patto che lo stesso non sia già stato approvato

##### Richiesta
```json
{
	"module":"commits",
	"action":"remove",
  "request_data": {
    "id":1
  }
}
```

##### Risposte
* ID non valido
```json
{
    "response_data":{},
    "error":"ERROR_INVALID_ID",
    "message":"id doesn't refer to a valid element!",
    "status_code":400
}
```

* Elemento già approvato (non è possibile rimuovere commit già approvati)
```json
{
    "response_data":{},
    "error":"ERROR_WRONG_APP_STATUS",
    "message":"Already approved!",
    "status_code":400
}
```

* Commit già incluso in una richiesta di invio
```json
{
    "response_data":{},
    "error":"ERROR_REMOVE_COMMIT_ALREADY_INCLUDED",
    "message":"Commit already included in a send request",
    "status_code":400
}
```

### commits/shortList
Restituisce la lista dell'ID e del titolo dei commit aggiunti dallo sviluppatore corrente ed approvati da un referente

##### Richiesta
```json
{
	"module":"commits",
	"action":"shortList"
}
```

##### Risposta
```json
{
  "response_data": [
    {
      "commit_id": 3,
      "title": "Common Marsh Bedstraw"
    },
    {
      "commit_id": 4,
      "title": "Yellow Nightshade Groundcherry"
    },
  ],
  "status_code": 200
}
```

### commits/update
Utilizzato per richiedere se vi sono nuovi commit data una certa data.
E' necessario specificare latest_update_timestamp, il timestamp dall'ultimo aggiornamento ricevuto e section, la sezione nella quale si trova l'utente. I parametri ammessi in 'section' sono le stinghe corrispondenti ai ruoli utente (developer, technicalAreaManager).

##### Richiesta
```json
{
    "module":"commits",
    "access":"update",
    "request_data":{
        "latest_update_timestamp":1555745875,
        "section":"developer"
    }
}
```

##### Risposte
* Aggiornamenti trovati
```json
{
  "response_data": {
    "latest_update_timestamp": 1555745875,
    "updates_found": true
  },
  "status_code": 200
}
```

* Aggiornamenti non trovati
```json
{
    "response_data": {
      "latest_update_timestamp": 1555745875,
      "updates_found":false
    },
    "status_code": 200
}
```

### sendRequests/add
Utilizzato per aggiungere una nuova richiesta di invio al database.
*install_type* indica il tipo di installazione: 0 (A Caldo) / 1 (A Freddo); *dest_clients* gli ID degli utenti destinatari e *commits* l'elenco dei commit inclusi nella richiesta di invio (facoltativo)

Tutti i campi tranne *commits* sono obbligatori.

##### Richiesta
```json
{
    "module":"sendRequests",
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

### sendRequests/approve
Vedasi commits/approve

##### Richiesta
```json
{
    "module":"sendRequests",
    "access":"approve",
    "request_data":{
        "id":1,
        "approve_flag":1
    }
}
```

### sendRequests/install
Segnala l'avvenuta installazione di una patch. Eseguibile solo da utenti del gruppo client. Il campo 'feedback' è facoltativo, mentre il campo "install_status" può avere valore 1 (installazione avvenuta con successo) o -1 (installazione fallita).

##### Richiesta
```json
{
	"module":"sendRequests",
	"action":"install",
	"request_data": {
		"id":4,
    "install_status":1,
		"feedback":"Test Feedback"
	}
}
```

##### Risposte

* Inserimento andato a buon fine
```json
{
  "response_data": [],
  "status_code": 200
}
```

* ID non valido
```json
{
    "response_data":{},
    "error":"ERROR_INVALID_ID",
    "message":"id doesn't refer to a valid element!",
    "status_code":400
}
```

* Aggiornamento non inviato al cliente
```json
{
    "response_data":{},
    "error":"ERROR_WRONG_APP_STATUS",
    "message":"The current send request was not sent to the client",
    "status_code":400
}
```

### sendRequests/installType
Restituisce i tipi di installazione

##### Richiesta
```json
{
	"module":"sendRequests",
	"action":"installType"
}
```

##### Risposta
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

### sendRequests/list
Il funzionamento è uguale a quello di *commits/list*, eccezione fatta per il campo obbligatorio 'role' nella richiesta. Se tale campo è impostato a *client* (cliente), l'endpoint ritornerà la lista delle richieste di invio a suo carico; se è impostato a *revisionOfficeManager* (ufficio revisioni), l'endpoint ritornerà solamente richieste già approvate. Per qualsiasi altro valore, l'endpoint ritornerà la lista delle richieste in modo simile a quello dei commit.

L'elenco dei campi di filtraggio ammessi prevede anche send_timestamp (data di invio della patch ai clienti), install_type (tipo di installazione, 0 per a freddo ed 1 per a caldo), install_link (link di installazione).
Se 'role' è uguale a 'client', allora sono ammessi, oltre ai tre campi soprastanti, anche install_timestamp (data di installazione della patch da parte del cliente), install_status (stato di installazione; 0 non installato, 1 installato e -1 errore nell'installazione); install_comment (feedback rilasciato dal cliente). 

##### Richiesta
```json
{
    "module":"sendRequests",
    "access":"list",
    "request_data":{
        "limit":5,
        "page":6,
        "role":"client",
        "sort":{
            "parameter":"id",
            "order":"DESC"
        },
        "filter":{
            "attribute":"",
            "valueDifferentFrom":""
        }
    }
}
```

##### Risposte

* Risposta con role=client

```json
{
  "response_data": {
    "count": 1,
    "count_total": 1,
    "list": [
      {
        "id": 82,
        "title": "Palespike Lobelia",
        "description": "Sed ante. Vivamus tortor. Duis mattis egestas metus.",
        "branch": "Wrapsafe",
        "install_type": "1",
        "install_link": "https:\/\/people.com.cn\/neque\/duis\/bibendum\/morbi\/non\/quam\/nec.json",
        "install_timestamp": 1534207466,
        "send_timestamp": 1534185577,
        "install_status": "1",
        "install_comment": "Cras mi pede, malesuada in, imperdiet et, ",
        "resp": [
          "Test Admin"
          "Test Developer",
        ]
      },
    ],
    "page": 0,
    "page_total": 0
  },
  "status_code": 200
}
```

* Risposta con role!=client
Uguale a *commits/list* con l'eccezione di *approval_status*: è uguale a *0* se la richiesta deve essere ancora valutata, *1* se è stata approvata e *-1* se è stata respinta e **2** se è stata inviata ai clienti.
```json
{
    "response_data": {
        "count": 5,
        "count_total": 35,
        "list": [
            {
            "id": 50,
            "title": "Perennial Cupgrass",
            "description": "Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.",
            "timestamp": 1535911423,
            "update_timestamp": 1556539604,
            "components": "Sed ante. Vivamus tortor. Duis mattis egestas metus.",
            "branch": "Pannier",
            "approval_status": "0",
            "author": {
                "name": "Test Admin",
                "email": "admin@aum.com"
            },
            "install_link": "www.ciaone.it",
            "install_type": "0",
            "send_timestamp": "2019-04-29 14:06:44",
            "commits": [
                {
                    "id": 23,
                    "title": "Twolobe Dutchman's Pipe"
                },
                {
                    "id": 75,
                    "title": "Wart Lichen"
                }
            ],
            "clients": [
                {
                    "name": "Test Client User",
                    "email": "client@aum.com"
                }
            ]
        },
            [...]
        ],
        "page": 6,
        "page_total": 6
    },
    "status_code": 200
}
```

### sendRequests/send
Invia una richiesta di invio ai clienti designati. Solo i membri dell'ufficio revisioni possono effettuare tale azione.

##### Richiesta
```json
{
	"module":"sendRequests",
	"action":"send",
	"request_data": {
		"id":4,
        "install_link":"http://example.com"
	}
}
```

##### Risposte

* Invio andato a buon fine 
```json
{
  "response_data": [],
  "status_code": 200
}
```

* Richiesta di invio non approvata dal referente area tecnica
```json
{
    "response_data":{},
    "error":"ERROR_WRONG_APP_STATUS",
    "message":"The send request hasn't been approved by a tech area member",
    "status_code":400
}
```

* ID non valido
```json
{
    "response_data":{},
    "error":"ERROR_INVALID_ID",
    "message":"id doesn't refer to a valid element!",
    "status_code":400
}
```

### sendRequests/update

Vedasi *commits/update*. I parametri ammessi in 'section' sono *developer*, *technicalAreaManager*, *revisionOfficeManager*, *client*.

##### Richiesta
```json
{
    "module":"sendRequest",
    "access":"update",
    "request_data":{
        "latest_update_timestamp":1555745875,
        "section":"client"
    }
}
```

### user/add

Aggiunge un nuovo utente al database. E' necessario specificare username, nome completo, email, ruolo/i ed in modo facoltativo l'identificativo dell'area di riferimento. La password sarà impostata di default a 'cambiami'; sarà quindi necessario cambiarla al primo accesso.

##### Richiesta
```json
{
    "module":"user",
    "access":"add",
    "request_data":{
        "username":"mario.rossi",
        "name":"Mario Rossi",
        "email":"mario@rossi.it",
        "roles": [
            "developer"
        ],
        "area_name":"Area 2"
    }
}
```

##### Risposte

* Aggiunta andata a buon fine 
```json
{
  "response_data": [],
  "status_code": 200
}
```

### user/areas
Restituisce l'elenco delle aree funzionali

##### Richiesta
```json
{
	"module":"data",
	"action":"areas"
}
```

##### Risposta
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

### user/changePsw

Cambia la password di un utente. Se l'utente attualmente connesso è un amministratore (ruolo Power User), egli ha la possibilità di modificare le password di altri utenti (campo username) senza inserire la vecchia password (campo old_password).
Un utente normale può invece modificare la sua password (new_password) solo inserendo la vecchia password (old_password).

##### Richiesta
```json
{
    "module":"user",
    "access":"changePsw",
    "request_data":{
        "username":"mario.rossi",   //Solo per amministratori
        "old_password":"ciao",      //Solo per utenti normali
        "new_password":"pippo"
    }
}
```

##### Risposte

* Modifica andata a buon fine 
```json
{
  "response_data": [],
  "status_code": 200
}
```

### user/info

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

##### Risposte

* Utente trovato. Resp contiene l'elenco dei referenti area tecnica per l'utente corrente.
```json
{
  "response_data": {
    "user_id": 1,
    "username": "admin",
    "name": "Test Admin",
    "email": "admin@aum.com",
    "role": [1,2,3,4],
    "role_name": ["ROLE_DEVELOPER", "ROLE_TECHAREA", "ROLE_REVOFFICE", "ROLE_CLIENT"],
    "resp": [
      {
        "user_id": 1,
        "name": "Test Admin"
      },
      {
        "user_id": 4,
        "name": "Test Tech Area User"
      }
    ],
    "area_id": 1,
    "area_name": "Area 1"
  },
  "status_code": 200
}
```

* Utente non trovato
```json
{
    "response_data":{
        
    },
    "error":"ERROR_USER_NOT_FOUND",
    "error_message":"Utente non trovato",
    "status_code":404
}
```

### user/roles
Restituisce l'elenco dei ruoli in uso

##### Richiesta
```json
{
	"module":"user",
	"action":"roles"
}
```

##### Risposta
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