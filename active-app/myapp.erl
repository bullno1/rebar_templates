-module({{appid}}).
-behaviour(application).
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
	{{appid}}_sup:start_link().

stop(_State) ->
	ok.
