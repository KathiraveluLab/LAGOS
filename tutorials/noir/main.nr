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
