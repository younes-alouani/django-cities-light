#!/usr/bin/env bash
set -x
set -e

function do_db() {
    python test_project/manage.py syncdb --traceback --noinput --settings=test_project.$1
    python test_project/manage.py migrate --noinput --traceback --settings=test_project.$1
    python test_project/manage.py cities_light --force-import-all --traceback --settings=test_project.$1
}

pip install south 

if [[ $DB = 'mysql' ]]; then
    pip install 'http://cdn.mysql.com/Downloads/Connector-Python/mysql-connector-python-1.1.6.zip#md5=026e4a4b8731da33d73f0542349594fd'
    export DJANGO_ENGINE="mysql.connector.django"

    # test on mysql
    do_db settings_mysql
fi

if [[ $DB = 'postgresql' ]]; then
    pip install psycopg2
    do_db settings_postgres
fi 

if [[ $DB = 'sqlite' ]]; then
    export CITIES_LIGHT_CITY_SOURCE=cities1000

    rm -rf test_project/db.sqlite
    do_db settings_sqlite
fi
