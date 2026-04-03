module sub_bytes(
    input wire [127:0] state_in,
    output wire [127:0] state_out
);
sbox s0_0(.index(state_in[127:120]), .out(state_out[127:120]));
sbox s0_1(.index(state_in[119:112]), .out(state_out[119:112]));
sbox s0_2(.index(state_in[111:104]), .out(state_out[111:104]));
sbox s0_3(.index(state_in[103:96]), .out(state_out[103:96]));
sbox s1_0(.index(state_in[95:88]), .out(state_out[95:88]));
sbox s1_1(.index(state_in[87:80]), .out(state_out[87:80]));
sbox s1_2(.index(state_in[79:72]), .out(state_out[79:72]));
sbox s1_3(.index(state_in[71:64]), .out(state_out[71:64]));
sbox s2_0(.index(state_in[63:56]), .out(state_out[63:56]));
sbox s2_1(.index(state_in[55:48]), .out(state_out[55:48]));
sbox s2_2(.index(state_in[47:40]), .out(state_out[47:40]));
sbox s2_3(.index(state_in[39:32]), .out(state_out[39:32]));
sbox s3_0(.index(state_in[31:24]), .out(state_out[31:24]));
sbox s3_1(.index(state_in[23:16]), .out(state_out[23:16]));
sbox s3_2(.index(state_in[15:8]), .out(state_out[15:8]));
sbox s3_3(.index(state_in[7:0]), .out(state_out[7:0]));
endmodule