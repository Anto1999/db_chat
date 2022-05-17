-module(simple_chat_server).
-behaviour(gen_server).
-record(state,{}).
-export([start_link/0,stop/0,getdb/0]).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).


start_link()->
	gen_server:start_link({global,?MODULE},?MODULE,[],[]).

stop()->
	gen_server:cast({global,?MODULE},stop).

getdb() ->
	gen_server:call({global,?MODULE},{getDB}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init([]) ->
	process_flag(trap_exit,true),
	io:format("Starting chat server... ~n"),
	db_logic:initDB(),
	{ok,#state{}}.

handle_call({crash},_From,State) ->
	5=4,
	{reply,nok,State};

handle_call({subscribe,Username},_From,State) ->

	Accounts = db_logic:getDB(),
	case lists:member(Username,Accounts) of
			true ->
				io:format("User: ~p is alrdy subscribed. ~n", [Username]),
				{reply,ok,State};
			false ->
				db_logic:storeDB(Username),
				io:format("User: ~p is subscribed now. ~n",[Username]),
				{reply,ok,State}
		end;
		
handle_call({getDB},_From,State) ->
	Users = db_logic:getDB(),
	io:format("Subscribed users: ~p.~n",[Users]),
	{reply,ok,State};

handle_call({unsubscribe,Username},_From,State) ->
	Accounts = db_logic:getDB(),
	case lists:member(Username,Accounts) of
			true ->
				db_logic:deleteDB(Username),
				io:format("User: ~p is unsubscribed now. ~n", [Username]),
				{reply,ok,State};
			false ->
				io:format("User: ~p is not subscribed. ~n",[Username]),
				{reply,ok,State}
		end;

handle_call({send,Username,Msg},_From, State)->
		Accounts = db_logic:getDB(),
		case lists:member(Username,Accounts) of
			true ->
				lists:foreach(fun(_User) -> gen_server:cast({global,simple_chat_client},{message,Msg,Username}) end,Accounts),
				{reply,ok,State};
			false ->
				io:format("User: ~p is not subscribed. ~n",[Username]),
				{reply,ok,State}
		end;

handle_call(_Req,_From,State) ->
	{reply,ok,State}.

handle_cast(_Req,State) ->
	{noreply,State}.

handle_info(Info,State) ->
	{noreply,Info,State}.

terminate(_reason,_state) ->
	io:format("Terminating ~p~n",[{local,?MODULE}]),
	ok.

code_change(_OldVsn,State,_Extra) ->
	{ok,State}.
	