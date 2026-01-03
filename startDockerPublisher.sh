#!/bin/sh
set -euo pipefail

random_number=$(date +%s%N | cut -b1-10)
instance_name="ig-publisher-imaging-$random_number"

# Allow callers to override the docker image via PUBLISHER_IMAGE.
publisher_image="${PUBLISHER_IMAGE:-hl7fhir/ig-publisher-base:latest}"

# Apple Silicon needs to pull the amd64 variant of the publisher image.
docker_platform="${DOCKER_PLATFORM:-}"
if [ -z "$docker_platform" ]; then
    host_arch=$(uname -m)
    if [ "$host_arch" = "arm64" ] || [ "$host_arch" = "aarch64" ]; then
        docker_platform="--platform=linux/amd64"
    fi
fi

interactive_flags="${DOCKER_INTERACTIVE_FLAGS:-}"
if [ -z "$interactive_flags" ]; then
    if [ -t 0 ] && [ -t 1 ]; then
        interactive_flags="-it"
    fi
fi

repo_dir=$(pwd)
cache_mode="${PUBLISHER_FHIR_CACHE_MODE:-volume}"
if [ "$cache_mode" = "volume" ]; then
    cache_dir="${PUBLISHER_FHIR_CACHE_DIR:-$HOME/.fhir}"
    mkdir -p "$cache_dir"
    cache_mount=(-v "$cache_dir:/home/publisher/.fhir")
else
    cache_mount=(--tmpfs "/home/publisher/.fhir")
fi

java_tool_options="${PUBLISHER_JAVA_TOOL_OPTIONS:-${JAVA_TOOL_OPTIONS:-"-Xmx6g -Xms512m"}}"
publisher_command=${PUBLISHER_COMMAND:-"rm -rf temp template output && ./_updatePublisher.sh -y && ./_genonce.sh"}

docker_args=(--name "$instance_name" --rm)

if [ -n "$interactive_flags" ]; then
    docker_args+=("$interactive_flags")
fi

if [ -n "$docker_platform" ]; then
    docker_args+=("$docker_platform")
fi

docker_args+=(-v "$repo_dir:/home/publisher/ig")
docker_args+=("${cache_mount[@]}")
docker_args+=(-e "JAVA_TOOL_OPTIONS=$java_tool_options")

docker run \
    "${docker_args[@]}" \
    "$publisher_image" \
    bash -c "$publisher_command"
