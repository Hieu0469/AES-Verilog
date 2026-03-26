module rcon(
    input wire [3:0] i,
    output wire [31:0] rcon_out
);

wire [31:0] rcon_table [0:6];
assign rcon_table[0] = 32'h01000000;
assign rcon_table[1] = 32'h02000000;
assign rcon_table[2] = 32'h04000000;
assign rcon_table[3] = 32'h08000000;
assign rcon_table[4] = 32'h10000000;
assign rcon_table[5] = 32'h20000000;
assign rcon_table[6] = 32'h40000000;


assign rcon_out = (i < 4'd7) ? rcon_table[i] : rcon_table[6];

endmodule

