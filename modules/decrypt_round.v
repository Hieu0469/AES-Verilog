module decrypt_round(
    input  wire [127:0] state_in,
    input  wire [127:0] round_key,
    input  wire         is_final,
    output wire [127:0] state_out
);

wire [127:0] ark_out;
wire [127:0] imc_out;
wire [127:0] isr_in;
wire [127:0] isr_out;

addRoundKey ark(.data(state_in), .key(round_key), .out(ark_out));
InvMixColumns imc(.state_in(ark_out), .state_out(imc_out));

assign isr_in = is_final ? ark_out : imc_out;

inv_shift_rows isr(.state_in(isr_in), .state_out(isr_out));
inv_sub_bytes isb(.state_in(isr_out), .state_out(state_out));

endmodule
