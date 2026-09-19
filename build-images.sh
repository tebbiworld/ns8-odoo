#!/bin/bash

#
# Copyright (C) 2026 tebbi
# SPDX-License-Identifier: GPL-3.0-or-later
#

set -e

images=()
repobase="${REPOBASE:-ghcr.io/tebbiworld}"
reponame="odoo"

# Runtime images, declared in org.nethserver.images so the node pre-pulls them
# and exposes their references to the units as ${ODOO_IMAGE} / ${POSTGRES_IMAGE}.
# Both references are fully pinned (no rolling tag): Odoo publishes dated builds
# of the 19.0 branch, and the auto-release workflow bumps the Odoo reference
# when a newer dated 19.0 tag appears. PostgreSQL stays on the 16 series (the
# data directory is only compatible within one major) and is bumped by hand.
odoo_image="docker.io/library/odoo:19.0-20260908"
postgres_image="docker.io/library/postgres:16.14"

container=$(buildah from scratch)

if ! buildah containers --format "{{.ContainerName}}" | grep -q nodebuilder-odoo; then
    echo "Pulling NodeJS runtime..."
    buildah from --name nodebuilder-odoo -v "${PWD}:/usr/src:Z" docker.io/library/node:24.16.0-slim
fi

echo "Build static UI files with node..."
buildah run \
    --workingdir=/usr/src/ui \
    --env="NODE_OPTIONS=--openssl-legacy-provider" \
    nodebuilder-odoo \
    sh -c "yarn install && yarn build"

buildah add "${container}" imageroot /imageroot
buildah add "${container}" ui/dist /ui
# One TCP port (Odoo HTTP, published on the node loopback for Traefik); the
# routeadm authorization to publish/remove the Traefik route; rootless.
buildah config --entrypoint=/ \
    --label="org.nethserver.authorizations=traefik@node:routeadm" \
    --label="org.nethserver.tcp-ports-demand=1" \
    --label="org.nethserver.rootfull=0" \
    --label="org.nethserver.images=${odoo_image} ${postgres_image}" \
    "${container}"
buildah commit "${container}" "${repobase}/${reponame}"

images+=("${repobase}/${reponame}")

if [[ -n "${CI}" ]]; then
    printf "images=%s\n" "${images[*],,}" >> "${GITHUB_OUTPUT}"
else
    printf "Publish the images with:\n\n"
    for image in "${images[@],,}"; do printf "  buildah push %s docker://%s:%s\n" "${image}" "${image}" "${IMAGETAG:-latest}" ; done
    printf "\n"
fi
