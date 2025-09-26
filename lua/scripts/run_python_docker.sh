#!/usr/bin/env bash
set -euo pipefail

container_args=()

for arg in "$@"; do
    case "$arg" in
        /Users/med/Documents/Work/RB/domainprospector/webapp/*)
            container_path="${arg#/Users/med/Documents/Work/RB/domainprospector/webapp/}"
            container_args+=("$container_path")
            ;;
        *)
            container_args+=("$arg")
            ;;
    esac
done

docker exec -i domainprospector.webapp \
  python -m pytest "${container_args[@]}"
