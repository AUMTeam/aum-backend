# Impostazioni iniziali del progetto

## Installazione dei programmi di base
Installare i seguenti pacchetti: 

Per **Debian**:
```bash
apt-get install php php-fpm php-cgi php-pgsql apache2 postgresql postgresql-client
```

Per **Arch Linux**:
```bash
pacman -S php php-fpm php-cgi php-pgsql apache postgresql
```

E' richiesto PHP con versione minima 7 e compilato con i flag ```--enable-pcntl``` e ```--enable-ldap```


## Configurazione di apache

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


## Configurazione di PHP

Creare ```/etc/php/conf.d/db.ini```:

```
extension=pdo_pgsql
extension=pgsql
```


## Abilitazione dei servizi

```bash
systemctl enable php-fpm httpd postgresql
systemctl start php-fpm httpd postgresql
```

## Configurazione interna del progetto
Aprire ```config.php``` e modificare i seguenti campi:
- Configurazione del database:
  ```php
  //$db_type = "pgsql"; //Uncomment this for PostgreSQL usage
  $db_type = "mysql"; //Uncomment this for MySQL usage

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
  //URL to the Front-End, used in mails
  $gui_url = "";
  //Mail server parameters
  $mail_config = [
    'enabled' => true,
    'server' => '',
    'protocol' => 'tls', //or ssl
    'port' => 587,
    'username' => '',
    'password' => ''
  ];
  ```

- Configurazione del server LDAP:
  ```php
  //--LDAP Configuration--
  $ldap_config = [
      'enabled' => false,
      'server' => "ldaps://localhost:389",
      'domain' => 'mydomain',
      'tld' => '.com'
  ];
  ```

Eseguire il seguente comando:
```php composer.phar install```