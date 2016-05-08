#!/usr/bin/env bash

RUNNING=false

function loop {
  while $RUNNING
  do sleep 1
  done
}

function start {
  /etc/init.d/nginx start
  /etc/init.d/cron start
  sudo -u minecraft msm world start

  for LOGIN in `cat /data/users`
  do
    sudo -u minecraft msm world wl add $LOGIN
  done

  RUNNING=true
  loop
}

function stop {
  sudo -u minecraft msm world stop
  /etc/init.d/cron stop
  /etc/init.d/nginx stop
  RUNNING=false
}


#recive docker sigterm to do the cleanup
trap stop SIGTERM

#starting all processes
start
