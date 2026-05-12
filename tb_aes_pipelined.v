module tb_top_pipelined;
    reg clk;
    reg rst;
    reg [255:0] key;
    reg [127:0] plaintext;
    reg valid_in;
    wire [127:0] ciphertext;
    wire valid_out;

    // Instantiate the pipelined AES module
    top_pipelined uut (
        .clk(clk),
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext),
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
        plaintext = 128'h00112233445566778899aabbccddeeff;
        // Wait for reset deassertion

        // Apply test vector
        // Wait for the output to be valid        
        // Display the results
        $display("Ciphertext: %h", ciphertext);

        // Finish simulation
        #10 $finish;
    end
endmodule