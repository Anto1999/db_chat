{application, chat_system,[
	{description,"Simple_chat"},
	{vsn,"1"},
	{modules,[simple_chat_client,simple_chat_server,simple_chat_supervisor,chat_system,db_logic]},
	{registered,[]},
	{applications,[kernel,stdlib]},
	{mod, {chat_system,[]}},
	{env,[]}
]}.