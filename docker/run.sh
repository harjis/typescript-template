#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker build -t test-container "${__dir}/../" && \
  docker run -e MY_ENV_VAR="cat" -it test-container