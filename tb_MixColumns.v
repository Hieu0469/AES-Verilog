`timescale 1ns / 1ps

module tb_MixColumns;
    // ?ã s?a l?i thành [127:0] ?? ??ng nh?t v?i Design
    reg  [127:0] in;
    wire [127:0] out;	

    // ?ã s?a 'm' thành 'M' hoa. 
    // Khuy?n ngh? dùng phép gán theo tên port (.port(signal)) cho an toàn.
    MixColumns m (
        .state_in(in),
        .state_out(out)
    );

    initial begin
        // Trình bày l?i monitor cho d? nhìn k?t qu? trên console
        $monitor("Time: %0t | input  = %h | output = %h", $time, in, out);
        
        // ?ã b? d?u '_' th?a ngay sau ch? 'h'
        in = 128'h6353e08c0960e104cd70b751bacad0e7;
        #10;
        
        $finish; // K?t thúc mô ph?ng
    end
endmodule