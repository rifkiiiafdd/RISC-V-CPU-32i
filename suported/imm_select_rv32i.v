// Praktikum EL3011 Arsitektur Sistem Komputer 
// Modul        : 2 
// Percobaan    : 1
// Tanggal      : 18/11/2025
// Nama (NIM) 1 : Rifki AFriadi (13223049 )
// Nama File    : imm_select_rv32i.v 
// Deskripsi    : Immediate Selector  
    
module imm_select_rv32i( 
    input wire [24:0] trimmed_instr, // Trimmed instruction, 25 MSB from instr 
    input wire [2:0]  cu_immtype,    // I-type = 3'b000, S-type = 3'b001, 
                                     // B-type = 3'b010, U-type = 3'b011, 
                                     // J-type = 3'b100 
 
    output reg [31:0] imm            // 32-bit immediate 
); 
 
    always @ (*) 
    begin 
        case (cu_immtype) 
            3'b000: // I-type 
                imm = {{20{trimmed_instr[24]}}, trimmed_instr[24:13]}; 
            3'b001: // S-type 
                imm = {{20{trimmed_instr[24]}}, trimmed_instr[24:18], trimmed_instr[4:0]}; 
            3'b010: // B-type 
                imm = {{19{trimmed_instr[24]}}, trimmed_instr[24], trimmed_instr[0], trimmed_instr[23:18], trimmed_instr[4:1], 1'b0}; 
            3'b011: // U-type 
                imm = {trimmed_instr[24:5], 12'b0}; 
            3'b100: // J-type 
                imm = {{11{trimmed_instr[24]}}, trimmed_instr[24], trimmed_instr[12:5], trimmed_instr[13], trimmed_instr[23:14], 1'b0}; 
            default: 
                imm = 32'd0; 
        endcase 
    end 
 
endmodule 