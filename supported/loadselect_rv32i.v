module loadselect_rv32i(
    input wire [31:0] dmem_data,
    input wire [2:0] load_type,
    output reg [31:0] load_out
);

    always @(*) begin
        case (load_type)
            3'b000: begin // LB
                load_out = {{24{dmem_data[7]}}, dmem_data[7:0]};
            end
            3'b001: begin // LH
                load_out = {{16{dmem_data[15]}}, dmem_data[15:0]};
            end
            3'b010: begin // LW
                load_out = dmem_data;
            end
            3'b011: begin // LBU
                load_out = {24'b0, dmem_data[7:0]};
            end
            3'b100: begin // LHU
                load_out = {16'b0, dmem_data[15:0]};
            end
            default: begin
                load_out = 32'b0; // Default case to avoid latches
            end
        endcase
    end



endmodule