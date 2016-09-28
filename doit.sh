#!/bin/busybox sh

CONSUL_KEY=${CONSUL_KEY:-sshauthorizedkeys}
authorizedkeys=${AUTHORIZED_KEYS:-/root/.ssh/authorized_keys}
CONSUL_ENDPOINT=${CONSUL_ENDPOINT:-127.0.0.1}
CONSUL_PORT=${CONSUL_PORT:-8500}
consul="consul watch -http-addr=$CONSUL_ENDPOINT:$CONSUL_PORT -key=$CONSUL_KEY -type=key "

if [ ! -f "$authorizedkeys" ]
then
  echo no authorized keys file found at "$authorizedkeys"
  exit 1
fi

if [ -z "$CONSUL_INDEX" ]
then
  echo $(date) looking for changes at $CONSUL_ENDPOINT:$CONSUL_PORT $CONSUL_KEY. when I find them I am going to put them at $authorizedkeys
  echo $(date) note. the first line needs to be: $(cat "$authorizedkeys"|head -n1)
  exec $consul /doit.sh
else
  echo $date $CONSUL_INDEX
fi

newval=$($consul|grep Value)
newval=${newval##* \"}
newval=${newval%\"*}
newval=$(echo -n "$newval"|base64 -d)

musthave=$(cat "$authorizedkeys"|head -n1)
if echo "$newval"|grep -q "$musthave"
then
  echo "$(date) replacing $authorizedkeys with:\n$newval"
  echo "$newval" > "$authorizedkeys"
fi
