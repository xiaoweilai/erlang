%% �ļ���дʾ��

-module(file_example).

-export([write/2, read/1, readNewFileNameInFile/1]).

%% -*- coding: utf-8 -*-
%% -*- coding: latin-1 -*-

%% --------------------
%% д���ļ�
%% write(Content, FileName) -> {ok, Content}
%% Content = string()
%% FileName = string()
%% --------------------
write(Content, FileName) when is_list(Content); is_list(FileName) ->
    FileAbsolutePath = lists:append([get_local_path(), "/", FileName]),
    {ok, IoDevice} = file:open(FileAbsolutePath, [append]),
    io:format(IoDevice, "~s", [Content]),
    file:close(IoDevice),
    {ok, Content}.

%% --------------------
%% ��ȡ�ļ�
%% read(FileName) -> binary()
%% FileName = string()
%% --------------------
read(FileName) when is_list(FileName) ->
    {ok, Content} = file:read_file(FileName),
    Content.

%% --------------------
%% ��ȡ�����ļ��������ݶ�Ӧ���ļ�
%% read(FileName) -> IOText()
%% Get NewFileName = string()
%% --------------------
readNewFileNameInFile(FileName) when is_list(FileName) ->
	{ok, F} = file:open(FileName,read),
	%%��ȡcode2.spec�е��ļ���
	{ok, {file_name, NewFileName}}=io:read(F,''),
	%%{file_name, _} = io:read(F,''),
	%%��ȡ�ڶ��У�ͷ��ʶ
	{ok,{header_start,std}} = io:read(F,''),
	%%��ȡ����
	{ok,{content,L}} = io:read(F,''),
	Content = transErLan2CLan(L),

	%%������ʶ
	{ok,{header_end,std}} = io:read(F,''),

	%%�ļ�����
	eof = io:read(F,''),
	file:close(F),

	%%д�ļ���������
	io:format("Write Cotent To ~s~n",[NewFileName]),
	write(Content,NewFileName),


	%%io:format("~s~n", [NewFileName]),
	NewFileName.


%% --------------------
%% ����Erlang��ʽ���ݵ�C����
%% read(FileName) -> IOText()
%% Get NewFileName = string()
%% --------------------
%%transErLan2CLan2(L) ->
  %%  transErLan2CLan(L, [], []).
transErLan2CLan([])  -> [];
transErLan2CLan([H|T])  ->
	{Type,Para} = H,
	io:format("~s~n",[Type]),
	case (Type) of
		enum          	-> is_enum(Para,enum) + transErLan2CLan(T);
		macro    		-> is_macro(Para,macro) + transErLan2CLan(T);
		struct 			-> is_struct(Para, struct) + transErLan2CLan(T);
		func_point 		-> is_func_point(Para, func_point) + transErLan2CLan(T);
		func_prototype 	-> is_func_prototype(Para, func_prototype) + transErLan2CLan(T)
	end.


bind(T,Type) ->
	[Type].

%%func_prototype
is_func_prototype(Tuple, func_prototype) ->
	{RetType, FunName, L} = Tuple,
	io:format("RetType:~s~n",[RetType]),
	io:format("FunName:~s~n",[FunName]),
	Q = RetType ++" " ++ FunName ++ "("  ++ is_funparalist_val(L,","),
	io:format("Q:~s~n",[Q]),
	[Q].

%%func_point
is_func_point(Tuple, func_point) ->
	{RetType, FunPtName, L} = Tuple,
	io:format("RetType:~s~n",[RetType]),
	io:format("FunPtName:~s~n",[FunPtName]),
	Q = RetType ++" (*" ++ FunPtName ++ ")("  ++ is_funparalist_val(L,","),
	io:format("Q:~s~n",[Q]),
	[Q].

%%fun para list
is_funparalist_val([], Dot)  -> ");";
is_funparalist_val([H|T], Dot) ->
	case 1 =:= length([H|T]) of
		true ->
			Q = H ,
			%%io:format("~s~n",[Q]),
			Q ++ is_funparalist_val(T, Dot);
		false ->
			Q = H ++ Dot ++ " ",
			%%io:format("~s~n",[Q]),
			Q ++ is_funparalist_val(T, Dot)		
	end.





%% struct �� enum ���Ժϲ�Ϊһ��
%%struct
is_struct(Tuple,struct) ->
	{Name,L}  = Tuple,
	io:format("Name:~s~n",[Name]),
	Q = "struct " ++ Name ++ "{" ++ "\n" ++ is_list_val(L,";"),
	io:format("Q:~s~n",[Q]),
	[Q].

%%enum
is_enum(Tuple, enum) -> 
	{Name ,L} = Tuple,
	io:format("Name:~s~n",[Name]),
	Q = "enum " ++ Name ++ "{" ++ "\n" ++ is_list_val(L,","),
	io:format("Q:~s~n",[Q]),
	[Q].


%%value list
is_list_val([], Dot)  -> "};";
is_list_val([H|T], Dot) ->
	Q = H ++ Dot ++ "\n",
	io:format("~s~n",[Q]),
	Q ++ is_list_val(T, Dot).





%%macro
is_macro([], macro)    -> [];
is_macro([H|T], macro) ->
	{Name, Value} = H,
	Q = "#define " ++ Name ++ "  " ++ Value ,%%++ "\n",
	io:format("~s~n",[Q]),
	[Q] ++ is_macro(T, macro).




get_local_path() ->
    filename:dirname(code:which(?MODULE)).