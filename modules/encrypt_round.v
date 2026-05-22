module encrypt_round(
    input  wire [127:0] state_in,
    input  wire [127:0] round_key,
    input  wire         is_final,
    output wire [127:0] state_out
);

wire [127:0] sb_out;
wire [127:0] sr_out;
wire [127:0] mc_out;
wire [127:0] ark_in;

sub_bytes sb(.state_in(state_in), .state_out(sb_out));
shift_rows sr(.state_in(sb_out), .state_out(sr_out));
MixColumns mc(.state_in(sr_out), .state_out(mc_out));

assign ark_in = is_final ? sr_out : mc_out;

addRoundKey ark(.data(ark_in), .key(round_key), .out(state_out));

endmodule
