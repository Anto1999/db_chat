-module(chat_system).

-behaviour(application).

-export([start/2,start/0,stop/0,stop/1]).

start() ->
	simple_chat_supervisor:start_link().

start(_Type,_Args) ->
	simple_chat_supervisor:start_link().

stop() ->
	application:stop(?MODULE).
stop(_State) ->
	ok.