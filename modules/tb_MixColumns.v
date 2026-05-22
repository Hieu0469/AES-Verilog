`timescale 1ns / 1ps

module tb_MixColumns;
    reg  [127:0] in;
    wire [127:0] out;	


    MixColumns m (
        .state_in(in),
        .state_out(out)
    );

    initial begin
        $monitor("Time: %0t | input  = %h | output = %h", $time, in, out);
        
        in = 128'h6353e08c0960e104cd70b751bacad0e7;
        #10;
        
        $finish; 
    end
endmodule