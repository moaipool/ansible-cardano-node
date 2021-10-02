#!/bin/sh
SIGNAL=${SIGNAL:-TERM}
PIDS=$(ps ax | grep -i 'cardano-node' | grep -v grep | awk '{print $1}')

if [ -z "$PIDS" ]; then
  echo "No Cardano node to stop"
  exit 1
else
  kill -s $SIGNAL $PIDS
fi
