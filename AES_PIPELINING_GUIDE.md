# AES Pipelining Guide

## Current vs. Pipelined Architecture

### Current Design (Sequential)
```
Clock cycles for 1 block:
Cycle 1-14: Process one plaintext through all 14 rounds
Result: Available after 14 cycles
Throughput: 1 block per 14 cycles
```

### Pipelined Design (Parallel)
```
New input accepted every cycle
Each round occupies one pipeline stage
Multiple blocks in flight simultaneously

Cycle 1:  Block1 enters
Cycle 2:  Block2 enters, Block1 in Round 1
Cycle 3:  Block3 enters, Block2 in Round 1, Block1 in Round 2
...
Cycle 14: Block1 exits (result ready), Block14 enters
Cycle 15: Block2 exits, Block14 in Round 1

Result: 1 block output per cycle (after 14-cycle latency)
Throughput: 14x improvement (when processing continuous stream)
```

## Key Changes in Pipelined Implementation

### 1. **Separate Pipeline Stages**
Instead of using `state[0]` to `state[14]` registers that reference each other before being stored, we use:
- `pipe_data[0]` to `pipe_data[13]` for data progression
- Each register holds the output of one round

### 2. **Valid Bit Pipeline**
```verilog
reg [14:0] pipe_valid;  // Track which stages have valid data

always @(posedge clk) begin
    pipe_valid[0]  <= valid_in;
    pipe_valid[1]  <= pipe_valid[0];
    pipe_valid[2]  <= pipe_valid[1];
    // ... and so on
end
```
This ensures proper handshaking and knows when output is ready.

### 3. **Combinational Round Logic**
Each round is computed combinationally from its respective pipeline register:
```verilog
// Reader from pipe_data[i-1], result goes to pipe_data[i]
sub_bytes sbi(.state_in(pipe_data[i-1]), .state_out(roundX_sb));
shift_rows sri(.state_in(roundX_sb), .state_out(roundX_sr));
MixColumns mci(.state_in(roundX_sr), .state_out(roundX_mc));
addRoundKey arki(.data(roundX_mc), .key(RoundKey[i]), .out(roundX_out));
```

### 4. **Clock Domain Progression**
```
CLK 0: plaintext -> Round0 (AddRoundKey)   -> pipe_data[0]
CLK 1: pipe_data[0] -> Rounds1 (SubBytes->ShiftRows->MixColumns->ARK) -> pipe_data[1]
CLK 2: pipe_data[1] -> Rounds2 -> pipe_data[2]
...
CLK 14: pipe_data[13] -> Round14 -> ciphertext
```

## Implementation Strategy

### Step 1: Replace state register logic
OLD (combinational input dependency problem):
```verilog
sub_bytes sb1(.state_in(state[0]), ...);  // References state[0] before it's written!
```

NEW (data flows from previous pipeline stage):
```verilog
sub_bytes sb1(.state_in(pipe_data[0]), ...);  // Uses stable data from clock cycle before
```

### Step 2: Add valid bit tracking
Ensures you know when output is valid:
```verilog
always @(posedge clk) begin
    pipe_valid[0] <= valid_in;
    pipe_valid[1] <= pipe_valid[0];
    // ... propagate through all 15 stages
end

assign valid_out = pipe_valid[14];
```

### Step 3: Reset logic
Clear pipeline on reset:
```verilog
if (rst) begin
    pipe_valid <= 15'b0;
    for (int i = 0; i <= 14; i++)
        pipe_data[i] <= 128'b0;
end
```

## Performance Comparison

| Metric | Sequential | Pipelined |
|--------|-----------|-----------|
| Latency | 14 cycles | 14 cycles |
| Throughput (1 block) | 1 block/14 cycles | 1 block/14 cycles |
| Throughput (stream) | 1 block/14 cycles | 1 block/cycle |
| Max throughput | N/1400 blocks/s | N/1 blocks/s |
| Area overhead | Baseline | ~14x (due to per-stage registers) |

## Testbench Example (top_pipelined)

```verilog
module tb_aes_pipeline;
    reg clk, rst, valid_in;
    reg [255:0] key;
    reg [127:0] plaintext;
    wire [127:0] ciphertext;
    wire valid_out;
    
    top_pipelined dut(.*);
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; rst = 1; valid_in = 0;
        #20 rst = 0;
        
        // Feed plaintext every cycle
        repeat (20) begin
            @(posedge clk);
            valid_in = 1;
            plaintext = $random;
        end
        
        // Wait for pipeline to drain
        valid_in = 0;
        repeat (14) @(posedge clk);
        
        $finish;
    end
endmodule
```

## Advanced Techniques

### 1. **Fine-Grained Pipeline** (More stages)
Break each round into substages:
- Stage A: SubBytes
- Stage B: ShiftRows
- Stage C: MixColumns
- Stage D: AddRoundKey

This creates 56 stages (14 rounds × 4 substages), improving throughput but higher area cost.

### 2. **Partial Unroll** (Fewer stages)
Process 2 rounds per stage:
- Fewer registers needed
- Slight area reduction but lower frequency
- Good middle ground

### 3. **Flow Control**
Add stall signals if downstream can't accept data:
```verilog
always @(posedge clk) begin
    if (!stall_in) begin
        pipe_data[i] <= round_output;
        pipe_valid[i] <= pipe_valid[i-1];
    end
end
```

## Common Mistakes to Avoid

❌ **Wrong:**
```verilog
sub_bytes sb1(.state_in(state[0]), ...);
always @(posedge clk) begin
    state[0] <= some_input;  // state[0] used before assigned!
end
```

✅ **Correct:**
```verilog
always @(posedge clk) begin
    pipe_data[0] <= round0_out;
    pipe_data[1] <= round1_out;  // Clear progression
end
```

---

## Files Generated
- `top_pipelined.v` - Full pipelined AES implementation
- This guide - `AES_PIPELINING_GUIDE.md`

Start with `top_pipelined.v` and adapt your testbench to use the `valid_in`/`valid_out` handshake signals.
