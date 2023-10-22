#!/bin/sh

adduser -D -u ${UID:-1000} appuser
addgroup appuser node

su appuser

source /setting.ini

start_dev_server(){
    if [[ ${START_DEV_SERVER:-true} == true ]]; then
        npm run dev -- --host 0.0.0.0 --port ${PORT}
    else
        tail -F /dev/null
    fi

}

if [[ ! -f ./package.json ]]; then
    yes | npm create vite@latest . -- --template ${TEMPLATE:react-ts}
fi

if [ -d "node_modules" ]; then
    start_dev_server
else
   npm install
   
   if [ $? -eq 0 ]; then
        start_dev_server
   fi
fi

"$@"