module alu_adder_rv32i (
    input  wire [31:0] in1,
    input  wire [31:0] in2,
    input  wire type,      // 0: Add, 1: Sub
    output wire [31:0] out
);
    // Perbaikan: Tambahkan [31:0] agar menjadi 32-bit
    wire [31:0] not_in2; 
    
    // Two's complement: Flip bits + 1
    assign not_in2 = ~in2 + 1'b1;

    wire [31:0] sum;
    wire [31:0] diff;

    assign sum  = in1 + in2;
    assign diff = in1 + not_in2;

    assign out = (type == 1'b0) ? sum : diff;

endmodule