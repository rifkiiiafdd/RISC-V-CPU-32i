// Praktikum EL3011 Arsitektur Sistem Komputer 
// Modul        : 1
// Percobaan    : 1 
// Tanggal      : 04 November 2025 
// Nama (NIM) 1 : Rifki Afriadi (13223049) 
// Nama File    : data_mem_rv32i.v 
// Deskripsi    : Data Memory 256 x 32-bit (RV32I) via ALTSYNCRAM 
 
`timescale 1ns/1ps 
module data_mem_rv32i ( 
    input  wire        clock, 
    input  wire        cu_store,        // WE dari CU 
    input  wire [1:0]  cu_storetype,    // 00=SW, 01=SH, 10=SB 
    input  wire [31:0] dmem_addr,       // byte address 
    input  wire [31:0] rs2,             // data tulis 
    output wire [31:0] dmem_out         // data baca (async) 
); 
  wire [7:0] waddr = dmem_addr[9:2]; 
 
  reg  [3:0] be; 
  always @* begin 
    case (cu_storetype) 
      2'b00: be = 4'b1111;                                      // SW 
      2'b01: be = (dmem_addr[1]) ? 4'b1100 : 4'b0011;           // SH 
      2'b10: case (dmem_addr[1:0])                               // SB 
               2'b00: be = 4'b0001; 
               2'b01: be = 4'b0010; 
               2'b10: be = 4'b0100; 
               default: be = 4'b1000; 
             endcase 
      default: be = 4'b0000; 
    endcase 
  end 
 
  reg [31:0] wr_data_aligned; 
  always @* begin 
    case (cu_storetype) 
      2'b00: wr_data_aligned = rs2;                              // SW 
      2'b01: wr_data_aligned = (dmem_addr[1]) ? {rs2[15:0],16'b0} 
                                              : {16'b0,rs2[15:0]};// SH 
      2'b10: case (dmem_addr[1:0])                               // SB 
               2'b00: wr_data_aligned = {24'b0, rs2[7:0]}; 
               2'b01: wr_data_aligned = {16'b0, rs2[7:0], 8'b0}; 
                2'b10: wr_data_aligned = {8'b0,  rs2[7:0], 16'b0}; 
                default: wr_data_aligned = {rs2[7:0], 24'b0}; 
            endcase 
        default: wr_data_aligned = 32'b0; 
    endcase 
end 

wire clk_n = ~clock;          // <<< write @negedge sistem 

wire [31:0] q_ram; 
altsyncram #( 
    .operation_mode   ("SINGLE_PORT"), 
    .width_a          (32), 
    .widthad_a        (8), 
    .outdata_reg_a    ("UNREGISTERED"),  // read async 
    .init_file        ("dmemory.mif"), 
    .width_byteena_a  (4) 
) ram ( 
    .clock0    (clk_n),                 // <<< pakai clock terbalik 
    .wren_a    (cu_store), 
    .address_a (waddr), 
    .data_a    (wr_data_aligned), 
    .q_a       (q_ram), 
    .byteena_a (be) 
); 

    assign dmem_out = q_ram;      // <<< read "setiap saat" 
endmodule