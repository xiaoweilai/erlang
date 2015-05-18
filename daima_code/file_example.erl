%% �ļ���дʾ��

-module(file_example).

-export([write/2, read/1, readline/1]).

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
%% read(FileName) -> binary()
%% FileName = string()
%% --------------------
readline(FileName) when is_list(FileName) ->
	{ok, F} = file:open(FileName,read),
	{ok, {file_name, NewFileName}}=io:read(F,''),
	%%{file_name, _} = io:read(F,''),
	file:close(F),
	%%io:format("~s~n", [NewFileName]),
	{ok,NewFileName}.


get_local_path() ->
    filename:dirname(code:which(?MODULE)).