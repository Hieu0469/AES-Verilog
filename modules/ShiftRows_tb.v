module shift_rows_tb();
    wire [127:0] state_out;
    reg [127:0] state_in;

    shift_rows sr(
        .state_in(state_in),
        .state_out(state_out)
    );
initial begin
    state_in = 128'h00102030405060708090a0b0c0d0e0f;
    #10; // Wait for the shift rows to complete
    $display("State In: %h", state_in);
    $display("State Out: %h", state_out);
end
endmodule