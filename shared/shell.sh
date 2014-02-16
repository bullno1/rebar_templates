#!/bin/sh
make
APPDIR=`dirname "$(readlink -f "$0")"`
if [[ $? == 0 ]]; then
	erl +K true \
	    -pa $APPDIR/ebin $APPDIR/deps/*/ebin \
        -boot start_sasl $*
fi
