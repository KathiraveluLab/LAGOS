-module(lagos_nats).
-export([connect/2, pub/3]).

connect(Host, Port) ->
    % Convert Gleam string to Erlang list for gen_tcp
    HostStr = binary_to_list(Host),
    case gen_tcp:connect(HostStr, Port, [binary, {active, false}, {packet, raw}]) of
        {ok, Socket} ->
            ok = gen_tcp:send(Socket, <<"CONNECT {\"verbose\":false,\"pedantic\":false,\"tls_required\":false}\r\n">>),
            {ok, Socket};
        Error -> Error
    end.

pub(Socket, Subject, Payload) ->
    Len = byte_size(Payload),
    % NATS payload must be followed by CRLF
    Msg = [<<"PUB ">>, Subject, <<" ">>, integer_to_binary(Len), <<"\r\n">>, Payload, <<"\r\n">>],
    gen_tcp:send(Socket, Msg).
