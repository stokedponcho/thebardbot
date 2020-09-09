# TheBardBot - Release

## Podman issues

```
# namespace error when loading image,
# following might help
# https://github.com/containers/podman/issues/4921

dnf reinstall -y shadow-utils
getfattr -d -m '.*' /usr/bin/newuidmap /usr/bin/newgidmap
```
