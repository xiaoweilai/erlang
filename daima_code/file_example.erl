%% �ļ���дʾ��

-module(file_example).

-export([write/2, read/1, readNewFileNameInFile/1, transErLan2CLan/1,bind/2,
	is_macro/1]).

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
		enum          	-> bind(Para, enum) + transErLan2CLan(T);
		macro    		-> is_macro(Para) + transErLan2CLan(T);
		struct 			-> bind(Para, struct) + transErLan2CLan(T);
		func_point 		-> bind(Para, func_point) + transErLan2CLan(T);
		func_prototype 	-> bind(Para, func_prototype) + transErLan2CLan(T)
	end.


bind(T,Type) ->
	[Type].

%%macro
is_macro([])    -> [];
is_macro([H|T]) ->
	{Name, Value} = H,
	Q = "#define " ++ Name ++ "  " ++ Value ,%%++ "\n",
	io:format("~s~n",[Q]),
	[Q] + is_macro(T).




get_local_path() ->
    filename:dirname(code:which(?MODULE)).