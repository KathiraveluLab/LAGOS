-module(federation).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/federation.gleam").
-export([main/0, handle_federation_event/1, handle_flood_event/2, check_rate_limit/4, nats_connect/2, nats_pub/3, connect_nats/1, publish_federation_event/3, on_nats_message/2]).
-export_type([federation_message/0, nats_conn/0]).

-type federation_message() :: {join_domain, binary()} | {leave_domain, binary()}.

-type nats_conn() :: any().

-file("src/federation.gleam", 16).
-spec main() -> nil.
main() ->
    gleam_stdlib:println(<<"Starting LAGOS Federation Supervisor..."/utf8>>),
    case begin
        _pipe = gleam@otp@static_supervisor:new(one_for_one),
        gleam@otp@static_supervisor:start(_pipe)
    end of
        {ok, _} -> nil;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"federation"/utf8>>,
                        function => <<"main"/utf8>>,
                        line => 19,
                        value => _assert_fail,
                        start => 376,
                        'end' => 438,
                        pattern_start => 387,
                        pattern_end => 392})
    end,
    gleam_erlang_ffi:sleep_forever().

-file("src/federation.gleam", 26).
-spec handle_federation_event(federation_message()) -> nil.
handle_federation_event(Msg) ->
    case Msg of
        {join_domain, Id} ->
            gleam_stdlib:println(<<"Domain joined: "/utf8, Id/binary>>);

        {leave_domain, Id@1} ->
            gleam_stdlib:println(<<"Domain left: "/utf8, Id@1/binary>>)
    end.

-file("src/federation.gleam", 33).
-spec handle_flood_event(integer(), integer()) -> boolean().
handle_flood_event(Request_count, Threshold) ->
    case Request_count > Threshold of
        true ->
            gleam_stdlib:println(<<"ALERT: DDoS Flood detected!"/utf8>>),
            true;

        false ->
            false
    end.

-file("src/federation.gleam", 66).
-spec prune_history(list(integer()), integer(), integer()) -> list(integer()).
prune_history(History, Now, Window_size) ->
    _pipe = History,
    gleam@list:filter(_pipe, fun(Ts) -> Ts > (Now - Window_size) end).

-file("src/federation.gleam", 44).
-spec check_rate_limit(binary(), list(integer()), integer(), integer()) -> {ok,
        list(integer())} |
    {error, binary()}.
check_rate_limit(Domain_id, History, Window_size, Limit) ->
    Now = os:system_time(),
    Pruned_history = prune_history(History, Now, Window_size),
    case erlang:length(Pruned_history) > Limit of
        true ->
            gleam_stdlib:println(
                <<"Rate limit exceeded for domain: "/utf8, Domain_id/binary>>
            ),
            {error, <<"Rate limit exceeded"/utf8>>};

        false ->
            {ok, lists:append(Pruned_history, [Now])}
    end.

-file("src/federation.gleam", 74).
-spec nats_connect(binary(), integer()) -> {ok, nats_conn()} |
    {error, gleam@dynamic:dynamic_()}.
nats_connect(Host, Port) ->
    lagos_nats:connect(Host, Port).

-file("src/federation.gleam", 77).
-spec nats_pub(nats_conn(), binary(), bitstring()) -> {ok, nil} |
    {error, gleam@dynamic:dynamic_()}.
nats_pub(Conn, Subject, Payload) ->
    lagos_nats:pub(Conn, Subject, Payload).

-file("src/federation.gleam", 80).
-spec connect_nats(binary()) -> {ok, nats_conn()} |
    {error, gleam@dynamic:dynamic_()}.
connect_nats(Addr) ->
    gleam_stdlib:println(
        <<"Connecting to NATS federation broker at "/utf8, Addr/binary>>
    ),
    case lagos_nats:connect(Addr, 4222) of
        {ok, Conn} ->
            gleam_stdlib:println(
                <<"Successfully connected to NATS messaging plane."/utf8>>
            ),
            {ok, Conn};

        {error, Err} ->
            gleam_stdlib:println(<<"Failed to connect to NATS."/utf8>>),
            {error, Err}
    end.

-file("src/federation.gleam", 94).
-spec publish_federation_event(nats_conn(), binary(), binary()) -> nil.
publish_federation_event(Conn, Domain_id, Event_type) ->
    Subject = <<"lagos.federation."/utf8, Domain_id/binary>>,
    Payload = <<Event_type/binary>>,
    case lagos_nats:pub(Conn, Subject, Payload) of
        {ok, nil} ->
            gleam_stdlib:println(
                <<<<<<"Published "/utf8, Event_type/binary>>/binary,
                        " to "/utf8>>/binary,
                    Subject/binary>>
            );

        {error, _} ->
            gleam_stdlib:println(<<"Failed to publish event to NATS"/utf8>>)
    end.

-file("src/federation.gleam", 103).
-spec on_nats_message(binary(), bitstring()) -> nil.
on_nats_message(Topic, _) ->
    gleam_stdlib:println(
        <<"Received federation signal on topic: "/utf8, Topic/binary>>
    ).
