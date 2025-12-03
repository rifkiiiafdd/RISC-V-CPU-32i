// Praktikum EL3011 Arsitektur Sistem Komputer 
// Modul        : 2 
// Percobaan    : TP nomor 1 
// Tanggal      : 18/11/2025
// Nama (NIM) 1 : Rifki AFriadi (13223049 )
// Nama File    : pc_rv32i.v 
// Deskripsi    : Menyimpan nilai PC saat ini dan mengupdate pada clock edge

module pc_rv32i(
    input wire [31:0] PCin,
    input wire rst,
    input wire clk,
    output reg [31:0] PCout
);

    always @(posedge clk or negedge rst) begin
        if (!rst)
            PCout <= 32'h0000_0000;
        else
            PCout <= PCin;
    end

endmodule