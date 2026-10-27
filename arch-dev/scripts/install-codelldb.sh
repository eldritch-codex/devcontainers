#!/usr/bin/env bash
# Install the CodeLLDB debug adapter from an official, pinned upstream release.
# Editors that run on the host start it with `docker exec` or `devcontainer exec`
# and talk to it over stdio, so it lives at a fixed path in the image.

set -euo pipefail

codelldb_version="1.12.3"
codelldb_archive="codelldb-linux-x64.vsix"
codelldb_url="https://github.com/vadimcn/codelldb/releases/download/v${codelldb_version}/${codelldb_archive}"
codelldb_sha256="1cd7f386598022b51a5b93b9ffa23e812b23f519cfe1833384ec4bef4bfd1be1"

work_dir="$(mktemp -d)"
trap 'rm -rf "${work_dir}"' EXIT

curl --fail --location --retry 3 --silent --show-error \
    "${codelldb_url}" \
    --output "${work_dir}/${codelldb_archive}"

echo "${codelldb_sha256}  ${work_dir}/${codelldb_archive}" | sha256sum --check --status

# The .vsix is a zip archive whose payload is under extension/. Strip that
# directory so the adapter is at /opt/codelldb/adapter/codelldb.
install --directory /opt/codelldb
bsdtar --extract \
    --file "${work_dir}/${codelldb_archive}" \
    --directory /opt/codelldb \
    --strip-components=1 \
    extension

chmod --recursive a+rX /opt/codelldb
test -x /opt/codelldb/adapter/codelldb
