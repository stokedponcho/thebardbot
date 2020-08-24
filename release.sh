#!/usr/bin/env bash

env="prod"
target="$(toolbox --container elixir run mix app | tr '\r\n' ' ' | xargs)"
archive="${target/:/-}.tar"
tarball="$archive.gz"

main() {
	eval $1 "$2"
}

build() {
	[[ -f $tar ]] && rm $archive
	[[ -f $tarball ]] && rm $tarball

	podman build --build-arg ENV=$env -t $target .
	podman image save -o $archive $target
	gzip $archive
}

setup() {
	export APP_PORT=4000
	export APP_NAME="$(toolbox --container elixir run mix app.name | tr '\r\n' ' ' | xargs)"
	export APP_VERSION="$(toolbox --container elixir run mix app.version | tr '\r\n' ' ' | xargs)"
	export APP_TARBALL=$tarball
	export ANSIBLE_CONFIG="$(pwd)/deploy/ansible/ansible.cfg"
	ansible-playbook "$(pwd)/deploy/ansible/tasks/setup.yml" --ask-become-pass
}

deploy() {
	export APP_PORT=4000
	export APP_NAME="$(toolbox --container elixir run mix app.name | tr '\r\n' ' ' | xargs)"
	export APP_VERSION="$(toolbox --container elixir run mix app.version | tr '\r\n' ' ' | xargs)"
	export APP_TARBALL=$tarball
	export APP_ARCHIVE=$archive
	export ANSIBLE_CONFIG="$(pwd)/deploy/ansible/ansible.cfg"
	export APP_LOCAL_RELEASE_PATH="$(pwd)"
	ansible-playbook "$(pwd)/deploy/ansible/tasks/deploy.yml" --ask-become-pass
}

main $@

# to load container:
# gzip -d the_bard_bot-0.1.0.tar.gz
# podman load -i the_bard_bot-0.1.0.tar
