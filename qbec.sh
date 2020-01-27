#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
set -o errtrace

: ${KEY_PATH:=/gpg-secret/key.asc}

gpg --import "${KEY_PATH}"

cmd=()
for arg in "$@"; do
  printf -v quoted "%q" "${arg}"
  cmd+=("${quoted}")
done

sops exec-file secrets.yaml "qbec --vm:ext-str-file secrets={} ${cmd[*]}"
