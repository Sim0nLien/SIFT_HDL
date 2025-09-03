# SIFT (Scale Invariant Feature Transform) in VHDL

This project implements the **SIFT (Scale Invariant Feature Transform)** algorithm in VHDL.  
Currently, only the **Harris Descriptor** stage is implemented.  
The goal is to provide a hardware-accelerated solution for feature detection and description in images. 
More information can be found in the [specification document](./Docs/specification.md).

## Current Status

- Core modules written and simulated in VHDL.
- Tested in Vivado using a random FPGA board (no specific `.xdc` constraints defined).

## Repository Structure
- `src/` : VHDL source files for the descriptor.
- `script/` : scripts to create testbenches.
- `docs/` : notes, diagrams, and algorithm-related documentation (currently empty).

## Simulation

No simulation testbenches are provided in this repository.

## Next Steps

- See the [`.todo`](./.todo) file for the list of upcoming tasks.
