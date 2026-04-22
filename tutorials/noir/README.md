# Noir Tutorial: ZK-Audit

Noir is a domain-specific language for writing zero-knowledge arithmetic circuits. In LAGOS, Noir generates ZK-SNARKs that prove a node's eligibility or accountability without revealing its full identity.

## Roles in LAGOS
1.  **Anonymous Membership**: Proving a node belongs to a federated domain without revealing which node it is.
2.  **Privacy-Preserving Audit**: Providing proofs of correct behavior to external auditors while maintaining operational privacy.
3.  **Governance Proofs**: Verifying that a governance decision was made according to the rules (e.g., quorum was reached) without exposing the individual votes.

## Tutorial: Proving Membership

In this tutorial, we will write a simple circuit that checks if a private "Identity Key" hashes to a public "Commitment". This allows a node to prove it knows the secret key for a commitment without revealing the key itself.

### `main.nr`
```noir
use dep::std;

fn main(
    secret_key: Field,         // Private input: Only the prover knows this
    public_commitment: Field   // Public input: Everyone sees this
) {
    // Generate a hash of the secret key
    let computed_commitment = std::hash::pedersen_hash([secret_key]);
    
    // Assert that the hash matches the public commitment
    assert(computed_commitment == public_commitment);
}
```

## Running the Tutorial

To compile the circuit and generate a proof, use `nargo`:

```bash
nargo check
nargo prove
nargo verify
```

## Key Concepts
- **Fields**: The basic data type in ZK-circuits, representing elements of a large prime field.
- **Constraints**: Instead of execution steps, we define mathematical constraints that must be satisfied.
- **Witnesses**: The private inputs used to generate the proof.
