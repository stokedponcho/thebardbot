#!/usr/bin/env bash

env="${2:-prod}"
app_name="$(mix app.name | tr '\r\n' ' ' | xargs)"
app_version="$(mix app.version | tr '\r\n' ' ' | xargs)"
target="$app_name:$app_version"
archive="${target/:/-}.tar"
tarball="$archive.gz"
ansible="$(pwd)/rel/ansible"

main() {
  parameters="./release.parameters.sh"
  [[ -f "$parameters" ]] && . "$parameters" && echo "Sourced $parameters."
	eval $1
}

build() {
  [[ -f "$tar" ]] && rm "$archive"
  [[ -f "$tarball" ]] && rm "$tarball"

	podman build \
        --build-arg ENV="$env" \
        --build-arg API_AUTH_HEADER="$THEBARDBOT_SLACK_AUTH_HEADER" \
        --build-arg API_TOKEN="$THEBARDBOT_SLACK_TOKEN" \
        -t $target .
  podman image save -o "$archive" "$target"
  gzip "$archive"
}

setup() {
	export APP_PORT=4000
	export APP_NAME="$app_name"
	export APP_VERSION="$app_version"
	export APP_TARBALL="$tarball"
	export ANSIBLE_CONFIG="$ansible/ansible.cfg"

	ansible-playbook "$ansible/tasks/setup.yml" --ask-become-pass
}

deploy() {
	export APP_PORT=4000
	export APP_NAME="$app_name"
	export APP_VERSION="$app_version"
	export APP_TARBALL="$tarball"
	export APP_ARCHIVE="$archive"
	export ANSIBLE_CONFIG="$ansible/ansible.cfg"
	export APP_LOCAL_RELEASE_PATH="$(pwd)"

	ansible-playbook "$ansible/tasks/deploy.yml" --ask-become-pass
}

main $@

# to load container:
# gzip -d the_bard_bot-0.1.0.tar.gz
# podman load -i the_bard_bot-0.1.0.tar
