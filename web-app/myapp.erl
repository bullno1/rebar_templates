-module({{appid}}).
-behaviour(application).
-export([start/2, stop/1]).
-export(['$on_reload'/0]).

start(_StartType, _StartArgs) ->
	Dispatch = cowboy_router:compile([
		{'_', routes()}
	]),
	Port = application:get_env({{appid}}, port, 8080),
	cowboy:start_http({{appid}}, 100, [{port, Port}], [{env, [{dispatch, Dispatch}]}]),
	{{appid}}_sup:start_link().

stop(_State) ->
	ok.

routes() ->
	[
	 {"/", cowboy_static, {priv_file, {{appid}}, "www/index.html"}},
	 {"/[...]", cowboy_static, {priv_dir, {{appid}}, "www"}}
	].

'$on_reload'() ->
	Routes = routes(),
	cowboy:set_env({{appid}}, dispatch, cowboy_router:compile([{'_', Routes}])),
	error_logger:info_report([{new_routes, Routes}]).
