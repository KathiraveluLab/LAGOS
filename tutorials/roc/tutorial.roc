app "latency-check"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8-0sP_86as98as.tar.br" }
    imports [pf.Stdout]
    provides [main] to pf

main =
    Stdout.line "--- LAGOS Roc Tutorial ---"
    Stdout.line "Checking 99th percentile latency..."
    # In a real scenario, this would involve sorting a list of f64s
    Stdout.line "Result: 12ms (Target: <20ms)"
