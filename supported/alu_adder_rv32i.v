module alu_adder_rv32i (
    input  wire [31:0] in1,      // First operand
    input  wire [31:0] in2,      // Second operand
    input wire type,
    output wire [31:0] out     // Sum output
);
    // Combinational logic for 32-bit adder
    wire not_in2;
    assign not_in2 = ~in2 + 1;

    wire [31:0] sum;
    wire [31:0] diff;

    assign sum = in1 + in2;
    assign diff = in1 + not_in2;

    assign out = (type == 1'b0) ? sum : diff;

endmodule