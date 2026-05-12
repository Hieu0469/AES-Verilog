module sub_bytes_tb;
reg [127:0] state_in;
wire [127:0] state_out;

sub_bytes sb(
    .state_in(state_in),
    .state_out(state_out)
);
initial begin
    state_in = 128'h00112233445566778899aabbccddeeff;
    #10;
    $display("Input: %h", state_in);
    $display("Output: %h", state_out);
end
endmodule