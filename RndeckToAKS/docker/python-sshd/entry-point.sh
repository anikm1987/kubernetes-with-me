#!/bin/bash
#change user password
if [ ! -z "${RUNDECK_SERVER_USER_PWD}" ]; then
  echo 'rundeckWorker:${RUNDECK_SERVER_USER_PWD}' | chpasswd
else
  echo "Password reset failed"
  exit 1
fi

exec "$@"