#!/bin/bash
# run.sh : code_swarm launching script
# need the config file as first parameter

params=$@
default_config="data/sample.config"
code_swarm_jar="dist/code_swarm.jar"

# command line parameters basic check
if [ $# = 0 ]; then
    # asking user for a config file
    echo "code_swarm project !"
    echo -n "Specify a config file, or ENTER for default one [$default_config] : "
    read config
    if [ ${#config} = 0 ]; then
        params=$default_config
    else
        params=$config
    fi
else
    if [ $1 == "-h" ] || [ $1 == "--help" ]; then
        # if help needed, print it and exit
        echo "usage: run.sh <configfile>"
        echo ""
        echo "   data/sample.config  is the default config file"
        echo ""
        exit
    else
        echo "code_swarm project !"
    fi
fi

# checking for code_swarm java binaries
if [ ! -f $code_swarm_jar ]; then
    echo "no code_swarm binaries !"
    echo "needing to build it with 'ant' and 'javac' (java-sdk)"
    echo ""
    echo "auto-trying the ant command..."
    if ant; then
        echo ""
    else
        echo ""
        echo "ERROR, please verify 'ant' and 'java-sdk' installation"
        echo -n "press a key to exit"
        read key
        echo "bye"
        exit
    fi
fi

CLASSPATH_COMMON=dist/code_swarm.jar:lib/gluegen-rt.jar:lib/jogl.jar:lib/core.jar:lib/opengl.jar:lib/xml.jar:lib/vecmath.jar
CS_CLASSPATH=
CS_LIBPATH=

platform=$(uname)
if [ "${platform}" == "Linux" ]; then
    CS_CLASSPATH=${CLASSPATH_COMMON}:lib/jogl-natives-linux-i586.jar:.
    CS_LIBPATH=lib/linux-x86_64
elif [ "${platform}" == "Darwin" ]; then
    CS_CLASSPATH=${CLASSPATH_COMMON}:lib/jogl-natives-macosx-universal.jar:.
    CS_LIBPATH=lib
fi

# running
if java -Xmx1000m -classpath ${CS_CLASSPATH} -Djava.library.path=${CS_LIBPATH} code_swarm $params; then
    # always on error due to no "exit buton" on rendering window
    echo "bye"
    #    echo -n "error, press a key to exit"
    #    read key
else
    echo "bye"
fi


