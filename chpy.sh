#!/usr/bin/env bash


function chpy_bin_path {
    echo "${PYTHONS_DIR}/${CURRENT_CHPY_VERSION}/bin"
}

function chpy {
    PYTHONS_DIR="${HOME}/.pythons"
    INSTALLED_PYTHONS=$(find ${PYTHONS_DIR} -maxdepth 1 -type d  | sed 's/.*pythons\///g' |  grep '[0-9].[0-9].[0-9]')
    NEW_CHPY_VERSION=$1
    if [[ ${INSTALLED_PYTHONS} =~ ${NEW_CHPY_VERSION} ]]
    then
        mkdir -p ${PYTHONS_DIR}/chpy
        CURRENT_CHPY_FILE=${HOME}/.pythons/chpy/current

        if [ -e ${CURRENT_CHPY_FILE} ]
        then
            CURRENT_CHPY_VERSION=$(cat ${CURRENT_CHPY_FILE})
            PATH=$(echo $PATH | sed 's^'$(chpy_bin_path):'^^g')
        fi

        CURRENT_CHPY_VERSION="${NEW_CHPY_VERSION}"
        echo "${CURRENT_CHPY_VERSION}" > "$CURRENT_CHPY_FILE"
        export PATH=$(chpy_bin_path):${PATH}
        print_current_python
    else
        echo "Python ${NEW_CHPY_VERSION} is not installed"
        print_current_python
    fi
}

function print_current_python {
    echo "Current Python is $(which python)"
}

function chpy_install {

    VERSION=$1
    PYTHONS_DIR=~/.pythons
    CURRENT_DIR=$(pwd)

    # Download Python version
    curl -o /tmp/python-${VERSION}.tgz https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz

    # Install Python
    tar -xvzf /tmp/python-${VERSION}.tgz -C /tmp
    cd /tmp/Python-${VERSION}/
    ./configure --prefix ${PYTHONS_DIR}/${VERSION}
    make
    make install
    cd ${CURRENT_DIR}

    # Install Pip
    curl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
    ${PYTHONS_DIR}/${VERSION}/bin/python /tmp/get-pip.py

    # Install virtualenv
    ${PYTHONS_DIR}/${VERSION}/bin/pip install virtualenv
}
