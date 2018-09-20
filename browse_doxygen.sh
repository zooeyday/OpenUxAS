#! /bin/bash

set -x
HERE=$(cd `dirname $0`; pwd)
URL=$HERE/doc/doxygen/html/index.html
if [ "$(which xdg-open 2>/dev/null)" ]; then
	xdg-open $URL &
else
	open $URL &
fi
