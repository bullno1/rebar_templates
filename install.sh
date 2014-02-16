#!/bin/sh
PROJDIR=`dirname "$(readlink -f "$0")"`
LINK_NAME=~/.rebar/templates/bullno1-templates
mkdir -p ~/.rebar/templates
if [[ -e $LINK_NAME ]]; then
	echo "$LINK_NAME already exists"
	exit 1
fi
ln -s $PROJDIR $LINK_NAME
