#!/usr/bin/env bash

if [[ ! $1 ]]; then
  FILTER="-"
else
  FILTER="${1}"
fi

clean(){
  pkill -f ingress-nginx
}

clean

while read pod; do
  rm -f ingress-$pod.log
  # the grep argument is usally the name of the backend service that will receive the traffic.
  # but it can be any string to be tested on every log line.
  kubectl -n ingress-nginx logs -f $pod | grep "${FILTER}" > ingress-$pod.log &
done < <(kubectl -n ingress-nginx get pods | grep nginx | awk "{print \$1}")

tail -f ingress-*.log | ./formater.rb | ./logstalgia -

clean
