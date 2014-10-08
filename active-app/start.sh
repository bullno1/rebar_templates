#!/bin/sh
./shell.sh -eval "application:ensure_all_started({{appid}},permanent)" $*
