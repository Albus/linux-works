##### Создание кластера

###### Linux
```commandline 
docker run --rm -i -t \
    -v ~/pg/data:/var/lib/postgresql:consistent \
    -v ~/pg/etc:/etc/postgresql:consistent \
    pg11 \
    pg_createcluster --start-conf=disabled 11 main -- \
    --auth-host=password --auth-local=trust --no-clean \
    --allow-group-access --wal-segsize=1 --pwprompt
```

###### Windows
```commandline
docker run --rm -i -t ^
    -v c:\users\user\Documents\pg\data:/var/lib/postgresql:consistent ^
    -v c:\users\user\Documents\pg\etc:/etc/postgresql:consistent ^
    pg11 ^
    pg_createcluster --start-conf=disabled 11 main -- ^
    --auth-host=password --auth-local=trust --no-clean ^
    --allow-group-access --wal-segsize=1 --pwprompt
```


**`--start-conf`**
_`auto`|`manual`|`disabled`_ — Set automatic startup behaviour in start.conf (default: _`auto`_)

**`--no-clean`**
По умолчанию, при выявлении ошибки на этапе развёртывания кластера,
_`initdb`_ удаляет все файлы, которые к тому моменту были созданы.
Параметр предотвращает очистку файлов для целей отладки.

**`--debug`**
Выводит отладочные сообщения загрузчика и ряд других сообщений,
не очень интересных широкой публике. Загрузчик — это приложение _`initdb`_,
используемое для создания каталога таблиц.
С этим параметром выдаётся очень много крайне скучных сообщений.

**`--wal-segsize=размер`**
Задаёт размер сегмента WAL, в мегабайтах. Такой размер будет иметь каждый отдельный 
файл в журнале WAL. По умолчанию размер равен 16 мегабайтам. 
Значение должно задаваться степенью 2 от 1 до 1024 (в мегабайтах). 
**Этот параметр можно установить только во время инициализации и нельзя изменить позже**.
Этот размер бывает полезно поменять при тонкой настройке трансляции или архивации WAL. 
Кроме того, в базах данных с WAL большого объёма огромное количество файлов WAL в каталоге 
может стать проблемой с точки зрения производительности и администрирования. 
Увеличение размера файлов WAL приводит к уменьшению числа этих файлов.

**`--pwprompt`**
Указывает _`initdb`_ запросить пароль, который будет назначен суперпользователю базы данных.
Это не важно, если не планируется использовать аутентификацию по паролю. 
В ином случае этот режим аутентификации оказывается неприменимым, пока пароль не задан.

**`--allow-group-access`**
Позволяет пользователям, входящим в группу владельца кластера, читать все файлы кластера, 
создаваемые программой _`initdb`_. **В Windows этот ключ не работает, 
так как там не поддерживаются разрешения для группы в стиле POSIX**.

**`--auth-host=authmethod`**
Параметр указывает метод аутентификации для локальных пользователей, 
подключающихся по TCP/IP, используемый в pg_hba.conf (строки host).

**`--auth-local=authmethod`**
Параметр выбирает метод аутентификации локальных пользователей, 
подключающихся через Unix-сокет, используемый в pg_hba.conf (строки local).

**`--waldir=каталог`**
Этот параметр указывает каталог для хранения журнала предзаписи.

---

##### Просмотр информации о созданном кластере

###### Linux
```commandline 
docker run --rm -i -t \
    -v ~/pg/data:/var/lib/postgresql:consistent \
    -v ~/pg/etc:/etc/postgresql:consistent \
    pg11 pg_conftool 11 main show all
```

###### Windows
```commandline
docker run --rm -i -t ^
    -v c:\users\user\Documents\pg\data:/var/lib/postgresql:consistent ^
    -v c:\users\user\Documents\pg\etc:/etc/postgresql:consistent ^
    pg11 pg_conftool 11 main show all
```

