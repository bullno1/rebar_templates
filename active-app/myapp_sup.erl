-module({{appid}}_sup).
-behaviour(esupervisor).
-include_lib("esupervisor/include/esupervisor.hrl").

-export([init/1]).
-export([start_link/0]).

start_link() ->
    esupervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	#one_for_one {
		id = {{appid}}_sup,
		children = []
	}.
