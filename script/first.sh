#!/usr/bin/env bash

function main {
  set -exfu

  if ! systemctl >/dev/null; then
    return 0
  fi

  if ! test -d /var/lib/cloud/instance/.; then
    return 0
  fi

  tail -f /var/log/cloud-init-output.log &

  set +x
	while true; do 
    case "$(systemctl is-active cloud-final.service)" in
      active|failed) 
          systemctl is-active cloud-final.service
          pkill tail
          wait
          reboot
          sleep 120
          exit 0
        ;;
    esac
    sleep 1
  done
}

main "$@"
