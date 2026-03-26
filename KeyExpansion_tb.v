module key_expansion_tb();
    wire [127:0] key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10,key_11,key_12,key_13,key_14;
    reg [255:0] key;
    reg clk;

    key_expansion ke(
        .key(key),
        .key_1(key_1),
        .key_2(key_2),
        .key_3(key_3),
        .key_4(key_4),
        .key_5(key_5),
        .key_6(key_6),
        .key_7(key_7),
        .key_8(key_8),
        .key_9(key_9),
        .key_10(key_10),
        .key_11(key_11),
        .key_12(key_12),
        .key_13(key_13),
        .key_14(key_14),
        .clk(clk)
    );
initial begin
    clk = 0;
    forever begin
        #5 clk = ~clk;
    end
end

initial begin
    key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
    #160; // Wait for the key expansion to complete
    $display("Key 1: %h", key_1);
    $display("Key 2: %h", key_2);
    $display("Key 3: %h", key_3);
    $display("Key 4: %h", key_4);
    $display("Key 5: %h", key_5);
    $display("Key 6: %h", key_6);
    $display("Key 7: %h", key_7);
    $display("Key 8: %h", key_8);
    $display("Key 9: %h", key_9);
    $display("Key 10: %h", key_10);
    $display("Key 11: %h", key_11);
    $display("Key 12: %h", key_12);
    $display("Key 13: %h", key_13);
    $display("Key 14: %h", key_14);
end
endmodule