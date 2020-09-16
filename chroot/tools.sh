#!/bin/bash
set -e

pushd /sources/script/tools

bash libstd.sh
bash gettext.sh
bash bison.sh
bash perl.sh
bash python.sh
bash texinfo.sh
bash util-linux.sh

popd
