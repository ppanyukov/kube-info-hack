#!/usr/bin/env bash
set -eu

# Cleans the build artifacts and caches.

# Dir of this script
declare ROOT_DIR=$(cd $(dirname ${BASH_SOURCE}) && pwd)

echo "Deleting build artifacts etc"
(
    set -x
    rm -rf ${ROOT_DIR}/bin
    rm -rf ${ROOT_DIR}/_built
    rm -rf ${ROOT_DIR}/pkg
    rm -rf ${ROOT_DIR}/.cache
)


echo "GREAT SUCCESS"
