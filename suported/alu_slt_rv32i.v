module alu_slt_rv32i(
    input wire [31:0] in1,
    input wire [31:0] in2,
    input wire [2:0] type,
    output wire [31:0] out
);
    wire slt_result;
    wire sltu_result;

    // Signed less than comparison
    assign slt_result = ($signed(in1) < $signed(in2)) ? 1'b1 : 1'b0;

    // Unsigned less than comparison
    assign sltu_result = (in1 < in2) ? 1'b1 : 1'b0;

    // Multiplexer to select the output based on type
    assign out = (type == 3'b000) ? {31'b0, slt_result} :
                 (type == 3'b001) ? {31'b0, sltu_result} :
                 32'b0; // Default case

endmodule