# 🔒 AES-256 Hardware Implementation (Fully Unrolled Pipeline)

![Verilog](https://img.shields.io/badge/Language-Verilog-blue.svg)
![Standard](https://img.shields.io/badge/Standard-FIPS_197-success.svg)
![Architecture](https://img.shields.io/badge/Architecture-Fully_Unrolled_Pipeline-orange.svg)

## 📖 Overview
This repository contains a high-performance hardware implementation of the Advanced Encryption Standard (AES) with a 256-bit key length. Written entirely in **Verilog**, the design strictly complies with the National Institute of Standards and Technology (NIST) FIPS 197 specification. 

The core architecture utilizes a **fully unrolled pipeline**, prioritizing maximum data throughput and processing speed, making it suitable for real-time cryptographic applications and high-bandwidth data streams.

---

## ✨ Architecture & Features

<img width="1029" height="279" alt="Screenshot 2026-05-12 100302" src="https://github.com/user-attachments/assets/75d22f9f-c883-4d50-a5de-68a8d25ea2ed" />


* **Fully Unrolled Pipeline:** The design flattens all 14 rounds of the AES-256 algorithm into sequential physical hardware stages. 
* **High Throughput:** After an initial latency of 15 clock cycles, the system outputs a new 128-bit ciphertext block every single clock cycle.
* **Parallel Key Expansion:** The 256-bit key schedule is computed simultaneously alongside the datapath, providing 15 independent 128-bit round keys without stalling the main pipeline.
* **Combinational S-Box:** The byte substitution layer is implemented using pure combinational logic (pre-computed lookup tables) to minimize intra-stage latency.
* **FIPS 197 Verified:** All functional blocks have been rigorously tested against the official NIST test vectors (Appendix C.3).

---

## 📂 Repository Structure

The project is heavily modularized to isolate the mathematical transformations required by the standard.

| Module / File | Description |
| :--- | :--- |
| `top.v` | Top-level entity integrating the 14-stage pipeline and data registers. |
| `KeyExpansion.v` | Synchronous module generating all 15 round keys from the base 256-bit key. |
| `SubBytes.v` | Instantiates 16 independent S-boxes for parallel state matrix substitution. |
| `sbox.v` | The 16x16 Rijndael S-box lookup table. |
| `ShiftRows.v` | Combinational routing for cyclic row permutations. |
| `MixColumns.v` | Galois Field matrix multiplication using optimized shift-and-XOR logic. |
| `AddRoundKey.v` | Bitwise XOR operation combining the state matrix and the round key. |
| `rcon.v` | Round constant lookup table utilized by the key expansion unit. |

---

## 🔌 Interface Specifications

The top-level module (`top.v`) exposes the following signals:

| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1 bit | System clock signal. |
| `key` | Input | 256 bit | The master cryptographic key. |
| `plaintext` | Input | 128 bit | The input data block to be encrypted. |
| `ciphertext` | Output | 128 bit | The resulting encrypted data block. |

---

## 🛠️ Simulation and Verification

The design has been verified using RTL (Pre-synthesis) simulation. To verify the functional correctness of this core in your own environment:

1. Import all `.v` files into your preferred HDL simulator (e.g., ModelSim, Vivado Simulator).
2. Compile a testbench that feeds the `plaintext` and `key` with the vectors provided in the FIPS 197 documentation.
3. Simulate the design for at least 20 clock cycles to allow the pipeline to fill.
4. Monitor the `ciphertext` output and compare it against the expected NIST output vector.

---

## ⚠️ Synthesis Notes
Due to the fully unrolled nature of this pipeline, the design consumes a significant amount of logic elements (LUTs) and routing resources on an FPGA. It is highly recommended to synthesize this core on high-density FPGA families. For implementations requiring a smaller physical footprint, an iterative (looping) architecture should be considered instead.
