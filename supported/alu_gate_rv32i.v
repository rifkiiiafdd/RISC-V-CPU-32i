module alu_gate_rv32i (
    input wire [31:0] in1,
    input wire [31:0] in2,
    input wire [2:0] type,
    output wire [31:0] out
);
    wire [31:0] or_result;
    wire [31:0] and_result;
    wire [31:0] xor_result;

    assign or_result = in1 | in2;
    assign and_result = in1 & in2;
    assign xor_result = in1 ^ in2;

    assign out = (type == 3'b000) ? xor_result :
                 (type == 3'b001) ? or_result :
                 (type == 3'b010) ? and_result :
                 32'b0; // Default case


endmodule