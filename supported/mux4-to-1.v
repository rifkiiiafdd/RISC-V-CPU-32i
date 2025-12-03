module mux4_to_1 (
    input  wire [31:0] W,  // Input 0
    input  wire [31:0] X,  // Input 1
    input  wire [31:0] Y,  // Input 2
    input  wire [31:0] Z,  // Input 3
    input  wire [1:0] sel,        // 2-bit select signal
    output wire [31:0] data_out   // Output data
);

    // Combinational logic for 4-to-1 multiplexer
    assign data_out = (sel == 2'b00) ? W :
                      (sel == 2'b01) ? X :
                      (sel == 2'b10) ? Y :
                                       Z;
endmodule

