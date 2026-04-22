# Unison Tutorial: Distributed Deployment

Unison is a content-addressed programming language where functions are identified by their hash, not their name. In LAGOS, Unison is used for seamless distributed deployment—allowing the framework to update networking logic across thousands of nodes without name conflicts or versioning hell.

## Roles in LAGOS
1.  **Code as Content**: Functions are immutable and identified by their cryptographic hash.
2.  **Zero-Conflict Updates**: New versions of a function have new hashes, allowing them to coexist with old versions during a rollout.
3.  **Efficiency**: Nodes only download the specific function hashes they need to execute.

## Tutorial: Defining a Topology Rule

In this tutorial, we will define a simple Unison function that checks if a node is allowed to be a federation hub.

### `tutorial.u`
```unison
-- A simple check for hub eligibility
hub.isEligible : Text -> Boolean
hub.isEligible nodeId =
  match nodeId with
    "hub1" -> true
    "hub2" -> true
    _      -> false

-- A test for our eligibility check
> hub.isEligible "hub1"
```

## Running the Tutorial

Unison is typically managed through the Unison Codebase Manager (UCM):

```bash
ucm
load tutorial.u
```

## Key Concepts
- **Hashes**: Every definition is hashed based on its syntax tree.
- **Structural Identity**: If two people write the same function independently, they have the same hash.
- **The Codebase**: Unison code is stored in a structured database, not just text files.
