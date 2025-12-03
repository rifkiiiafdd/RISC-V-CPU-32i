// Praktikum EL3011 Arsitektur Sistem Komputer 
// Modul        : 2 
// Percobaan    : TP nomor 2
// Tanggal      : 18/11/2025
// Nama (NIM) 1 : Rifki AFriadi (13223049 )
// Nama File    : pc_4_adder_rv32i.v 
// Deskripsi    : Menambahkan 4 ke nilai PC saat ini
 

module pc_4_adder_rv32i (
    input wire [31:0] PCold,
    output wire [31:0] PC_4_inc
);

    assign PC_4_inc = PCold + 32'd4;

endmodule