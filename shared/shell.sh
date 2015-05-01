#!/bin/sh
APPDIR=`dirname "$(readlink -f "$0")"`
make &&
erl +K true \
    +W w \
    -config sys.config \
    -pa $APPDIR/ebin $APPDIR/deps/*/ebin \
    -boot start_sasl $*
