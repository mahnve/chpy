# chpy

Minimal [chruby](https://github.com/postmodern/chruby) clone for Python. 

## Installation

Clone the repo or just download the `chpy.sh` script. Source it in your
`.bashrc`, `.zshrc` or whatever you use.

```shell
source <path to chpy.sh>
```

## Usage

Install Python version
```shell
chpy-install 2.6.9
```

Use Python version
```shell
chpy 2.6.9
```

Reset to system default Python: 

```shell
chpy reset
```

## How It Works 

Pythons are installed in ~/.pythons and include pip and virtualenv.

Python selection is made by manipulating PATH for the current session only,
changes to PATH are not written to disk - when you start a new terminal you're
path is back to normal.

## How To Use In Development

For development with a specific Python version

```shell 
cd <project_dir>
chpy <version>
virtualenv venv
```

This will setup a virtualenv for the desired Python version. You can then either
source it manually or from your build tool of choice.

## FAQ

### Build breaks with something like "ssl module in Python is not available."

Make sure you have SSL sources available, otherwise Python won't be compiled
with SSL support, and then the pip install fails. 
