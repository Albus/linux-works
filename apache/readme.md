* кладем конфиг где-то на диске
```apache
LoadModule _1cws_module /opt/1C/wsap24.so
Alias /bases /var/www/1cfresh
<Directory /var/www/1cfresh>
  Options +FollowSymLinks
  RewriteEngine On
  RewriteCond %{REQUEST_METHOD} ^(HEAD)
  RewriteCond %{REQUEST_URI} ^[-/0-9a-zA-Z]+/ws/.*$
  RewriteRule .* - [R=405]
  RewriteCond %{REQUEST_METHOD} ^(HEAD)
  RewriteCond %{REQUEST_URI} ^[-/0-9a-zA-Z]+/hs/.*$
  RewriteRule .* - [R=200]
  AllowOverride All
  Order allow,deny
  Allow from all
  SetHandler 1c-application
  AuthType None
  Satisfy all
  ManagedApplicationDescriptor /var/www/1cfresh/bases.vrd
</Directory>
```
*  запускаем контейнер с параметром
```sh
docker run ... -c /path/to/config/*
```
