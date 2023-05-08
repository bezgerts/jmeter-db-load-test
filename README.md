# Нагрузочное тестирование баз данных при помощи JMeter

## Необходимое ПО

Для установки JMeter и проведения нагрузочного тестирования потребуются:

- Java 8+ (установка описана ниже)
- Docker ([инструкция по установке docker](https://docs.docker.com/engine/install/))

## Установка JMeter

### Установка Java 8+

Для работы JMeter необходима установленная версия Java. 

Версия Java должна быть не ниже 8.

Ссылка для скачивания OpenJDK [перейти](https://openjdk.org/install/).

Установка подробно описана в документации к JDK.

После установки JDK необходимо выполнить проверку, что Java установлена корректно:

```bash
java --version
```

В результате выполнения команды должен быть отображена версия JDK:

```bash
java 17.0.1 2021-10-19 LTS
Java(TM) SE Runtime Environment (build 17.0.1+12-LTS-39)
Java HotSpot(TM) 64-Bit Server VM (build 17.0.1+12-LTS-39, mixed mode, sharing)
```

### Скачивание бинарников JMeter

Скачиваем последнюю версию JMeter (нужно скачать архив и распаковать его).

* [страница скачивания](https://jmeter.apache.org/download_jmeter.cgi)
* [прямая ссылка на скачивание архива](https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.5.zip)

### Распаковка архива

После скачивания ахива необходимо распаковать его в директорию, где установлены другие программы.

Например: `C:\Program Files\Apache\apache-jmeter-5.5`

### Добавление коннекторов к базам данных

Для того, чтобы JMeter мог выполнять запросы к базам данных, необходимо для каждой из баз установить драйвера.

#### MySQL

Для скачивавания драйвера необходимо перейти по ссылке:

[https://dev.mysql.com/downloads/connector/j/](https://dev.mysql.com/downloads/connector/j/)

Далее необходимо выбрать нужную версию драйвера (перейти во вкладку Archive, если версия устарела).

В поле `Operating System` выбрать `Platform Independent`. Далее необходимо скачать архив и разархивировать его в любую директорию.

После этого необходимо скопировать `jar`-файл с драйвером базы в JMeter, а именно в папку `lib` (например: `C:\Program Files\Apache\apache-jmeter-5.5\lib`).

#### PostgreSQL

Для скачивавания драйвера необходимо перейти по ссылке:

[https://jdbc.postgresql.org/download/](https://jdbc.postgresql.org/download/)

Далее скачиваем драйвер последней версии для Java 8+.

Ссылка на скачивание файла: [https://jdbc.postgresql.org/download/postgresql-42.6.0.jar](https://jdbc.postgresql.org/download/postgresql-42.6.0.jar)

После этого необходимо скопировать `jar`-файл с драйвером базы в JMeter, а именно в папку `lib` (например: `C:\Program Files\Apache\apache-jmeter-5.5\lib`).

### Увеличение HEAP 

Увеличение размера кучи необходимо для того, чтобы JMeter мог использовать больший объем памяти для тестирования.

Для увеличения размера кучи необходимо отредактировать файл jmeter.bat или jmeter.sh (расширение файла зависит от операционной системы, на которой запускается JMeter).

В файле нужно изменить следующие параметры: `-Xms1g -Xmx1g -XX:MaxMetaspaceSize=256m`.

### Запуск JMeter

Для запуска JMeter необходимо перейти в директорию, где установлен JMeter, и выполнить следующую команду:

На Linux: `./bin/jmeter.sh`

На Windows: `bin\jmeter.bat`

В результате выполнения команды должно быть отображено сообщение:

```bash
================================================================================
Don't use GUI mode for load testing !, only for Test creation and Test debugging.
For load testing, use CLI Mode (was NON GUI):
   jmeter -n -t [jmx file] -l [results file] -e -o [Path to web report folder]
& increase Java Heap to meet your test requirements:
   Modify current env variable HEAP="-Xms1g -Xmx1g -XX:MaxMetaspaceSize=256m" in the jmeter batch file
Check : https://jmeter.apache.org/usermanual/best-practices.html
================================================================================
```

Должно открыться основное окно JMeter:

![](https://github.com/bezgerts/jmeter-db-load-test/blob/main/images/main_screen.jpg)

## Запуск баз данных в Docker

Для запуска баз данных, которые будут тестироваться при помощи JMeter, необходимо:

- откорректировать скрипты миграции;
- запустить docker-compose;

### Корректировка скриптов миграции

В корне репозитория находятся два файла: `init-mysql.sql` и `init-postgres.sql`.

В этих файлах указываются sql-скрипты, которые будут выполнены после старта контейнеров, запущенных в `docker-compose`.

При необходимости можно скорректировать данные скрипты, чтобы эмулировать нагрузку на реальные схемы данных.

### Запуск docker-compose

В docker-compose можно выделить необходимые ресурсы под каждый из контейнеров. 

В примере на каждый контейнер выделяется по одному процессору и по 256 мегабайт оперативной памяти.

```
 deploy:
      resources:
        limits:
          cpus: '1'
          memory: 256M
```

Для запуска `docker-compose` необходимо открыть терминал, перейти в директорию, в которой расположен `docker-compose.yml`, и выполнить команду:

```bash
docker-compose up
```

## Создание тестового плана

### Изменение имени тестового плана

Тестовый план - корневой элемент, в котором будут находиться другие элементы тестового плана.

Щелкаем левой кнопкой мыши по `Test Plan` в дереве элементов и изменяем название тестового плана текстовом поле, находящемся в правой части экрана.

Изменяем название на `JMeter Db Test Plan`.

![](https://github.com/bezgerts/jmeter-db-load-test/blob/main/images/rename_test_plan.jpg)

### Добавление Thread Group

Thread Group - это элемент, который позволяет задавать количество тестовых пользователей, как часто эти пользователи посылают запросы, и какое количество запросов данные пользователи должны послать.

Щелкаем правой кнопкой мыши по `JMeter Db Test Plan`.

Выбираем `Add` -> `Threads (Users)` -> `Thread Group`

Изменяем название `Thread Group` на `JDBC Users`.

Увеличиваем количество пользователей на 50.

Указываем, что если произошла ошибка, то нужно начать заново выполнять тестовый план для пользователя (выставляем радио-баттон на значение `Start Next Thread Loop`).

Устанавливаем `Ramp-up period` в 10 секунд. `Ramp-up period` - период, за который JMeter запустит всех пользователей. В нашем примере JMeter запустит 50 пользователей за 10 секунд, т.е. каждую секунду будет запущено 5 пользователей.

Устанавливаем `Loop Count` в значение 100. `Loop Count` - количество повторений теста каждым пользователем.

Пример заполненной `Thread Group`:

![](https://github.com/bezgerts/jmeter-db-load-test/blob/main/images/thread_group.jpg)

### Добавление MySQL Connection Configuration

JDBC Connection Configuration - это элемент, который позволяет настраивать подключение к базе данных. 

Щелкаем правой кнопкой мыши по `JDBC Users`.

Выбираем `Add` -> `Config Element` -> `JDBC Connection Configuration`.

Изменяем название `JDBC Connection Configuration` на `MySQL Connection Configuration`.

Устанавливаем настройки в следующих полях (база MySQL):

- Database URL: `jdbc:mysql://localhost:3309/otus`
- Variable name: `myMySqlDatabase` (переменная, которая связывает `JDBC Request` и `JDBC Connection Configuration`)
- JDBC Driver class: `com.mysql.jdbc.Driver`
- Username: `root` 
- Password: `12345`
- Validation Query: `SELECT 1`

Имя пользователя и пароль взяты из `docker-compose.yml`.

![](https://github.com/bezgerts/jmeter-db-load-test/blob/main/images/mysql_connection_configuration.jpg)

### Добавление Postgres Connection Configuration

JDBC Connection Configuration - это элемент, который позволяет настраивать подключение к базе данных.

Щелкаем правой кнопкой мыши по `JDBC Users`.

Выбираем `Add` -> `Config Element` -> `JDBC Connection Configuration`.

Изменяем название `JDBC Connection Configuration` на `Postgres Connection Configuration`.

Устанавливаем настройки в следующих полях (база Postgres):

- Database URL: `jdbc:postgresql://localhost:5434/postgres`
- Variable name: `myPostgresDatabase` (переменная, которая связывает `JDBC Request` и `JDBC Connection Configuration`)
- JDBC Driver class: `org.postgresql.Driver`
- Username: `postgres`
- Password: `postgres`
- Validation Query: `SELECT 1`

Имя пользователя и пароль взяты из `docker-compose.yml`.

![](https://github.com/bezgerts/jmeter-db-load-test/blob/main/images/postgres_connection_configuration.jpg)

### Добавление JDBC Request для тестирования MySQL

JDBC Request - это элемент, который позволяет настраивать запрос, отправляемый к базе данных.

Щелкаем правой кнопкой мыши по `JDBC Users`.

Выбираем `Add` -> `Sampler` -> `JDBC Request`.

Изменяем название `JDBC Request` на `Expensive products (MySQL DB)`.

Указываем значения для полей:

- Variable name: `myMySqlDatabase` (переменная, которая связывает `JDBC Request` и `JDBC Connection Configuration`)
- Query Type: `Prepared Select Statement`
- SQL Query: `select count(*) from products p join product_categories pc on pc.id = p.category_id where p.cost > ?`
- Parameter Values: 500
- Parameter Types: numeric

![](https://github.com/bezgerts/jmeter-db-load-test/blob/main/images/mysql_jdbc_request.jpg)

### Добавление JDBC Request для тестирования Postgres

JDBC Request - это элемент, который позволяет настраивать запрос, отправляемый к базе данных.

Щелкаем правой кнопкой мыши по `JDBC Users`.

Выбираем `Add` -> `Sampler` -> `JDBC Request`.

Изменяем название `JDBC Request` на `Expensive products (Postgres DB)`.

Указываем значения для полей:

- Variable name: `myPostgresDatabase` (переменная, которая связывает `JDBC Request` и `JDBC Connection Configuration`)
- Query Type: `Prepared Select Statement`
- SQL Query: `select count(*) from products p join product_categories pc on pc.id = p.category_id where p.cost > ?`
- Parameter Values: 500
- Parameter Types: numeric

![](https://github.com/bezgerts/jmeter-db-load-test/blob/main/images/postgres_jdbc_request.jpg)

### Добавление отчетов о результатах тестирования (Summary Report)

Summary Report - это элемент, который позволяет увидеть суммарный результат выполненных тестов.

Щелкаем правой кнопкой мыши по `JDBC Users`.

Выбираем `Add` -> `Listener` -> `Summary Report`.

![](https://github.com/bezgerts/jmeter-db-load-test/blob/main/images/summary_report.jpg)

### Добавление информации о выполнении запросов (View Result Tree)

View Result Tree - это элемент, который позволяет увидеть информацию о выполнении каждого из запросов.

Щелкаем правой кнопкой мыши по `JDBC Users`.

Выбираем `Add` -> `Listener` -> `View Result Tree`.

![](https://github.com/bezgerts/jmeter-db-load-test/blob/main/images/view_result_tree.jpg)

## Запуск тестового плана

Для запуска тестового плана необходимо выбрать в дереве `Summary Report` и нажать `Ctrl + R` или на кнопку старта (зеленый треугольник).

После завершения тестирования в таблице будут отображаться результаты тестов.

Здесь можно сравнить время выполнения запросов на MySQL и Postgres.

Основные параметры в результатах - Average и Throughput. 

- Average - среднее время выполнения запроса
- Throughput - количество запросов, обрабатываемых в единицу времени

![](https://github.com/bezgerts/jmeter-db-load-test/blob/main/images/summary_report_result.jpg)

После этого можно перейти во `View Result Tree`, где можно подробно посмотреть информацию по выполненным запросам.

![](https://github.com/bezgerts/jmeter-db-load-test/blob/main/images/view_result_tree_results_1.jpg)

![](https://github.com/bezgerts/jmeter-db-load-test/blob/main/images/view_result_tree_results_2.jpg)

![](https://github.com/bezgerts/jmeter-db-load-test/blob/main/images/view_result_tree_results_3.jpg)

Если запрос будет возвращать данные в табличном виде, то они будут отображены следующим образом:

![](https://github.com/bezgerts/jmeter-db-load-test/blob/main/images/view_result_tree_results_4.jpg)

## Ссылки на почитать

[Официальный туториал](https://jmeter.apache.org/usermanual/build-db-test-plan.html)

[Приручаем JMeter (Хабр)](https://habr.com/ru/articles/261483/)

[How to use Jmeter's JDBC Request (Oracle)](https://www.programmersought.com/article/84454047958/)