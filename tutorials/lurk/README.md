# Lurk Tutorial: Recursive Audit

Lurk is a Lisp-like language for recursive SNARKs. It allows for the provable evaluation of complex, potentially infinite, data structures and rules. In LAGOS, Lurk is the final stage of the audit pipeline, capable of recursively verifying chains of governance decisions.

## Roles in LAGOS
1.  **Recursive Verification**: Proving that a long chain of governance events is valid by proving one step at a time.
2.  **Universal Computation**: Providing a general-purpose provable evaluator for complex networking rules.
3.  **Data Integrity**: Ensuring that the state of the federation matches the cumulative history of all approved changes.

## Tutorial: Recursive Summation Audit

In this tutorial, we will use a Lurk expression to recursively calculate the total "Voting Power" in a domain.

### `tutorial.lurk`
```lurk
;; A simple recursive function to sum a list of values provably
(letrec ((sum (lambda (list)
                (if (eq list nil)
                    0
                    (+ (car list) (sum (cdr list)))))))
  (sum '(10 20 30 40)))

;; Expected output: 100
```

## Running the Tutorial

Lurk is usually run through its own REPL or as part of a Rust-based prover:

```bash
lurk tutorial.lurk
```

## Key Concepts
- **Cons Cells**: The fundamental building blocks of Lurk data structures.
- **Letrec**: Enables the definition of recursive functions.
- **Proof-carrying Data**: Each step of the calculation produces a proof that can be combined with others.
