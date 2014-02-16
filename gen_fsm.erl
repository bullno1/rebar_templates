-module({{name}}).
-behaviour(gen_fsm).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3,
         terminate/3, code_change/4, format_status/2]).

-record(state, {
}).

% gen_fsm

init([]) ->	{ok, initial_state, #state{}}.

terminate(_Reason, _StateName, _State) -> ok.

handle_event(_Event, _StateName, StateData) ->
	{stop, unexpected, StateData}.

handle_sync_event(_Event, _From, _StateName, StateData) ->
	{stop, unexpected, StateData}.

handle_info(_Info, _StateName, StateData) ->
	{stop, unexpected, StateData}.

code_change(_OldVsn, StateName, StateData, _Extra) -> {ok, StateName, StateData}.

format_status(_Opt, [_PDict, State]) ->
	FormattedState = lists:zip(record_info(fields, state), tl(tuple_to_list(State))),
	[{data, [{"State", FormattedState}]}].
