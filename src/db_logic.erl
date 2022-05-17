-module(db_logic).
-include_lib("stdlib/include/qlc.hrl").
-record(user,{username,msg=" "}).
-export([initDB/0,storeDB/1,getDB/0,deleteDB/1]).


storeDB(Name) ->
	AF = fun()->
		mnesia:write(#user{username=Name})
	end,
	mnesia:transaction(AF).

getDB() ->
	AF = fun() ->
		Query = qlc:q([X || X <- mnesia:table(user),
		X#user.username =/= hardkodirano]),
		Results = qlc:e(Query),
		lists:map(fun(Item) -> Item#user.username end,Results)
	end,
	{atomic,Users} = mnesia:transaction(AF),
	Users.
	
deleteDB(Name) ->
	AF = fun() ->
		Query = qlc:q([ X || X <- mnesia:table(user),
		X#user.username =:= Name]),
	Results = qlc:e(Query),
	F = fun() ->
		lists:foreach(fun(Result) -> mnesia:delete_object(Result) end,Results)
		end,
		mnesia:transaction(F)
	end,
	mnesia:transaction(AF).
	

initDB() ->
	mnesia:create_schema([node()]),
	mnesia:start(),
	try
		mnesia:table_info(type,user)
	catch
		exit: _->
			mnesia:create_table(user,[{attributes,record_info(fields, user)},
			{type,bag},
			{disc_copies,[node()]}])
	end.


