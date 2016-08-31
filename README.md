# chpy

Minimal [chruby](https://github.com/postmodern/chruby) clone for Python. Source the script and use the commands below to install Pythons and change current versions.

Example:

```shell
chpy-install 2.6.9
chpy 2.6.9
```

To reset to system default: 

```shell
chpy reset
```

Pythons are installed in ~/.pythons and include pip and virtualenv.

Changes are made by manipulating PATH for the current session only, changes
to PATH are not written to disk.

For development with a specific Python version

```shell 
cd <project_dir>
chpy <version>
virtualenv venv
```

This will setup a virtualenv for the desired Python version. You can then either
source it manually or from your build tool of choice.

This can be used in Makefiles like:

```Makefile
VENV_DIR=venv
VENV_INSTALLED=${VENV_DIR}/bin/python
${VENV_INSTALLED:
    virtualenv ${VENV_DIR}

somepythonthing: ${VENV_INSTALLED}
    ${VENV_DIR}/bin/python ... 
``` 

