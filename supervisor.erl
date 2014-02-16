-module({{name}}).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

% supervisor

init([]) ->
	%{Name, {Module, StartFunc, Args}, permanent, 5000, supervisor, [Module]}
	ChildSpecs = [
	],
	{ok, { {one_for_one, 5, 60}, ChildSpecs}}.
