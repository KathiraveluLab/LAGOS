app [main!] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br" }

import pf.Stdout
import pf.Arg exposing [Arg]

main! : List Arg => Result {} _
main! = |_args|
    Stdout.line! "LAGOS Latency Monitor v1.0"

## Pure functional logic for latency analysis
## Returns whether the latency is within threshold
isLatencyAcceptable : List F64, F64 -> Bool
isLatencyAcceptable = \latencies, threshold ->
    avgLatency = List.sum latencies / (Num.to_f64 (List.len latencies))
    avgLatency < threshold

## Calculates the 99th percentile tail latency
calculate99thPercentile : List F64 -> F64
calculate99thPercentile = \latencies ->
    count = List.len latencies
    if count == 0 then
        0.0
    else
        sorted = List.sort_asc latencies
        index = Num.floor (Num.to_f64 count * 0.99)
        List.get sorted index |> Result.with_default 0.0

## Exported to C for Pony FFI integration
calculate99thPercentileC : List F64 -> F64
calculate99thPercentileC = \latencies ->
    calculate99thPercentile latencies
