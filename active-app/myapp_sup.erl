-module({{appid}}_sup).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	%{Name, {Module, StartFunc, Args}, permanent, 5000, supervisor, [Module]}
	ChildSpecs = [
	],
	{ok, { {one_for_one, 5, 60}, ChildSpecs}}.
