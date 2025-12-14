#!/bin/bash

if pgrep -x qs >/dev/null; then
  pkill -USR1 qs
else
  qs &
fi
