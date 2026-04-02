`timescale 1ns/1ps

module tb_addRoundKey();

    reg [127:0] tb_data;
    reg [127:0] tb_key;
    wire [127:0] tb_out;

    addRoundKey uut (
        .data(tb_data),
        .out(tb_out),
        .key(tb_key)
    );

     initial begin
        tb_data = 128'h00112233445566778899aabbccddeeff;
        tb_key  = 128'h000102030405060708090a0b0c0d0e0f;
        #10;
        $display("------ TESTBENCH ADDROUNDKEY AES-256 ------");
        $display("Input Data : %h", tb_data);
        $display("Round Key  : %h", tb_key);
        $display("Output     : %h", tb_out);
         #10 $finish;
     end

endmodule
