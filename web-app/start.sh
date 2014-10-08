#!/bin/sh
./shell.sh -eval "application:ensure_all_started({{appid}},permanent),application:ensure_all_started(cowboy_reload),application:ensure_all_started(revolver)" $*
