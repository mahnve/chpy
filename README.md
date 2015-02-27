# chpy

Minimal chruby clone for Python. Source the script and use the commands below to install Pythons and change current versions.

Example:

```shell
chpy_install 2.6.9
chpy 2.6.9
```

Changes are made by manipulating PATH for the current session, changes
are not written to disk.

Currently, if you try to install a non-existent version of python,
curl will barf on you.
