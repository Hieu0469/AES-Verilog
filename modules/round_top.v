`timescale 1ns/1ps

module round_top(
    input  wire [127:0] state_in,
    input  wire [127:0] round_key,
    input  wire         is_final,
    input  wire         mode,
    output wire [127:0] state_out
);

wire [127:0] enc_out;
wire [127:0] dec_out;

encrypt_round enc(.state_in(state_in), .round_key(round_key), .is_final(is_final), .state_out(enc_out));
decrypt_round dec(.state_in(state_in), .round_key(round_key), .is_final(is_final), .state_out(dec_out));

assign state_out = mode ? dec_out : enc_out;

endmodule
