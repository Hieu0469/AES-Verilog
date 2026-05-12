module top_tb;
reg clk;
reg [255:0] key;
reg [127:0] plaintext;
wire [127:0] ciphertext;
wire [127:0] key0,key1,key2,key3,key4,key5,key6,key7,key8,key9,key10,key11,key12,key13,key14;   
top t(
    .clk(clk),
    .key(key),
    .plaintext(plaintext),
    .ciphertext(ciphertext),
    .key0(key0),
    .key1(key1),
    .key2(key2),
    .key3(key3),
    .key4(key4),
    .key5(key5),
    .key6(key6),
    .key7(key7),
    .key8(key8),
    .key9(key9),
    .key10(key10),
    .key11(key11),
    .key12(key12),
    .key13(key13),
    .key14(key14)
);
initial begin
    clk = 0;
    key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
end

task run_case(input [127:0] pt, input integer id);
begin
    @(negedge clk);
    plaintext = pt;
    $display("Time %0t: Input PlainText[%0d] = %h", $time, id, plaintext);
    repeat(15) @(negedge clk);
    $display("Time %0t: Output CipherText[%0d] = %h", $time, id, ciphertext);
    $display("------------------------------");
end
endtask

initial begin
    run_case(128'h00112233445566778899aabbccddeeff, 0);
    run_case(128'h00000000000000000000000000000000, 1);
    run_case(128'hffffffffffffffffffffffffffffffff, 2);
    run_case(128'h0123456789abcdef0123456789abcdef, 3);
    run_case(128'habcdef0123456789abcdef0123456789, 4);
    run_case(128'hfedcba9876543210fedcba9876543210, 5);
    run_case(128'h1234567890abcdef1234567890abcdef, 6);
    repeat(15) @(negedge clk);
     $finish;
end


always #5 clk = ~clk;
endmodule