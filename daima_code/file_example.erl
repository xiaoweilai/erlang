%% 文件读写示例

-module(file_example).

-export([write/2, read/1, readline/1]).

%% -*- coding: utf-8 -*-
%% -*- coding: latin-1 -*-

%% --------------------
%% 写入文件
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
%% 读取文件
%% read(FileName) -> binary()
%% FileName = string()
%% --------------------
read(FileName) when is_list(FileName) ->
    {ok, Content} = file:read_file(FileName),
    Content.

%% --------------------
%% 读取传入文件名中内容对应的文件
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