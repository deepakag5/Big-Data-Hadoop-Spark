#!/bin/bash

CURR_DIR="$(dirname "$0")"

python  "${CURR_DIR}/yarn_ec2.py" "$@"