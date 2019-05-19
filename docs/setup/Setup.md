# Impostazioni iniziali del progetto

## Configurazione degli applicativi

Per poter funzionare correttamente, il sistema necessita di un **Web Server**, dell'interprete **PHP**, di **composer** per la gestione delle dipendenze e di un **DBMS** (MySQL o PostgreSQL).

Di seguito viene riportata la configurazione in ambiente *linux*. Se questi applicativi sono già stati installati, è possibile andare direttamente alla sezione successiva.

### Installazione degli applicativi di base

Installare i seguenti pacchetti: 

Per **Debian**:
```bash
apt-get install php php-fpm php-cgi php-pgsql apache2 postgresql postgresql-client composer
```

Per **Arch Linux**:
```bash
pacman -S php php-fpm php-cgi php-pgsql apache postgresql composer
```

E' richiesto PHP con versione minima 7 e compilato con il flag ```--enable-pcntl```


### Configurazione di apache

Creare ```/etc/httpd/conf/extra/php-fpm.conf``` ed inserire:

```ini
DirectoryIndex index.php index.html
<FilesMatch \.php$>
    SetHandler "proxy:unix:/run/php-fpm/php-fpm.sock|fcgi://localhost/"
</FilesMatch>
```



Modificare ```/etc/httpd/conf/httpd.conf``` e:

- Aggiungere i seguenti moduli:

  ```ini
  LoadModule proxy_module modules/mod_proxy.so
  LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
  LoadModule http2_module modules/mod_http2.so
  ```


- Aggiungere le seguenti linee alla fine del file:

  ```ini
  Include conf/extra/php-fpm.conf
  Protocols h2 http/1.1
  ```

HTTP2 non è strettamente necessario, ma dovrebbe aumentare le performance del sito.


### Configurazione di PHP

Creare ```/etc/php/conf.d/db.ini```:

```
extension=pdo_pgsql
extension=pgsql
```

### Abilitazione dei servizi

```bash
systemctl enable php-fpm httpd postgresql
systemctl start php-fpm httpd postgresql
```


## Configurazione del database

Viene fornito un *database dump* contenente solo la struttura (*db_base.sql*) ed uno già popolato con righe di test (*db_full.sql*), che vanno opportunamente caricati sul sistema in uso. A seconda del DBMS in uso, è necessario importare i file presenti nella cartella *mysql* o *postgres*. In tutti i casi il sistema prevede un utente amministratore di default, con nome utente "admin" e password "admin".
  

## Configurazione interna del progetto

Viene predisposto un file di configurazione centrale, ```config.php``` , dove sono presenti tutti i parametri fondamentali del progetto. E' invece possibile modificare i parametri di connessione al database ed al servizio mail in ```configPsw.php``` , file non tracciato da git.

Rinominare ```configPsw.php.template``` in ```configPsw.php``` e modificare i seguenti campi:
- Configurazione del database:
  ```php
  //$db_type = "pgsql"; //Utilizzo di PostgreSQL
  $db_type = "mysql"; //Utilizzo di MySQL

  //DB configuration
  $db_config = [
      'server' => "",
      'username' => "",
      'password' => "",
      'db_name' => "",
  ];
  ```

- Configurazione del servizio mail:
  ```php
  $gui_url = "";    //Indirizzo web che punta al front-end
  //Mail server parameters
  $mail_config = [
    'enabled' => true,
    'server' => '',
    'protocol' => 'tls', //o ssl, o '' per comunicazione in plain-text
    'port' => 587,
    'username' => '',
    'password' => ''
  ];
  ```

In ultimo, eseguire il seguente comando per scaricare la libreria *PHPMailer*:
```php composer.phar install```