module key_expansion(
    input wire [255:0] key,
    output wire [127:0] key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10,key_11,key_12,key_13,key_14,
    input wire clk
);

wire [31:0] w_in[0:59];
reg [31:0] w[0:59];

assign w_in[0] = key[255:224];
assign w_in[1] = key[223:192];
assign w_in[2] = key[191:160];
assign w_in[3] = key[159:128];
assign w_in[4] = key[127:96];
assign w_in[5] = key[95:64];
assign w_in[6] = key[63:32];
assign w_in[7] = key[31:0];

wire [31:0] rcon[0:6];
rcon r0(.i(4'd0), .rcon_out(rcon[0]));
rcon r1(.i(4'd1), .rcon_out(rcon[1]));
rcon r2(.i(4'd2), .rcon_out(rcon[2]));
rcon r3(.i(4'd3), .rcon_out(rcon[3]));
rcon r4(.i(4'd4), .rcon_out(rcon[4]));
rcon r5(.i(4'd5), .rcon_out(rcon[5]));
rcon r6(.i(4'd6), .rcon_out(rcon[6]));


wire [31:0] RotWord_7 = {w[7][23:0], w[7][31:24]};
wire [31:0] SubWord_7;
sbox s7_0(.index(RotWord_7[31:24]), .out(SubWord_7[31:24]));
sbox s7_1(.index(RotWord_7[23:16]), .out(SubWord_7[23:16]));
sbox s7_2(.index(RotWord_7[15:8]), .out(SubWord_7[15:8]));
sbox s7_3(.index(RotWord_7[7:0]), .out(SubWord_7[7:0]));
assign w_in[8] = w[0] ^ SubWord_7 ^ rcon[0];
assign w_in[9] = w[1] ^ w_in[8];
assign w_in[10] = w[2] ^ w_in[9];
assign w_in[11] = w[3] ^ w_in[10];

wire [31:0] SubWord_11;
sbox s11_0(.index(w[11][31:24]), .out(SubWord_11[31:24]));
sbox s11_1(.index(w[11][23:16]), .out(SubWord_11[23:16]));
sbox s11_2(.index(w[11][15:8]), .out(SubWord_11[15:8]));
sbox s11_3(.index(w[11][7:0]), .out(SubWord_11[7:0]));
assign w_in[12] = w[4] ^ SubWord_11;
assign w_in[13] = w[5] ^ w_in[12];
assign w_in[14] = w[6] ^ w_in[13];
assign w_in[15] = w[7] ^ w_in[14];


wire [31:0] RotWord_15 = {w[15][23:0], w[15][31:24]};
wire [31:0] SubWord_15;
sbox s15_0(.index(RotWord_15[31:24]), .out(SubWord_15[31:24]));
sbox s15_1(.index(RotWord_15[23:16]), .out(SubWord_15[23:16]));
sbox s15_2(.index(RotWord_15[15:8]), .out(SubWord_15[15:8]));
sbox s15_3(.index(RotWord_15[7:0]), .out(SubWord_15[7:0]));
assign w_in[16] = w[8] ^ SubWord_15 ^ rcon[1];
assign w_in[17] = w[9] ^ w_in[16];
assign w_in[18] = w[10] ^ w_in[17];
assign w_in[19] = w[11] ^ w_in[18];

wire [31:0] SubWord_19;
sbox s19_0(.index(w[19][31:24]), .out(SubWord_19[31:24]));
sbox s19_1(.index(w[19][23:16]), .out(SubWord_19[23:16]));
sbox s19_2(.index(w[19][15:8]), .out(SubWord_19[15:8]));
sbox s19_3(.index(w[19][7:0]), .out(SubWord_19[7:0]));
assign w_in[20] = w[12] ^ SubWord_19; 
assign w_in[21] = w[13] ^ w_in[20];
assign w_in[22] = w[14] ^ w_in[21];
assign w_in[23] = w[15] ^ w_in[22];

wire [31:0] RotWord_23 = {w[23][23:0], w[23][31:24]};
wire [31:0] SubWord_23;
sbox s23_0(.index(RotWord_23[31:24]), .out(SubWord_23[31:24]));
sbox s23_1(.index(RotWord_23[23:16]), .out(SubWord_23[23:16]));
sbox s23_2(.index(RotWord_23[15:8]), .out(SubWord_23[15:8]));
sbox s23_3(.index(RotWord_23[7:0]), .out(SubWord_23[7:0]));
assign w_in[24] = w[16] ^ SubWord_23 ^ rcon[2];
assign w_in[25] = w[17] ^ w_in[24];
assign w_in[26] = w[18] ^ w_in[25];
assign w_in[27] = w[19] ^ w_in[26];

wire [31:0] SubWord_27;
sbox s27_0(.index(w[27][31:24]), .out(SubWord_27[31:24]));
sbox s27_1(.index(w[27][23:16]), .out(SubWord_27[23:16]));
sbox s27_2(.index(w[27][15:8]), .out(SubWord_27[15:8]));
sbox s27_3(.index(w[27][7:0]), .out(SubWord_27[7:0]));
assign w_in[28] = w[20] ^ SubWord_27;
assign w_in[29] = w[21] ^ w_in[28];
assign w_in[30] = w[22] ^ w_in[29];
assign w_in[31] = w[23] ^ w_in[30];

wire [31:0] RotWord_31 = {w[31][23:0], w[31][31:24]};
wire [31:0] SubWord_31;
sbox s31_0(.index(RotWord_31[31:24]), .out(SubWord_31[31:24]));
sbox s31_1(.index(RotWord_31[23:16]), .out(SubWord_31[23:16]));
sbox s31_2(.index(RotWord_31[15:8]), .out(SubWord_31[15:8]));
sbox s31_3(.index(RotWord_31[7:0]), .out(SubWord_31[7:0]));
assign w_in[32] = w[24] ^ SubWord_31 ^ rcon[3];
assign w_in[33] = w[25] ^ w_in[32];
assign w_in[34] = w[26] ^ w_in[33];
assign w_in[35] = w[27] ^ w_in[34];

wire [31:0] SubWord_35;
sbox s35_0(.index(w[35][31:24]), .out(SubWord_35[31:24]));
sbox s35_1(.index(w[35][23:16]), .out(SubWord_35[23:16]));
sbox s35_2(.index(w[35][15:8]), .out(SubWord_35[15:8]));
sbox s35_3(.index(w[35][7:0]), .out(SubWord_35[7:0]));
assign w_in[36] = w[28] ^ SubWord_35;
assign w_in[37] = w[29] ^ w_in[36];
assign w_in[38] = w[30] ^ w_in[37];
assign w_in[39] = w[31] ^ w_in[38];

wire [31:0] RotWord_39 = {w[39][23:0], w[39][31:24]};
wire [31:0] SubWord_39;
sbox s39_0(.index(RotWord_39[31:24]), .out(SubWord_39[31:24]));
sbox s39_1(.index(RotWord_39[23:16]), .out(SubWord_39[23:16]));
sbox s39_2(.index(RotWord_39[15:8]), .out(SubWord_39[15:8]));
sbox s39_3(.index(RotWord_39[7:0]), .out(SubWord_39[7:0]));
assign w_in[40] = w[32] ^ SubWord_39 ^ rcon[4];
assign w_in[41] = w[33] ^ w_in[40];
assign w_in[42] = w[34] ^ w_in[41];
assign w_in[43] = w[35] ^ w_in[42];

wire [31:0] SubWord_43;
sbox s43_0(.index(w[43][31:24]), .out(SubWord_43[31:24]));
sbox s43_1(.index(w[43][23:16]), .out(SubWord_43[23:16]));
sbox s43_2(.index(w[43][15:8]), .out(SubWord_43[15:8]));
sbox s43_3(.index(w[43][7:0]), .out(SubWord_43[7:0]));
assign w_in[44] = w[36] ^ SubWord_43;
assign w_in[45] = w[37] ^ w_in[44];
assign w_in[46] = w[38] ^ w_in[45];
assign w_in[47] = w[39] ^ w_in[46];

wire [31:0] RotWord_47 = {w[47][23:0], w[47][31:24]};
wire [31:0] SubWord_47;
sbox s47_0(.index(RotWord_47[31:24]), .out(SubWord_47[31:24]));
sbox s47_1(.index(RotWord_47[23:16]), .out(SubWord_47[23:16]));
sbox s47_2(.index(RotWord_47[15:8]), .out(SubWord_47[15:8]));
sbox s47_3(.index(RotWord_47[7:0]), .out(SubWord_47[7:0]));
assign w_in[48] = w[40] ^ SubWord_47 ^ rcon[5];
assign w_in[49] = w[41] ^ w_in[48];
assign w_in[50] = w[42] ^ w_in[49];
assign w_in[51] = w[43] ^ w_in[50];

wire [31:0] SubWord_51;
sbox s51_0(.index(w[51][31:24]), .out(SubWord_51[31:24]));
sbox s51_1(.index(w[51][23:16]), .out(SubWord_51[23:16]));
sbox s51_2(.index(w[51][15:8]), .out(SubWord_51[15:8]));
sbox s51_3(.index(w[51][7:0]), .out(SubWord_51[7:0]));
assign w_in[52] = w[44] ^ SubWord_51;
assign w_in[53] = w[45] ^ w_in[52];
assign w_in[54] = w[46] ^ w_in[53];
assign w_in[55] = w[47] ^ w_in[54];

wire [31:0] RotWord_55 = {w[55][23:0], w[55][31:24]};
wire [31:0] SubWord_55;
sbox s55_0(.index(RotWord_55[31:24]), .out(SubWord_55[31:24]));
sbox s55_1(.index(RotWord_55[23:16]), .out(SubWord_55[23:16]));
sbox s55_2(.index(RotWord_55[15:8]), .out(SubWord_55[15:8]));
sbox s55_3(.index(RotWord_55[7:0]), .out(SubWord_55[7:0]));
assign w_in[56] = w[48] ^ SubWord_55 ^ rcon[6];
assign w_in[57] = w[49] ^ w_in[56];
assign w_in[58] = w[50] ^ w_in[57];
assign w_in[59] = w[51] ^ w_in[58];
 

  always @(posedge clk) begin
    w[0] <= w_in[0];
    w[1] <= w_in[1];
    w[2] <= w_in[2];
    w[3] <= w_in[3];
    w[4] <= w_in[4];
    w[5] <= w_in[5];
    w[6] <= w_in[6];
    w[7] <= w_in[7];
    w[8] <= w_in[8];
    w[9] <= w_in[9];
    w[10] <= w_in[10];
    w[11] <= w_in[11];
    w[12] <= w_in[12];
    w[13] <= w_in[13];
    w[14] <= w_in[14];
    w[15] <= w_in[15];
    w[16] <= w_in[16];
    w[17] <= w_in[17];
    w[18] <= w_in[18];
    w[19] <= w_in[19];
    w[20] <= w_in[20];
    w[21] <= w_in[21];
    w[22] <= w_in[22];
    w[23] <= w_in[23];
    w[24] <= w_in[24];
    w[25] <= w_in[25];
    w[26] <= w_in[26];
    w[27] <= w_in[27];
    w[28] <= w_in[28];
    w[29] <= w_in[29];
    w[30] <= w_in[30];
    w[31] <= w_in[31];
    w[32] <= w_in[32];
    w[33] <= w_in[33];
    w[34] <= w_in[34];
    w[35] <= w_in[35];
    w[36] <= w_in[36];
    w[37] <= w_in[37];
    w[38] <= w_in[38];
    w[39] <= w_in[39];
    w[40] <= w_in[40];
    w[41] <= w_in[41];
    w[42] <= w_in[42];
    w[43] <= w_in[43];
    w[44] <= w_in[44];
    w[45] <= w_in[45];
    w[46] <= w_in[46];
    w[47] <= w_in[47];
    w[48] <= w_in[48];
    w[49] <= w_in[49];
    w[50] <= w_in[50];
    w[51] <= w_in[51];
    w[52] <= w_in[52];
    w[53] <= w_in[53];
    w[54] <= w_in[54];
    w[55] <= w_in[55];
    w[56] <= w_in[56];
    w[57] <= w_in[57];
    w[58] <= w_in[58];
    w[59] <= w_in[59];
end

assign key_0 = {w_in[0], w_in[1], w_in[2], w_in[3]};
assign key_1 = {w_in[4], w_in[5], w_in[6], w_in[7]};
assign key_2 = {w[8], w[9], w[10], w[11]};
assign key_3 = {w[12], w[13], w[14], w[15]};
assign key_4 = {w[16], w[17], w[18], w[19]};
assign key_5 = {w[20], w[21], w[22], w[23]};
assign key_6 = {w[24], w[25], w[26], w[27]};
assign key_7 = {w[28], w[29], w[30], w[31]};
assign key_8 = {w[32], w[33], w[34], w[35]};
assign key_9 = {w[36], w[37], w[38], w[39]};
assign key_10 = {w[40], w[41], w[42], w[43]};
assign key_11 = {w[44], w[45], w[46], w[47]};
assign key_12 = {w[48], w[49], w[50], w[51]};
assign key_13 = {w[52], w[53], w[54], w[55]};
assign key_14 = {w[56], w[57], w[58], w[59]};
endmodule