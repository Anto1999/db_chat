-module(simple_chat_client).
-behaviour(gen_server).
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([start/0,stop/0,subscribe/1,start_link/0,unsubscribe/1,crash/0,send/2]).

start() ->
	simple_chat_server:start_link().

stop() ->
	simple_chat_server:stop().

start_link()->
	gen_server:start_link({global,?MODULE},?MODULE,[],[]).

subscribe(Name) ->
	gen_server:call({global,simple_chat_server},{subscribe,Name}).
unsubscribe(Name) ->
	gen_server:call({global,simple_chat_server},{unsubscribe,Name}).

send(Username,Message) ->
	gen_server:call({global,simple_chat_server},{send,Username,Message}).

crash() ->
	gen_server:call({global,simple_chat_server},{crash}).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init([]) ->
	process_flag(trap_exit,true),
	io:format("Starting chat client... ~n"),
	{ok,[]}.


handle_call(_Req,_From,State) ->
	{reply,ok,State}.

	
handle_cast({message,Msg,Username},State) ->
	io:format("~p: ~p.~n",[Username,Msg]),
	{noreply,State};


handle_cast(_Req,State) ->
	{noreply,State}.

handle_info(Info,State) ->
	{noreply,Info,State}.

terminate(_reason,_state) ->
	io:format("Terminating ~p~n",[{local,?MODULE}]),
	ok.

code_change(_OldVsn,State,_Extra) ->
	{ok,State}.