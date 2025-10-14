#!/bin/bash

set -euo pipefail

TMP_DIR=$(mktemp -d)
function cleanup {
    rm -rf "${TMP_DIR}"
}
trap cleanup EXIT
trap cleanup SIGINT

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "${SCRIPT_DIR}"

test -d "${NONPKGER_DIR}"
TMP_FILE="${TMP_DIR}/update.sh"
NONPKGER_TAG="nonpkger"

docker buildx build --pull --tag "${NONPKGER_TAG}:latest" - <<EOF
FROM ubuntu

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release unzip
EOF

# TODO: Split out invoke.bash
cat >"${TMP_FILE}" <<EOF
#!/bin/bash

set -euo pipefail


EOF
cat ./invoke.bash >>"${TMP_FILE}"

chmod +x "${TMP_FILE}"

docker run --interactive --tty --rm --volume "${TMP_FILE}:/update.sh" --volume "${NONPKGER_DIR}:/nonpkger" "${NONPKGER_TAG}:latest" "/update.sh"
