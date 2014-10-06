-module({{name}}).
-behaviour(gen_event).
-export([init/1, handle_event/2, handle_call/2, handle_info/2, terminate/2,
         code_change/3, format_status/2]).

-record(state, {}).

% gen_event
init([]) -> {ok, #state{}}.

terminate(_Reason, _State) -> ok.

handle_event(_Event, State) -> {ok, State}.

handle_call(_Req, State) -> {ok, undefined, State}.

handle_info(_Msg, State) -> {ok, State}.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

format_status(_Opt, [_PDict, State]) ->
	FormattedState = lists:zip(record_info(fields, state), tl(tuple_to_list(State))),
	[{data, [{"State", FormattedState}]}].
