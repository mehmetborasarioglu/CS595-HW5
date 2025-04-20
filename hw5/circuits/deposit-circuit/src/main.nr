use dep::std::hash::pedersen_hash;
use dep::std::merkle::compute_merkle_root;

fn main(
    id: Field,
    r: Field,
    oldPath: [Field; 8],         // Merkle authentication path
    oldRoot: pub Field,          // Previous Merkle root (before insert)
    newRoot: pub Field,          // New root after inserting commitment
    commitment: pub Field,       // Pedersen(id, r)
    index: pub Field         // Index where commitment is inserted
) {
    // 1. Check commitment is correctly computed
    let expected_commitment = pedersen_hash([id, r]);
    assert(commitment == expected_commitment);

    // 2. Define constant empty leaf hash
    let empty_leaf_hash: Field = 0x18d85f3de6dcd78b6ffbf5d8374433a5528d8e3bf2100df0b7bb43a4c59ebd63;
    // 3. Ensure oldRoot is correct (before insertion)
    let computed_old_root = compute_merkle_root(empty_leaf_hash, index, oldPath);
    assert (computed_old_root == oldRoot);

    // 4. Compute new root after inserting commitment
    let computed_new_root = compute_merkle_root(commitment, index, oldPath);
    assert (computed_new_root == newRoot);
}
