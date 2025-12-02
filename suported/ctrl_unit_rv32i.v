// Praktikum EL3011 Arsitektur Sistem Komputer 
// Modul        : 2 
// Percobaan    : 1
// Tanggal      : 18/11/2025
// Nama (NIM) 1 : Rifki AFriadi (13223049 )
// Nama File    : ctrl_unit_rv32i.v 
// Deskripsi    : Men-generate sinyal kontrol berdasarkan opcode, funct3, dan funct7

module ctrl_unit_rv32i ( 
    input wire [6:0] opcode,        // R = 7'h33   , I = 7'h13  , Load = 7'h3, 
                                    // S = 7'h23   , B = 7'h63  , JAL = 7'h6F, 
                                    // JALR = 7'h67, LUI = 7'h37, AUIPC = 7'h17 
    input wire [2:0] funct3, 
    input wire [6:0] funct7, 
 
    output reg       cu_ALU1src,    // rs1 = 1'b0, PC = 1'b1 
    output reg       cu_ALU2src,    // rs2 = 1'b0, imm = 1'b1 
    output reg [2:0] cu_immtype,    // I-type = 3'b000, S-type = 3'b001, 
                                    // B-type = 3'b010, U-type = 3'b011, 
                                    // J-type = 3'b100 
    output reg [1:0] cu_ALUtype,    // ADD/SUB = 2'b00, GATE = 2'b01, 
                                    // SHIFT = 2'b10  , SLT = 2'b11 
    output reg       cu_adtype,     // ADD = 1’b0, SUB = 1’b1 
    output reg [1:0] cu_gatype,     // AND = 2'b00, OR = 2'b01, XOR = 2'b10 
    output reg [1:0] cu_shiftype,   // SLL = 2'b00, SRL = 2'b01, SRA = 2'b11 
    output reg       cu_sltype,     // Signed = 1'b0, Unsigned = 1'b1 
    output reg [1:0] cu_rdtype,     // From ALU = 2'b00 , from memory = 2'b01, 
                                    // from PC+4 = 2'b10, 
                                    // from immediate = 2'b11 
    output reg       cu_rdwrite,    // Enable write to rd = 1'b1 
    output reg [2:0] cu_loadtype,   // Load byte = 3'b000, load half = 3'b001 , 
                                    // load word = 3'b010, load ubyte = 3'b011, 
                                    // load uhalf = 3'b100 
    output reg       cu_store,      // Store to memory = 1'b1 
    output reg [1:0] cu_storetype,  // Store byte = 2'b00, store half = 2'b01, 
                                    // store word = 2'b10 
    output reg       cu_branch,     // Enable branching = 1'b1 
    output reg [2:0] cu_branchtype, // BEQ  = 3'b000, BGE = 3'b001, 
                                    // BGEU = 3'b010, BLT = 3'b011, 
                                    // BLTU = 3'b100, BNE = 3'b101 
    output reg       cu_PCtype      // PC += 4 = 1'b0, PC = ALU = 1'b1 
); 
    always @ (*)

       begin 
        cu_ALU1src    = 1'b0;   // From rs1 by default 
        cu_ALU2src    = 1'b0;   // From rs2 by default 
        cu_immtype    = 3'b000; // I-type immediate by default 
        cu_ALUtype    = 2'b00;  // ADD/SUB by default 
        cu_adtype     = 1'b0;   // Addition by default 
        cu_gatype     = 2'b00;  // AND by default 
        cu_shiftype   = 2'b00;  // SLL by default 
        cu_sltype     = 1'b0;   // SLT by default 
        cu_rdtype     = 2'b00;  // From ALU by default 
        cu_rdwrite    = 1'b0;   // No by default 
        cu_loadtype   = 3'b000; // Byte by default 
        cu_store      = 1'b0;   // No by default 
        cu_storetype  = 2'b00;  // Byte by default 
        cu_branch     = 1'b0;   // No by default 
        cu_branchtype = 3'b000; // BEQ by default 
        cu_PCtype     = 1'b0;   // PC += 4 by default 
 
        case (opcode) 
            7'h33:  // R-type 
            begin 
                cu_rdwrite = 1'b1; 
                case (funct3) 
                    3'h0: // ADD/SUB operation, addition by default 
                    begin 
                        if (funct7 == 7'h20) // Subtraction 
                            cu_adtype = 1'b1; 
                    end 
                    3'h1: // SLL 
                        cu_ALUtype = 2'b10; // Shift operation 
                    3'h2: // SLT 
                        cu_ALUtype = 2'b11; // SLT operation 
                    3'h3: // SLTU 
                    begin 
                        cu_ALUtype = 2'b11; // SLT operation 
                        cu_sltype = 1'b1; 
                    end 
                    3'h4: // XOR 
                    begin 
                        cu_ALUtype = 2'b01; // Gate operation 
                        cu_gatype = 2'b10; 
                    end 
                    3'h5: // SR 
                    begin 
                        cu_ALUtype = 2'b10; // Shift operation 
                        if (funct7 == 7'h00)  
                            cu_shiftype = 2'b01; // SRL 
                        else  
                            cu_shiftype = 2'b11; // SRA 
                    end 
                    3'h6: // OR 
                    begin 
                        cu_ALUtype = 2'b01; // Gate operation 
                        cu_gatype = 2'b01; 
                    end 
                    3'h7: // AND 
                        cu_ALUtype = 2'b01; // Gate operation 
                endcase 
            end 
             
            7'h13: // I-type, addi by default 
            begin 
                cu_ALU2src = 1'b1; 
                cu_rdwrite = 1'b1; 
                case (funct3) 
                    3'h0: // ADDI 
                        ; 
                    3'h1: // SLLI 
                    begin 
                        cu_ALUtype = 2'b10; // Shift operation 
                    end 
                    3'h2: // SLTI 
                    begin 
                        cu_ALUtype = 2'b11; // SLT operation 
                    end 
                    3'h3: // SLTIU 
                    begin 
                        cu_ALUtype = 2'b11; // SLT operation 
                        cu_sltype = 1'b1; 
                    end 
                    3'h4: // XORI 
                    begin 
                        cu_ALUtype = 2'b01; // Gate operation 
                        cu_gatype = 2'b10; 
                    end 
                    3'h5: // Shift
                    begin 
                        cu_ALUtype = 2'b10; // Shift operation 
                        if (funct7 == 7'h00)  
                            cu_shiftype = 2'b01; // Srli
                        else  
                            cu_shiftype = 2'b11; // Srai
                    end 
                    3'h6: // ORI 
                    begin   
                        cu_ALUtype = 2'b01; // Gate operation 
                        cu_gatype = 2'b01; 
                    end 
                    3'h7: // ANDI 
                    begin
                        cu_ALUtype = 2'b01; // Gate operation
                    end 
                endcase 
            end 
             
            7'h3: // Load 
            begin 
                 // Tambah untuk case load (lb, lh, lw, lbu, dan lhu) 
                 case (funct3) 
                    3'h0: // LB 
                    begin 
                        cu_rdwrite = 1'b1; 
                        cu_rdtype  = 2'b01;  // from memory
                        cu_ALU2src = 1'b1; 
                        cu_loadtype= 3'b000; // load byte 
                    end 
                    3'h1: // LH 
                    begin 
                        cu_rdwrite = 1'b1; 
                        cu_rdtype  = 2'b01;  // from memory
                        cu_ALU2src = 1'b1; 
                        cu_loadtype= 3'b001; // load half 
                    end 
                    3'h2: // LW 
                    begin 
                        cu_rdwrite = 1'b1; 
                        cu_rdtype  = 2'b01;  // from memory
                        cu_ALU2src = 1'b1; 
                        cu_loadtype= 3'b010; // load word 
                    end 
                    3'h4: // LBU 
                    begin 
                        cu_rdwrite = 1'b1; 
                        cu_rdtype  = 2'b01;  // from memory
                        cu_ALU2src = 1'b1; 
                        cu_loadtype= 3'b011; // load ubyte 
                    end 
                    3'h5: // LHU 
                    begin 
                        cu_rdwrite = 1'b1; 
                        cu_rdtype  = 2'b01;  // from memory
                        cu_ALU2src = 1'b1; 
                        cu_loadtype= 3'b100; // load uhalf 
                    end
                    endcase 
            end     
             
            7'h23: // S-type 
            begin 
               
                  cu_store     = 1'b1; 
                  cu_ALU2src  = 1'b1; 
                  cu_immtype  = 3'b001; // S-type immediate 
                  // Tambah untuk case store (sw, sh, sb) 
                  case (funct3) 
                      3'h0: // SB 
                      begin 
                            cu_storetype= 2'b00; // store byte 
                      end 
                      3'h1: // SH 
                      begin 
                            
                            cu_storetype= 2'b01; // store half 
                      end 
                      3'h2: // SW 
                      begin 
                            
                            cu_storetype= 2'b10; // store word 
                      end 
                      endcase

            end 
             
            7'h63: // B-type 
            begin 
                 // Tambah untuk case branch (beq, bne, blt, bltu, bge, bgeu) 
                 case (funct3) 
                    3'h0: // BEQ 
                    begin 
                        cu_ALU1src   = 1'b1;   // From rs1
                        cu_ALU2src   = 1'b1;   // From rs2
                        cu_immtype   = 3'b010; // B-type immediate
                        cu_branch    = 1'b1;   // Enable branching
                        cu_PCtype    = 1'b1;   // PC = ALU
                        cu_branchtype= 3'b000; // BEQ 
                    end 
                    3'h1: // BNE 
                    begin 
                        cu_ALU1src   = 1'b1;   // From rs1
                        cu_ALU2src   = 1'b1;   // From rs2
                        cu_immtype   = 3'b010; // B-type immediate
                        cu_branch    = 1'b1;   // Enable branching
                        cu_PCtype    = 1'b1;   // PC = ALU
                        cu_branchtype= 3'b101; // BGEU  
                    end 
                    3'h4: // BLT 
                    begin 
                        cu_ALU1src   = 1'b1;   // From rs1
                        cu_ALU2src   = 1'b1;   // From rs2
                        cu_immtype   = 3'b010; // B-type immediate
                        cu_branch    = 1'b1;   // Enable branching
                        cu_PCtype    = 1'b1;   // PC = ALU
                        cu_branchtype= 3'b011; // BGEU 
                    end 
                    3'h5: // BGE 
                    begin 
                        cu_ALU1src   = 1'b1;   // From rs1
                        cu_ALU2src   = 1'b1;   // From rs2
                        cu_immtype   = 3'b010; // B-type immediate
                        cu_branch    = 1'b1;   // Enable branching
                        cu_PCtype    = 1'b1;   // PC = ALU
                        cu_branchtype= 3'b001; // BGEU 
                    end 
                    3'h6: // BLTU 
                    begin 
                        
                        cu_ALU1src   = 1'b1;   // From rs1
                        cu_ALU2src   = 1'b1;   // From rs2
                        cu_immtype   = 3'b010; // B-type immediate
                        cu_branch    = 1'b1;   // Enable branching
                        cu_PCtype    = 1'b1;   // PC = ALU
                        cu_branchtype= 3'b100; // BGEU 
                    end 
                    3'h7: // BGEU 
                    begin 
                        cu_ALU1src   = 1'b1;   // From rs1
                        cu_ALU2src   = 1'b1;   // From rs2
                        cu_immtype   = 3'b010; // B-type immediate
                        cu_branch    = 1'b1;   // Enable branching
                        cu_PCtype    = 1'b1;   // PC = ALU
                        cu_branchtype= 3'b010; // BGEU 
                    end
                    endcase
            end 
             
            7'h37: // LUI 
            begin 
                cu_ALU2src = 1'b1;
                cu_immtype = 3'b011; // U-type immediate
                cu_rdwrite = 1'b1;
                cu_rdtype  = 2'b11;  // from immediate

            end 
             
            7'h17: // AUIPC 
            begin 
                cu_ALU1src = 1'b1; 
                cu_ALU2src = 1'b1; 
                cu_immtype = 3'b011; // U-type immediate 
                cu_rdwrite = 1'b1; 
                
            end 
            7'h6F: // JAL-type 
            begin 
                cu_ALU1src = 1'b1; 
                cu_ALU2src = 1'b1; 
                cu_immtype = 3'b100; // J-type immediate 
                cu_branch = 1'b1;
                cu_rdwrite = 1'b1; 
                cu_rdtype  = 2'b10;  // from PC+4 
                cu_PCtype  = 1'b1;   // PC = ALU
            end 
             
            7'h67: // JALR 
            begin 
                cu_ALU1src = 1'b0; 
                cu_ALU2src = 1'b1; 
                cu_immtype = 3'b000; // I-type immediate 
                cu_branch = 1'b1;
                cu_rdwrite = 1'b1; 
                cu_rdtype  = 2'b10;  // from PC+4 
                cu_PCtype  = 1'b1;   // PC = ALU
            end 
        endcase 
    end 
 
endmodule 
 