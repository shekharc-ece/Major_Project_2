# UART Transmitter & Receiver (Verilog HDL)

A Universal Asynchronous Receiver-Transmitter (UART) communication module designed, functionally verified, and synthesized in Verilog HDL[cite: 10]. This repository contains both the RTL design and post-synthesis gate-level netlists for the transmitter (TX) and receiver (RX), along with dedicated testbenches for pre- and post-synthesis verification[cite: 10].

---

## Repository Structure

| File | Description |
| :--- | :--- |
| `uart_tx.v` | Behavioral/RTL Verilog implementation of the UART Transmitter (parallel-to-serial conversion with start, data, and stop bits)[cite: 10]. |
| `uart_rx.v` | Behavioral/RTL Verilog implementation of the UART Receiver (start-bit detection, baud-rate sampling, and serial-to-parallel conversion)[cite: 10]. |
| `uart_tb.v` | RTL simulation testbench verifying end-to-end serial transmission and reception between `uart_tx` and `uart_rx`[cite: 10]. |
| `synthesized_uart_tx.v` | Gate-level synthesized Verilog netlist for the UART Transmitter[cite: 10]. |
| `synthesized_uart_rx.v` | Gate-level synthesized Verilog netlist for the UART Receiver[cite: 10]. |
| `synthesized_uart_tb.v` | Post-synthesis testbench used to verify functional equivalence of the synthesized TX and RX netlists[cite: 10]. |
| `.gitignore` | Excludes compiled simulation executables (`*_sim`) and VCD waveform dumps (`*.vcd`) from version control[cite: 10]. |

---

## Overview

* **UART Transmitter (`uart_tx.v`):** Serializes parallel input data into a standard UART frame (Start bit, 8 Data bits, Stop bit) synchronized to the configured baud clock[cite: 10].
* **UART Receiver (`uart_rx.v`):** Monitors the serial input line for a falling-edge start bit, samples incoming bits at the baud rate intervals, and reconstructs the parallel byte output[cite: 10].
* **RTL Verification (`uart_tb.v`):** Connects the transmitter output directly to the receiver input, transmits test bytes, checks received data integrity, and dumps signal waveforms to `uart.vcd`[cite: 10].
* **Synthesis & Gate-Level Verification (`synthesized_uart_tx.v`, `synthesized_uart_rx.v`, `synthesized_uart_tb.v`):** Provides the synthesized gate-level representations of both modules and verifies post-synthesis timing and functional equivalence via `synthesized_uart.vcd`[cite: 10].

---

## Simulation & Waveform Viewing (Ubuntu / Icarus Verilog)

### 1. RTL Simulation
```bash
iverilog -o uart_sim uart_tx.v uart_rx.v uart_tb.v
vvp uart_sim
gtkwave uart.vcd
