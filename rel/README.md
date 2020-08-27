```
ansible web -m ping --user <user> --private-key <path/to/private/key>
```

```
# namespace error when loading image,
# following might help
# https://github.com/containers/podman/issues/4921

dnf reinstall -y shadow-utils
getfattr -d -m '.*' /usr/bin/newuidmap /usr/bin/newgidmap
```
