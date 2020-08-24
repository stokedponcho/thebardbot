```
ansible web -m ping --user <user> --private-key <path/to/private/key>

ansible web --user <user> --private-key <path/to/private/key> --become --become-method su --ask-become-pass
```
