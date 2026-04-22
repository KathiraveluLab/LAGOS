# Clarity Tutorial: Decidable Policy

Clarity is a decidable smart contract language used for defining precise governance policies in LAGOS. Unlike Turing-complete languages, Clarity doesn't have loops, which makes it possible to determine exactly how a contract will behave before it executes.

## Roles in LAGOS
1.  **Policy Definition**: Writing rules for who can join a domain or access specific network resources.
2.  **Predictability**: Ensuring that governance decisions are predictable and won't get stuck in infinite loops.
3.  **On-Chain Logic**: Executing rules directly on the Stacks blockchain for decentralized enforcement.

## Tutorial: Domain Access Rule

In this tutorial, we will create a simple policy that only allows a specific "admin" address to add new members to a domain.

### `tutorial.clarity`
```clarity
;; Define the administrative account
(define-constant admin 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)

;; Data map to store domain membership
(define-map Members principal bool)

;; Public function to add a member
(define-public (add-member (new-member principal))
  (begin
    ;; Check if the caller is the admin
    (asserts! (is-eq tx-sender admin) (err u100))
    
    ;; Add member to the map
    (map-set Members new-member true)
    (ok true)
  )
)

;; Read-only function to check membership
(define-read-only (is-member (user principal))
  (default-to false (map-get? Members user))
)
```

## Running the Tutorial

To check the syntax of your Clarity contracts, use `clarinet`:

```bash
clarinet check
```

## Key Concepts
- **Decidability**: No loops or recursive calls, ensuring the contract always terminates.
- **Literal Syntax**: Easy to read and reason about.
- **Pre-execution Analysis**: The bytecode is the source, allowing for a higher degree of transparency.
