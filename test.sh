#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

WORKDIR="$SCRIPT_PATH"/workdir

# prepare test samples
mkdir -p "$WORKDIR"
cp -a "$SCRIPT_PATH"/test_samples/* "$WORKDIR"

# run Ansible tests
ansible-playbook -i 127.0.0.1, -e workdir="$WORKDIR" test.yml

# verify tests output
for FILE in "$WORKDIR"/*.ini; do
  echo -n "Checking $FILE: "
  if ! diff -u "$FILE.exp" "$FILE"; then
    echo FAILED
    exit 1
  fi
  echo PASS
done
