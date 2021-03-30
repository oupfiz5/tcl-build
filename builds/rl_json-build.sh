#!/bin/bash
. /builds/common.sh
. /builds/env-vars.sh

build_setup

package_directory=rl_json-${rl_json_version}

if [ ! -d /workspaces/${package_directory} ]; then
    cd /workspaces && sh /builds/rl_json-download.sh
    tar xvfz ${package_directory}.tar.gz
fi

mkdir -p /workspaces/logs
cd /workspaces/${package_directory} || exit 1
echo "Running the autoconf configure in /workspaces/${package_directory}"
echo "Building ${package_directory}"
> /workspaces/logs/${package_directory}.log
./configure --prefix=${prefix} \
     --with-tcl=${with_tcl} \
     --with-tclinclude=${with_tclinclude} 2>&1 | tee -a /workspaces/logs/${package_directory}.log
# cut down on the output to stdout to make Travis-CI consoles faster
make
make install 2>&1 | tee -a /workspaces/logs/${package_directory}.log

build_cleanup
