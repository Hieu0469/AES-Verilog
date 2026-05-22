module top(
    input clk,
    input wire [255:0] key,
    input wire [127:0] plaintext,
    output wire [127:0] ciphertext
);
wire [127:0] RoundKey[0:14];
wire [127:0] AfterAddRoundKey[0:14];
wire [127:0] AfterSubBytes[0:14];
wire [127:0] AfterShiftRows[0:14];
wire [127:0] AfterMixColumns[0:13];
reg [127:0] state[0:14];
// Key Expansion
key_expansion ke(
    .key(key),
    .key_0(RoundKey[0]),
    .key_1(RoundKey[1]),
    .key_2(RoundKey[2]),
    .key_3(RoundKey[3]),
    .key_4(RoundKey[4]),
    .key_5(RoundKey[5]),
    .key_6(RoundKey[6]),
    .key_7(RoundKey[7]),
    .key_8(RoundKey[8]),
    .key_9(RoundKey[9]),
    .key_10(RoundKey[10]),
    .key_11(RoundKey[11]),
    .key_12(RoundKey[12]),
    .key_13(RoundKey[13]),
    .key_14(RoundKey[14]),
    .clk(clk)
);
// Round 0
addRoundKey ark0(.data(plaintext), .key(RoundKey[0]), .out(AfterAddRoundKey[0]));
// Round 1
sub_bytes sb1(.state_in(state[0]), .state_out(AfterSubBytes[0]));
shift_rows sr1(.state_in(AfterSubBytes[0]), .state_out(AfterShiftRows[0]));
MixColumns mc1(.state_in(AfterShiftRows[0]), .state_out(AfterMixColumns[0]));
addRoundKey ark1(.data(AfterMixColumns[0]), .key(RoundKey[1]), .out(AfterAddRoundKey[1]));

//Round 2
sub_bytes sb2(.state_in(state[1]), .state_out(AfterSubBytes[1]));
shift_rows sr2(.state_in(AfterSubBytes[1]), .state_out(AfterShiftRows[1]));
MixColumns mc2(.state_in(AfterShiftRows[1]), .state_out(AfterMixColumns[1]));
addRoundKey ark2(.data(AfterMixColumns[1]), .key(RoundKey[2]), .out(AfterAddRoundKey[2]));

//Round 3
sub_bytes sb3(.state_in(state[2]), .state_out(AfterSubBytes[2]));
shift_rows sr3(.state_in(AfterSubBytes[2]), .state_out(AfterShiftRows[2]));
MixColumns mc3(.state_in(AfterShiftRows[2]), .state_out(AfterMixColumns[2]));
addRoundKey ark3(.data(AfterMixColumns[2]), .key(RoundKey[3]), .out(AfterAddRoundKey[3]));

//Round 4
sub_bytes sb4(.state_in(state[3]), .state_out(AfterSubBytes[3]));
shift_rows sr4(.state_in(AfterSubBytes[3]), .state_out(AfterShiftRows[3]));
MixColumns mc4(.state_in(AfterShiftRows[3]), .state_out(AfterMixColumns[3]));
addRoundKey ark4(.data(AfterMixColumns[3]), .key(RoundKey[4]), .out(AfterAddRoundKey[4]));

//Round 5
sub_bytes sb5(.state_in(state[4]), .state_out(AfterSubBytes[4]));
shift_rows sr5(.state_in(AfterSubBytes[4]), .state_out(AfterShiftRows[4]));
MixColumns mc5(.state_in(AfterShiftRows[4]), .state_out(AfterMixColumns[4]));
addRoundKey ark5(.data(AfterMixColumns[4]), .key(RoundKey[5]), .out(AfterAddRoundKey[5]));

//Round 6
sub_bytes sb6(.state_in(state[5]), .state_out(AfterSubBytes[5]));
shift_rows sr6(.state_in(AfterSubBytes[5]), .state_out(AfterShiftRows[5]));
MixColumns mc6(.state_in(AfterShiftRows[5]), .state_out(AfterMixColumns[5]));
addRoundKey ark6(.data(AfterMixColumns[5]), .key(RoundKey[6]), .out(AfterAddRoundKey[6]));

