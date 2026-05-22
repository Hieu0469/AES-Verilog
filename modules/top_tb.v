`timescale 1ns / 1ps

module tb_top;

// Khai báo tín hiệu cho DUT (Device Under Test)
reg clk;
reg [255:0] key;
reg [127:0] plaintext;
wire [127:0] ciphertext;

// Instantiate module top
top dut (
    .clk(clk),
    .key(key),
    .plaintext(plaintext),
    .ciphertext(ciphertext)
);

// --- KHỐI GIẢI MÃ (DECRYPTION) ĐỂ KIỂM TRA ---
wire [127:0] dec_state[0:14];

decrypt_round dr0 (.state_in(ciphertext),   .round_key(dut.ke.key_14), .is_final(1'b1), .state_out(dec_state[0]));
decrypt_round dr1 (.state_in(dec_state[0]), .round_key(dut.ke.key_13), .is_final(1'b0), .state_out(dec_state[1]));
decrypt_round dr2 (.state_in(dec_state[1]), .round_key(dut.ke.key_12), .is_final(1'b0), .state_out(dec_state[2]));
decrypt_round dr3 (.state_in(dec_state[2]), .round_key(dut.ke.key_11), .is_final(1'b0), .state_out(dec_state[3]));
decrypt_round dr4 (.state_in(dec_state[3]), .round_key(dut.ke.key_10), .is_final(1'b0), .state_out(dec_state[4]));
decrypt_round dr5 (.state_in(dec_state[4]), .round_key(dut.ke.key_9),  .is_final(1'b0), .state_out(dec_state[5]));
decrypt_round dr6 (.state_in(dec_state[5]), .round_key(dut.ke.key_8),  .is_final(1'b0), .state_out(dec_state[6]));
decrypt_round dr7 (.state_in(dec_state[6]), .round_key(dut.ke.key_7),  .is_final(1'b0), .state_out(dec_state[7]));
decrypt_round dr8 (.state_in(dec_state[7]), .round_key(dut.ke.key_6),  .is_final(1'b0), .state_out(dec_state[8]));
decrypt_round dr9 (.state_in(dec_state[8]), .round_key(dut.ke.key_5),  .is_final(1'b0), .state_out(dec_state[9]));
decrypt_round dr10(.state_in(dec_state[9]), .round_key(dut.ke.key_4),  .is_final(1'b0), .state_out(dec_state[10]));
decrypt_round dr11(.state_in(dec_state[10]),.round_key(dut.ke.key_3),  .is_final(1'b0), .state_out(dec_state[11]));
decrypt_round dr12(.state_in(dec_state[11]),.round_key(dut.ke.key_2),  .is_final(1'b0), .state_out(dec_state[12]));
decrypt_round dr13(.state_in(dec_state[12]),.round_key(dut.ke.key_1),  .is_final(1'b0), .state_out(dec_state[13]));

wire [127:0] decrypted_plaintext;
addRoundKey ark_final(.data(dec_state[13]), .key(dut.ke.key_0), .out(decrypted_plaintext));
// ----------------------------------------------

// Tạo xung clock 100MHz (Chu kỳ 10ns)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Các biến dùng để đọc file CSV trong Verilog
integer fd;
integer f_out;
integer status;
integer i;

// Tạo một thanh ghi lớn để chứa chuỗi text (giả sử tối đa 1000 ký tự mỗi dòng)
// Mỗi ký tự chiếm 8 bit, nên cần 8 * 1000 = 8000 bit
reg [8000-1:0] line; 

// Các biến lưu trữ dữ liệu parse từ CSV
integer index_val;
reg [160-1:0] type_val; // Chứa tối đa 20 ký tự text
reg [255:0] key_val;
reg [127:0] pt_val;
reg [127:0] exp_val;
reg [127:0] got_val;
integer pass_val;

integer error_count;

initial begin
    error_count = 0;
    
    // Mở file CSV (Lưu ý: Đổi thành ĐƯỜNG DẪN TUYỆT ĐỐI nếu Vivado không tìm thấy)
    fd = $fopen("results/sim_cases.csv", "r");
    if (fd == 0) begin
        $display("LỖI: Khong the mo file sim_cases.csv. Vui long kiem tra lai duong dan.");
        $finish;
    end

    f_out = $fopen("results/debug_dump.txt", "w");
    if (f_out == 0) begin
        $display("LỖI: Khong the tao file debug_dump.txt.");
        $finish;
    end

    // Đọc và bỏ qua dòng tiêu đề đầu tiên
    status = $fgets(line, fd);

    $display("BAT DAU MO PHONG...");
    
    // Khởi tạo tín hiệu mặc định
    key = 0;
    plaintext = 0;
    @(posedge clk);

    // Đọc từng dòng cho đến khi hết file
    while (!$feof(fd)) begin
        line = 0; // Xóa buffer
        status = $fgets(line, fd);
        
        if (status > 0) begin
            
            // Trình mô phỏng Verilog truyền thống không hỗ trợ sscanf với dấu phẩy tốt,
            // Ta duyệt qua từng byte trong mảng để thay dấu phẩy (mã ASCII là 8'h2C) 
            // thành khoảng trắng (mã ASCII là 8'h20)
            for (i = 0; i < 1000; i = i + 1) begin
                if (line[i*8 +: 8] == 8'h2C) begin 
                    line[i*8 +: 8] = 8'h20;
                end
            end

            // Phân tích cú pháp chuỗi hex và số sau khi đã biến phẩy thành khoảng trắng
            status = $sscanf(line, "%d %s %h %h %h %h %d", 
                                index_val, type_val, key_val, pt_val, exp_val, got_val, pass_val);

            // Nếu đọc đủ 7 trường dữ liệu của 1 dòng
            if (status == 7) begin
                // 1. Cấp tín hiệu đầu vào cho module
                key = key_val;
                plaintext = pt_val;

                // Thêm delay khởi tạo (warm-up) đặc biệt cho testcase đầu tiên (index 0)
                // giống như logic trong test_aes256.py (chờ warmup key schedule)
                if (index_val == 0) begin
                    repeat(8) @(posedge clk);
                end

                // 2. Chờ dữ liệu lan truyền qua 15 tầng pipeline (15 clock cycles)
                repeat(15) @(posedge clk);

                // 3. Đợi thêm 1 chút sau sườn dương clock để tín hiệu ổn định trước khi kiểm tra
                #1; 

                // 4. So sánh kết quả đầu ra (Không bỏ qua testcase 0 nữa)
                if (ciphertext !== exp_val) begin
                    $display("LOI tai index %0d:", index_val);
                    error_count = error_count + 1;
                end else begin
                    $display("THANH CONG tai index %0d", index_val);
                end

                // Ghi ra file debug_dump.txt
                $fdisplay(f_out, "===============");
                if (ciphertext === exp_val)
                    $fdisplay(f_out, "Testcase %0d: PASS", index_val);
                else
                    $fdisplay(f_out, "Testcase %0d: FAIL", index_val);
                
                $fdisplay(f_out, "index: %0d", index_val);
                // Bỏ qua các ký tự null (\0) khi in type
                $fdisplay(f_out, "type: %s", type_val);
                $fdisplay(f_out, "key: %064x", key);
                $fdisplay(f_out, "plaintext: %032x", plaintext);
                $fdisplay(f_out, "expected: %032x", exp_val);
                $fdisplay(f_out, "got: %032x", ciphertext);
                if (ciphertext === exp_val)
                    $fdisplay(f_out, "pass: 1");
                else
                    $fdisplay(f_out, "pass: 0");
                $fdisplay(f_out, "sau_khi_decrypt: %032x", decrypted_plaintext);
                $fdisplay(f_out, "===========");
                
                // Nhả 2 nhịp clock để tách biệt các test case trên waveform
                repeat(2) @(posedge clk);
            end
        end
    end

    $fclose(fd);
    $fclose(f_out);
    
    $display("========================================");
    if (error_count == 0)
        $display("MO PHONG HOAN TAT: PASS TOAN BO CAC TEST CASES!");
    else
        $display("MO PHONG HOAN TAT: CO %0d LOI KHONG TRUNG KHOP.", error_count);
    $display("========================================");
    
    $finish;
end

// Block hỗ trợ xuất dạng sóng ra file .vcd (Dành cho Icarus Verilog hoặc ModelSim)
initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_top);
end

endmodule