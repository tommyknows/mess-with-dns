#!/bin/bash
set -eu

trap 'kill $(jobs -p)' SIGINT SIGTERM
export REQUEST_DB_FILENAME=requests-dev.sqlite
export USER_DB_FILENAME=users-dev.sqlite
# these are "secrets" but in dev mode it doesn't matter, don't use this script
# in prod
export HASH_KEY=CgfCQb/b1yLf251DsG9Zo8CN5h6UKP268QZPxR6ddDw=
export BLOCK_KEY=psYea0IVC59V3kbfMYgWI7AlUmioiNsv9Em1GqksEEE=


cd pdns/conf_prod || exit 1
rm -f ./pdns.controlsocket
pdns_server --config-dir=. &
dnsdist -C dnsdist.conf -l 127.0.0.1:5333 --supervised &
cd ../.. || exit 1

ls api/*.go api/go* scripts/* run.sh | entr -r bash scripts/run_go.sh &
sleep 0.5
cd frontend
ls ./*.js ./*.html ./*.ts components/* | grep -v bundle | entr bash esbuild.sh &
npx tailwindcss -o css/tailwind-small.min.css --watch &


wait
