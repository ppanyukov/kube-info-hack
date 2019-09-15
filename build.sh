#!/usr/bin/env bash
set -eu

# Builds golang applications using local toolchain or docker.
# For production use docker, it produces Linux ELF.
# This is what's required to deploy to kubernetes.
#
# Local:
#   ./build.sh
# Docker
#   USE_DOCKER=yes ./build.sh


# Dir of this script
declare ROOT_DIR=$(cd $(dirname ${BASH_SOURCE}) && pwd)

# Image to use to build the app in Docker
declare GO_IMAGE="golang:1.13.0-stretch"

# Packages to build, test, etc
declare GO_PACKAGES="app"


# Go command will differ depending if we build in Docker or locally.
declare USE_DOCKER=${USE_DOCKER:=""}
if test "${USE_DOCKER}"
then
    # Start this script in docker container.
    # Make sure we only attach TTY if we have it
    declare TTY_FLAG=""
    if [ -t 1 ]
    then
        TTY_FLAG="-t"
    fi
    
    echo "go will be run in docker container ${GO_IMAGE}"
    (
        set -x
        docker run \
                -i \
                ${TTY_FLAG} \
                --rm \
                -v ${ROOT_DIR}:${ROOT_DIR} \
                -e GOPATH=${ROOT_DIR} \
                -e GOCACHE=${ROOT_DIR}/.cache/go-build \
                ${GO_IMAGE} \
                ${ROOT_DIR}/build.sh
    )

    exit 0
else
    export GOPATH=${ROOT_DIR}
    export GOCACHE=${ROOT_DIR}/.cache/go-build
    declare GO="go"
fi

(
    set -x
    cd ${ROOT_DIR}
)

echo "go fmt..."
(
    set -x
    ${GO} fmt ${GO_PACKAGES}
)

echo "go vet..."
(
    set -x
    ${GO} vet ${GO_PACKAGES}
)

echo "go test...."
(
    set -x
    ${GO} test ${GO_PACKAGES}
)

echo "go install..."
(
    set -x
    ${GO} install ${GO_PACKAGES}
)


# Copy results of the build into dedicated dir
declare BUILT_DIR=${ROOT_DIR}/_built/
echo "Copying results of the build to ${BUILT_DIR}"
(
    rm -rf ${BUILT_DIR}
    mkdir -p ${BUILT_DIR}
    cp -r ${ROOT_DIR}/bin ${BUILT_DIR}
)


echo "GREAT SUCCESS"
