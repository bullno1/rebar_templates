#!/bin/sh
./shell.sh -eval "application:ensure_all_started({{appid}}),application:ensure_all_started(sync)" $*
