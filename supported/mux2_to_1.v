// Praktikum EL3011 Arsitektur Sistem Komputer 
// Modul        : 2 
// Percobaan    : TP nomor 1 
// Tanggal      : 18/11/2025
// Nama (NIM) 1 : Rifki AFriadi (13223049 )
// Nama File    : mux2_to_1 .v 
// Deskripsi    : Memilih salah satu dari dua input berdasarkan sinyal seleksi
 

module mux2_to_1

(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire s,
    output reg [31:0] Y
    
);

    always @(*) begin

        if (s == 1'b0) begin
            Y = A;
        end else begin
            Y = B;
        end


    end

endmodule