app "lagos-monitor"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/749f7ba3b81165d6f1a8e1.tar.br" }
    imports [pf.Stdout, pf.Task]
    provides [main] to pf

main =
    Stdout.line "LAGOS Latency Monitor v1.0"

## Pure functional logic for latency analysis
## Returns whether the latency is within threshold
isLatencyAcceptable : List F64, F64 -> Bool
isLatencyAcceptable = \latencies, threshold ->
    avgLatency = List.sum latencies / (Num.toF64 (List.len latencies))
    avgLatency < threshold

## Calculates the 99th percentile tail latency
calculate99thPercentile : List F64 -> F64
calculate99thPercentile = \latencies ->
    sorted = List.sortAsc latencies
    index = Num.floor (Num.toF64 (List.len latencies) * 0.99)
    List.get sorted index |> Result.withDefault 0.0
