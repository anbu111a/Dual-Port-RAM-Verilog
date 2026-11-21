`timescale 1ns / 1ps

module dual_port_ram_tb;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;
    parameter DEPTH      = 16;

    reg                   clk;
    reg                   we_a, we_b;
    reg  [ADDR_WIDTH-1:0] addr_a, addr_b;
    reg  [DATA_WIDTH-1:0] din_a, din_b;
    wire [DATA_WIDTH-1:0] dout_a, dout_b;

    // Instantiate the Unit Under Test (UUT)
    dual_port_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DEPTH(DEPTH)
    ) uut (
        .clk(clk),
        .we_a(we_a), .addr_a(addr_a), .din_a(din_a), .dout_a(dout_a),
        .we_b(we_b), .addr_b(addr_b), .din_b(din_b), .dout_b(dout_b)
    );

    // Clock generation (10ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        we_a = 0; we_b = 0;
        addr_a = 0; addr_b = 0;
        din_a = 0; din_b = 0;

        // 1. Simultaneous write to different addresses
        #10;
        we_a = 1; addr_a = 4'h1; din_a = 8'hAA;
        we_b = 1; addr_b = 4'h2; din_b = 8'h55;

        // 2. Simultaneous read from both addresses
        #10;
        we_a = 0; addr_a = 4'h2; // Expect 8'h55 on dout_a
        we_b = 0; addr_b = 4'h1; // Expect 8'hAA on dout_b

        // 3. Port A writes while Port B reads
        #10;
        we_a = 1; addr_a = 4'h3; din_a = 8'hF0;
        we_b = 0; addr_b = 4'h2;

        #10;
        we_a = 0; addr_a = 4'h3; // Verify write at 4'h3

        #20;
        $finish;
    end

endmodule
