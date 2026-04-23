{application, lagos_federation, [
    {vsn, "0.1.0"},
    {applications, [gleam_erlang,
                    gleam_otp,
                    gleam_stdlib,
                    gleeunit]},
    {description, ""},
    {modules, [federation,
               lagos_integration_test,
               lagos_nats]},
    {registered, []}
]}.
