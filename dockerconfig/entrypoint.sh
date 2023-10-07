#!/bin/bash

adduser -D -u ${UID:-1000} appuser
addgroup appuser node

su appuser

source /setting.ini

echo "${TEMPLATE:-noo}"

if [[ ! -f ./package.json ]]; then
    yes | npm create vite@latest . -- --template ${TEMPLATE:react-ts}
fi

if [ -d "node_modules" ]; then
    npm run dev -- --host 0.0.0.0 --port ${PORT}
else
   npm install
   
   if [ $? -eq 0 ]; then
        npm run dev -- --host 0.0.0.0 --port ${PORT}
   fi
fi

"$@"