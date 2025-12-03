module alu_gate_rv32i (
    input wire [31:0] in1,
    input wire [31:0] in2,
    input wire [1:0] type,
    output wire [31:0] out
);
    wire [31:0] or_result;
    wire [31:0] and_result;
    wire [31:0] xor_result;

    assign or_result = in1 | in2;
    assign and_result = in1 & in2;
    assign xor_result = in1 ^ in2;

    assign out = (type == 2'b00) ? xor_result :
                 (type == 2'b01) ? or_result :
                 (type == 2'b10) ? and_result :
                 32'b0; // Default case


endmodule