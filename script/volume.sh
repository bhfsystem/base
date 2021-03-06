#!/usr/bin/env bash

function main {
  set -exfu

  apt-get update -y
  apt-get install -y zfsutils-linux

  lvreduce -f -L 1M inception/placeholder
  lvcreate -l '50%FREE' -n lxd inception
}

main "$@"
