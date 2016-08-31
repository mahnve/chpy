#!/usr/bin/env bash

function _chpy_bin_path {
    echo "${PYTHONS_DIR}/${CURRENT_CHPY_VERSION}/bin"
}

function _reset_path {
    PATH=${PATH/"$(_chpy_bin_path)":\///}
    export PATH
    rm ${CURRENT_CHPY_FILE} -f
}

function _default_setup {
    PYTHONS_DIR="${HOME}/.pythons"
    mkdir -p "${PYTHONS_DIR}"/chpy
    CURRENT_CHPY_FILE=${HOME}/.pythons/chpy/current
}

function chpy {
    _default_setup
    CHPY_ARG=$1
    if [[ ${CHPY_ARG} == "reset" ]]
    then
        _reset_path
        echo "Python reset to system default"
        _current_python
        return 0
    fi
    if [[ "${CHPY_ARG}" != "" && $(_installed_pythons) =~ ${CHPY_ARG} ]]
    then
        # If we already have set a custom python, unset PATH before setting it again
        if [ -e "${CURRENT_CHPY_FILE}" ]
        then
            _reset_path
        fi
        CURRENT_CHPY_VERSION="${CHPY_ARG}"
        echo "${CURRENT_CHPY_VERSION}" > "$CURRENT_CHPY_FILE"
        PATH=$(_chpy_bin_path):${PATH}
        export PATH
        _current_python
        return 0
    else
        echo "Unavailable Python"
        echo "Format: chpy <python-version|reset>"
        echo "Available Python versions:"
        echo "$(_installed_pythons)"
        _current_python
        echo "You can install more Pythons with chpy-install"
        return 1
    fi
}

function _installed_pythons {
    find "${PYTHONS_DIR}" -maxdepth 1 -type d  | sed 's/.*pythons\///g' |  grep '[0-9].[0-9].[0-9]' | sort
}

function _current_python {
    echo "Current Python is $(which python)"
}

function chpy-install {

    VERSION=$1
    PYTHONS_DIR=~/.pythons
    CURRENT_DIR=$(pwd)
    DOWNLOAD_URL="https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz"
    if [[ "${VERSION}" == "" ]]
    then
        echo "Please provide a Python version to install, for example 2.7.12"
        return 1
    else
        TEST=$(curl -s --head "${DOWNLOAD_URL}")
        if [[ "${TEST}" =~ 200\\sOK || "${TEST}" =~ HTTP\\/1\\.1\\s200\\sOK ]]
        then
            # Download Python version
            curl -o "/tmp/python-${VERSION}.tgz" "https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz"

            # Install Python
            tar -xvzf "/tmp/python-${VERSION}.tgz" -C /tmp
            cd "/tmp/Python-${VERSION}/" || exit
            ./configure --prefix "${PYTHONS_DIR}/${VERSION}"
            make
            make install
            cd "${CURRENT_DIR}" || exit

            # Install Pip
            curl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
            "${PYTHONS_DIR}/${VERSION}"/bin/python /tmp/get-pip.py

            # Install virtualenv
            "${PYTHONS_DIR}/${VERSION}"/bin/pip install virtualenv
            return 0
        else
            echo "Unavailable Python version"
            return 2
        fi
    fi
}
