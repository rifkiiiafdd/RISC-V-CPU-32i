// Praktikum EL3011 Arsitektur Sistem Komputer 
// Modul        : 1
// Percobaan    : 1 
// Tanggal      : 04 November 2025 
// Nama (NIM) 1 : Rifki Afriadi (13223049) 
// Nama File    : instr_rom_rv32i.v 
// Deskripsi    : Instruction ROM 32x32 (RV32I) via ALTSYNCRAM + .mif 
`timescale 1ns/1ps 
 
module instr_rom_rv32i ( 
    input  wire        clock,   // diperlukan untuk ALTSYNCRAM 
    input  wire [31:0] PC,      // byte address 
    output wire [31:0] INSTR 
); 
  // Word index untuk 32 word 
  wire [4:0] waddr = PC[6:2]; 
 
  wire       inv_clock = ~clock; 
 
  altsyncram #( 
    .operation_mode("ROM"), 
    .width_a(32), 
    .widthad_a(5),                  // 32 word 
    .init_file("imemory_rv32i.mif"), 
    .outdata_reg_a("UNREGISTERED") 
  ) rom ( 
    .clock0   (inv_clock), // pembacaan secara efektif terjadi saat falling 
    .address_a(waddr), 
    .q_a      (INSTR), 
    .wren_a   (1'b0), 
    .data_a   (32'b0) 
  ); 
endmodule