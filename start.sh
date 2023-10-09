#!/bin/bash

SCRIPT_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

is_port_in_use () {
    if type netstat &>/dev/null; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            P=".$1"
        else
            P=":$1"
        fi
        netstat -anl | grep -q $P
        return $?
    elif type lsof &>/dev/null; then
        lsof -n -P -t -i :$1 > /dev/null
        return $?
    else
        echo "Both netstat and lsof are missing."
        exit 1
    fi
}

#Set a configuration variable for use within the docker-compose.yml file
if [[ "$OSTYPE" != "cygwin" || "$OSTYPE" != "msys" || "$OSTYPE" != "win32" ]]; then
    APORT=$(grep '^PORT=' $SCRIPT_PATH/setting.ini | cut -d'=' -f2)
    while is_port_in_use $APORT; do
        APORT=$(($APORT+10))
    done

    export QS_APPNAME=$(grep '^APPNAME=' $SCRIPT_PATH/setting.ini | cut -d'=' -f2)
    export QS_PORT=$APORT
    export QS_UID=$(id -u)    
fi

QS_REBUILD=$(grep '^REBUILD=' $SCRIPT_PATH/setting.ini | cut -d'=' -f2)
if [[ ${QS_REBUILD:-false} == true ]]; then
    docker compose -f $SCRIPT_PATH/docker-compose.yml build
fi

docker compose -f $SCRIPT_PATH/docker-compose.yml up -d

start_browser () {
    URL="http://localhost:$APORT"

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open "$URL"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        open "$URL"
    elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        start "$URL"
    else
        echo "This OS is not supported"
        exit 1
    fi
}

while true; do
    if docker logs ${QS_APPNAME} 2>&1 | grep -q "http://localhost:${QS_PORT:-3000}"; then
        start_browser
        break
    else
        echo "Loading..."
        sleep 3
    fi
done