//Round 7
sub_bytes sb7(.state_in(state[6]), .state_out(AfterSubBytes[6]));
shift_rows sr7(.state_in(AfterSubBytes[6]), .state_out(AfterShiftRows[6]));
MixColumns mc7(.state_in(AfterShiftRows[6]), .state_out(AfterMixColumns[6]));
addRoundKey ark7(.data(AfterMixColumns[6]), .key(RoundKey[7]), .out(AfterAddRoundKey[7]));

//Round 8
sub_bytes sb8(.state_in(state[7]), .state_out(AfterSubBytes[7]));
shift_rows sr8(.state_in(AfterSubBytes[7]), .state_out(AfterShiftRows[7]));
MixColumns mc8(.state_in(AfterShiftRows[7]), .state_out(AfterMixColumns[7]));
addRoundKey ark8(.data(AfterMixColumns[7]), .key(RoundKey[8]), .out(AfterAddRoundKey[8]));

//Round 9
sub_bytes sb9(.state_in(state[8]), .state_out(AfterSubBytes[8]));
shift_rows sr9(.state_in(AfterSubBytes[8]), .state_out(AfterShiftRows[8]));
MixColumns mc9(.state_in(AfterShiftRows[8]), .state_out(AfterMixColumns[8]));
addRoundKey ark9(.data(AfterMixColumns[8]), .key(RoundKey[9]), .out(AfterAddRoundKey[9]));

//Round 10
sub_bytes sb10(.state_in(state[9]), .state_out(AfterSubBytes[9]));
shift_rows sr10(.state_in(AfterSubBytes[9]), .state_out(AfterShiftRows[9]));
MixColumns mc10(.state_in(AfterShiftRows[9]), .state_out(AfterMixColumns[9]));
addRoundKey ark10(.data(AfterMixColumns[9]), .key(RoundKey[10]), .out(AfterAddRoundKey[10]));

//Round 11
sub_bytes sb11(.state_in(state[10]), .state_out(AfterSubBytes[10]));
shift_rows sr11(.state_in(AfterSubBytes[10]), .state_out(AfterShiftRows[10]));
MixColumns mc11(.state_in(AfterShiftRows[10]), .state_out(AfterMixColumns[10]));
addRoundKey ark11(.data(AfterMixColumns[10]), .key(RoundKey[11]), .out(AfterAddRoundKey[11]));

//Round 12
sub_bytes sb12(.state_in(state[11]), .state_out(AfterSubBytes[11]));
shift_rows sr12(.state_in(AfterSubBytes[11]), .state_out(AfterShiftRows[11]));
MixColumns mc12(.state_in(AfterShiftRows[11]), .state_out(AfterMixColumns[11]));
addRoundKey ark12(.data(AfterMixColumns[11]), .key(RoundKey[12]), .out(AfterAddRoundKey[12]));

//Round 13
sub_bytes sb13(.state_in(state[12]), .state_out(AfterSubBytes[12]));
shift_rows sr13(.state_in(AfterSubBytes[12]), .state_out(AfterShiftRows[12]));
MixColumns mc13(.state_in(AfterShiftRows[12]), .state_out(AfterMixColumns[12]));
addRoundKey ark13(.data(AfterMixColumns[12]), .key(RoundKey[13]), .out(AfterAddRoundKey[13]));

//Round 14
sub_bytes sb14(.state_in(state[13]), .state_out(AfterSubBytes[13]));
shift_rows sr14(.state_in(AfterSubBytes[13]), .state_out(AfterShiftRows[13]));
addRoundKey ark14(.data(AfterShiftRows[13]), .key(RoundKey[14]), .out(AfterAddRoundKey[14]));   

always @(posedge clk) begin
    state[0] <= AfterAddRoundKey[0];
    state[1] <= AfterAddRoundKey[1];
    state[2] <= AfterAddRoundKey[2];
    state[3] <= AfterAddRoundKey[3];
    state[4] <= AfterAddRoundKey[4];
    state[5] <= AfterAddRoundKey[5];
    state[6] <= AfterAddRoundKey[6];
    state[7] <= AfterAddRoundKey[7];
    state[8] <= AfterAddRoundKey[8];
    state[9] <= AfterAddRoundKey[9];
    state[10] <= AfterAddRoundKey[10];
    state[11] <= AfterAddRoundKey[11];
    state[12] <= AfterAddRoundKey[12];
    state[13] <= AfterAddRoundKey[13];
    state[14] <= AfterAddRoundKey[14];
end
assign ciphertext = state[14];
endmodule