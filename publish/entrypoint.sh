#!/bin/sh

set -e

local_registry="http://localhost:4873"

# start local registry
tmp_registry_log=`mktemp`
sh -c "mkdir -p $HOME/.config/verdaccio"
sh -c "cp --verbose /config.yaml $HOME/.config/verdaccio/config.yaml"
sh -c "nohup verdaccio --config $HOME/.config/verdaccio/config.yaml &>$tmp_registry_log &"
# wait for `verdaccio` to boot
# FIXME: this throws a syntax error, but would be great to make it run
# grep -q 'http address' <(tail -f $tmp_registry_log)
# login so we can publish packages
sh -c "npm-auth-to-token -u leeroy -p ${{ secrets.VERDACCIO_PASS }} -e test@test.com -r $local_registry"
# Run nmp command
sh -c "npm publish --registry http://localhost:4873 $1"
