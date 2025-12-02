module alu_shifter_rv32i(
    input wire [31:0] in,
    input wire [31:0] shamt,
    input wire [2:0] type,
    output wire [31:0] out
);

    wire [31:0] sll_result;
    wire [31:0] srl_result;
    wire [31:0] sra_result;

    // Logical left shift
    assign sll_result = in << shamt;

    // Logical right shift
    assign srl_result = in >> shamt;

    // Arithmetic right shift
    assign sra_result = $signed(in) >>> shamt;

    // Multiplexer to select the output based on type
    assign out = (type == 3'b000) ? sll_result :
                 (type == 3'b001) ? srl_result :
                 (type == 3'b010) ? sra_result :
                 32'b0; // Default case


endmodule