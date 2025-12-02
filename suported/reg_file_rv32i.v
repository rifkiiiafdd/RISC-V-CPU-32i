// Praktikum EL3011 Arsitektur Sistem Kompter 
// Modul        : 1
// Percobaan    : 1 
// Tanggal      : 04 November 2025 
// Nama (NIM) 1 : Rifki Afriadi (13223049) 
// Nama File    : reg_file_rv32i.v 
// Deskripsi    : Register file RV32I, 32x32, 2 read ports, 1 write port. 
// x0 selalu 0; write @posedge, read @negedge  
`timescale 1ns/1ps 
module reg_file_rv32i ( 
    input  wire        clock,         // global clock 
    input  wire        cu_rdwrite,    // write enable dari CU 
    input  wire [4:0]  rs1_addr,      // alamat baca port 1 
    input  wire [4:0]  rs2_addr,      // alamat baca port 2 
    input  wire [4:0]  rd_addr,       // alamat tulis (write-back) 
    input  wire [31:0] rd_in,         // data tulis (write-back data) 
    output wire [31:0] rs1,           // data baca port 1 
    output wire [31:0] rs2            // data baca port 2 
); 
  // 32 register x 32-bit 
  reg [31:0] rf [0:31]; 
 
  integer i; 
  initial begin 
    for (i = 0; i < 32; i = i + 1) rf[i] = 32'b0;  // untuk simulasi 
  end 
 
  // Tulis @posedge; tulis ke x0 diabaikan. Jaga x0 selalu nol. 
  always @ (posedge clock) begin 
    if (cu_rdwrite && (rd_addr != 5'd0)) 
      rf[rd_addr] <= rd_in; 
    rf[0] <= 32'b0; 
  end 
 
  // Baca asinkron 
    assign rs1 = (rs1_addr == 5'd0) ? 32'b0 : rf[rs1_addr]; 
    assign rs2 = (rs2_addr == 5'd0) ? 32'b0 : rf[rs2_addr]; 
    
endmodule