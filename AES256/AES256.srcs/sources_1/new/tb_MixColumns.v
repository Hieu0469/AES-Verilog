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
        in = 128'hd4bf5d30_e0b452ae_b84111f1_1e2798e5;
        #10;
        
        in = 128'h84e1dd69_1a41d76f_792d3897_83fbac70;
        #10;
        
        in = 128'h6353e08c_0960e104_cd70b751_bacad0e7;
        #10;
        
        $finish; // K?t thúc mô ph?ng
    end
endmodule