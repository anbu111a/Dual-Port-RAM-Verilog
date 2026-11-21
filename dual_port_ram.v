module dual_port_ram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4,
    parameter DEPTH      = 16
)(
    input  wire                  clk,
    // Port A
    input  wire                  we_a,
    input  wire [ADDR_WIDTH-1:0] addr_a,
    input  wire [DATA_WIDTH-1:0] din_a,
    output reg  [DATA_WIDTH-1:0] dout_a,
    // Port B
    input  wire                  we_b,
    input  wire [ADDR_WIDTH-1:0] addr_b,
    input  wire [DATA_WIDTH-1:0] din_b,
    output reg  [DATA_WIDTH-1:0] dout_b
);

    // Memory array declaration
    reg [DATA_WIDTH-1:0] ram [0:DEPTH-1];

    // Port A operations
    always @(posedge clk) begin
        if (we_a) begin
            ram[addr_a] <= din_a;
        end else begin
            dout_a <= ram[addr_a];
        end
    end

    // Port B operations
    always @(posedge clk) begin
        if (we_b) begin
            ram[addr_b] <= din_b;
        end else begin
            dout_b <= ram[addr_b];
        end
    end

endmodule
