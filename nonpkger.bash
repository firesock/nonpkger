#!/bin/bash

set -euo pipefail

TMP_DIR=$(mktemp --directory)
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
readarray -t PATHS_LIST < ./paths.txt
NONPKGER_INTERNAL_PREINSTALL_DIR="/nonpkger-preinstall"

docker buildx build --pull --tag "${NONPKGER_TAG}:latest" - <<EOF
FROM ubuntu

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release unzip wget && mkdir ${NONPKGER_INTERNAL_PREINSTALL_DIR}

WORKDIR /nonpkger-work
EOF

cat >"${TMP_FILE}" <<EOF
#!/bin/bash

set -euo pipefail

#-- invoke.bash

EOF
cat ./invoke.bash >>"${TMP_FILE}"
cat >>"${TMP_FILE}" <<EOF

#-- invoke.bash END

cp --recursive --target-directory=${NONPKGER_INTERNAL_PREINSTALL_DIR} ${PATHS_LIST[@]}
rm --recursive /nonpkger/* && install --preserve-timestamps --target-directory=/nonpkger ${NONPKGER_INTERNAL_PREINSTALL_DIR}/*
EOF

chmod +x "${TMP_FILE}"

docker run --interactive --tty --rm \
       --volume "${TMP_FILE}:/update.sh" \
       --volume "${NONPKGER_DIR}:/nonpkger" \
       "${NONPKGER_TAG}:latest" "/update.sh"
