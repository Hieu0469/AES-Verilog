module InvMixColumns(
    input  [127:0] state_in,
    output [127:0] state_out
);

    function [7:0] mb2;
        input [7:0] x;
        begin
            if (x[7] == 1)
                mb2 = ((x << 1) ^ 8'h1b);
            else
                mb2 = x << 1;
        end
    endfunction

    function [7:0] mb4;
        input [7:0] x;
        begin
            mb4 = mb2(mb2(x));
        end
    endfunction

    function [7:0] mb8;
        input [7:0] x;
        begin
            mb8 = mb2(mb4(x));
        end
    endfunction

    function [7:0] mb9;
        input [7:0] x;
        begin
            mb9 = mb8(x) ^ x;
        end
    endfunction

    function [7:0] mb11;
        input [7:0] x;
        begin
            mb11 = mb8(x) ^ mb2(x) ^ x;
        end
    endfunction

    function [7:0] mb13;
        input [7:0] x;
        begin
            mb13 = mb8(x) ^ mb4(x) ^ x;
        end
    endfunction

    function [7:0] mb14;
        input [7:0] x;
        begin
            mb14 = mb8(x) ^ mb4(x) ^ mb2(x);
        end
    endfunction

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : inv_m_col
            assign state_out[(i*32 + 24)+:8] = mb14(state_in[(i*32 + 24)+:8]) ^ mb11(state_in[(i*32 + 16)+:8]) ^ mb13(state_in[(i*32 + 8)+:8]) ^ mb9(state_in[i*32+:8]);
            assign state_out[(i*32 + 16)+:8] = mb9(state_in[(i*32 + 24)+:8]) ^ mb14(state_in[(i*32 + 16)+:8]) ^ mb11(state_in[(i*32 + 8)+:8]) ^ mb13(state_in[i*32+:8]);
            assign state_out[(i*32 + 8)+:8]  = mb13(state_in[(i*32 + 24)+:8]) ^ mb9(state_in[(i*32 + 16)+:8]) ^ mb14(state_in[(i*32 + 8)+:8]) ^ mb11(state_in[i*32+:8]);
            assign state_out[i*32+:8]        = mb11(state_in[(i*32 + 24)+:8]) ^ mb13(state_in[(i*32 + 16)+:8]) ^ mb9(state_in[(i*32 + 8)+:8]) ^ mb14(state_in[i*32+:8]);
        end
    endgenerate

endmodule
