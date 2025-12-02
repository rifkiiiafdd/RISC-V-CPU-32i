// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 3
// Percobaan : 2
// Tanggal : <isi>
// Nama (NIM) 1 : <isi>
// Nama (NIM) 2 : <isi>
// Nama File : toplevel_rv32i.v
// Deskripsi : RV32I Top Level

module toplevel_rv32i(
    input wire clock,
    input wire reset,
    // Sinyal-sinyal intermediat terekspos
    output wire [31:0] PC, PC_in, instr,
    output wire [6:0] opcode, funct7,
    output wire [2:0] funct3,
    output wire [4:0] rs1_addr, rs2_addr, rd_addr,
    output wire [31:0] ALU_in1, ALU_in2, ALU_output,
    output wire [31:0] dmem_addr, dmem_out, load_out, rd_in
);
 //----------------------------INSTRUCTION FETCH----------------------------//
    wire [31:0] PC_4_add, PC_jump, PC_new;

    // Sesuaikan dengan nama modul 2-to-1 multiplexer generik Anda
   assign PC_jump = ALU_output; // ALU output memberikan alamat jump
   // jika s=0, A
    mux2_to_1 blok_21mux_jumper(
    .A(PC_4_add),
    .B(PC_jump),
    .selector(cu_PCtype),
    .Y(PC_new)
 );

    wire [31:0] PC_branch, rs1, rs2;
    wire cu_branch;

    assign PC_branch = ALU_output; // ALU output memberikan alamat branch

    wire [2:0] cu_branchtype;
    brancher_rv32i blok_brancher(
    .PC_new(PC_new),
    .PC_branch(PC_branch),
    .in1(rs1),
    .in2(rs2),
    .cu_branch(cu_branch),
    .cu_branchtype(cu_branchtype),
    .PC_in(PC_in)
    );

    wire [31:0] PC_out;
    pc_rv32i blok_pc(
    .clk(clock),
    .rst(reset),
    .PC_in(PC_in),

    .PC_out(PC_out)
    );

    assign PC = PC_out;

    pc_4_adder_rv32i blok_4adder(
    .PCold(PC_out),
    .PC_4_inc(PC_4_add)
    );

    instr_rom_rv32i blok_imem(
    .clock(clock),
    .PC(PC_out),
    .INSTR(instr)
    );


   reg_file_rv32i blok_reg ( 
      .clock(clock),         // global clock 
      .cu_rdwrite(cu_rdwrite),    // write enable dari CU 
      .rs1_addr(rs1_addr),      // alamat baca port 1 
      .rs2_addr(rs2_addr),      // alamat baca port 2 
      .rd_addr(rd_addr),       // alamat tulis (write-back) 
      .rd_in(rd_in),         // data tulis (write-back data) 
      .rs1(rs1),           // data baca port 1 
      .rs2(rs2)            // data baca port 2 
);



   assign opcode = instr[6:0];
   assign rd_addr = instr[11:7];
   assign funct3 = instr[14:12];
   assign rs1_addr = instr[19:15];
   assign rs2_addr = instr[24:20];
   assign funct7 = instr[31:25];

    //---------------------------INSTRUCTION DECODE---------------------------//

    wire       cu_ALU1src;    // rs1 = 1'b0, PC = 1'b1 
    wire       cu_ALU2src;    // rs2 = 1'b0, imm = 1'b1 
    wire [2:0] cu_immtype;    // I-type = 3'b000, S-type = 3'b001, 
                                    // B-type = 3'b010, U-type = 3'b011, 
                                    // J-type = 3'b100 
    wire [1:0] cu_ALUtype;    // ADD/SUB = 2'b00, GATE = 2'b01, 
                                    // SHIFT = 2'b10  , SLT = 2'b11 
    wire       cu_adtype;     // ADD = 1’b0, SUB = 1’b1 
    wire [1:0] cu_gatype;     // AND = 2'b00, OR = 2'b01, XOR = 2'b10 
    wire [1:0] cu_shiftype;   // SLL = 2'b00, SRL = 2'b01, SRA = 2'b11 
    wire       cu_sltype;     // Signed = 1'b0, Unsigned = 1'b1 
    wire [1:0] cu_rdtype;     // From ALU = 2'b00 , from memory = 2'b01, 
                                    // from PC+4 = 2'b10, 
                                    // from immediate = 2'b11 
    wire       cu_rdwrite;    // Enable write to rd = 1'b1 
    wire [2:0] cu_loadtype;   // Load byte = 3'b000, load half = 3'b001 , 
                                    // load word = 3'b010, load ubyte = 3'b011, 
                                    // load uhalf = 3'b100 
    wire       cu_store;      // Store to memory = 1'b1 
    wire [1:0] cu_storetype;  // Store byte = 2'b00, store half = 2'b01, 
                                    // store word = 2'b10 
    wire       cu_branch;     // Enable branching = 1'b1 
    wire [2:0] cu_branchtype; // BEQ  = 3'b000, BGE = 3'b001, 
                                    // BGEU = 3'b010, BLT = 3'b011, 
                                    // BLTU = 3'b100, BNE = 3'b101 
    wire       cu_PCtype;      // 

    ctrl_unit_rv32i blok_cu(
      .opcode(opcode),      
      .funct3(funct3),
      .funct7(funct7),

      .cu_ALU1src(cu_ALU1src),
      .cu_ALU2src(cu_ALU2src),
      .cu_immtype(cu_immtype),

      .cu_ALUtype(cu_ALUtype),
      .cu_adtype(cu_adtype),
      .cu_gatype(cu_gatype),
      .cu_shiftype(cu_shiftype),
      .cu_sltype(cu_sltype),
      .cu_rdtype(cu_rdtype),
      .cu_rdwrite(cu_rdwrite),
      .cu_loadtype(cu_loadtype),
      .cu_store(cu_store),
      .cu_storetype(cu_storetype),
      .cu_branch(cu_branch),
      .cu_branchtype(cu_branchtype),
      .cu_PCtype(cu_PCtype)
      );

      // in1 alu
      mux2_to_1 blok_alu1src(
        // if s = 0, A
        .A(rs1),
        .B(PC),
        .selector(cu_ALU1src),
        .Y(ALU_in1)
      );

      // in2 alu
      mux2_to_1 blok_alu2src(
        .A(rs2),
        .B(imm),
        .selector(cu_ALU2src),
        .Y(ALU_in2)
      );

      wire [31:0] imm;

      imm_select_rv32i selec_immediate( 
      .trimmed_instr(instr[31:7]), // Trimmed instruction, 25 MSB from instr 
      .cu_immtype(cu_immtype),    // I-type = 3'b000, S-type = 3'b001, 
                                       // B-type = 3'b010, U-type = 3'b011, 
                                       // J-type = 3'b100 
   
      .imm(imm)            // 32-bit immediate 
      ); 
 
    
    //---------------------------------EXECUTE---------------------------------//
    alu_rv32i blok_alu(
      .in1(ALU_in1),
      .in2(ALU_in2),
      .cu_ALUtype(cu_ALUtype),
      .cu_adtype(cu_adtype),
      .cu_gatype(cu_gatype),
      .cu_shiftype(cu_shiftype),
      .cu_sltype(cu_sltype),

      .out(ALU_output)
      );
    //------------------------------MEMORY ACCESS------------------------------//
   
      data_mem_rv32i blok_dmem(
         .clock(clock),
         .dmem_addr(ALU_output),
         .rs2(rs2),
         .cu_store(cu_store),
         .cu_storetype(cu_storetype),
         .cu_loadtype(cu_loadtype),
   
         .dmem_out(dmem_out)
         );

      loadselect_rv32i blok_loadselect(
        .dmem_data(dmem_out),
        .load_type(cu_loadtype),
        .load_out(load_out)
      );

    //--------------------------------WRITE BACK-------------------------------//
   
       mux4_to_1 block_mux_4_to_1(
      .W(ALU_output),  // Input 0
      .X(load_out),  // Input 1
      .Y(PC_4_add),  // Input 2
      .Z(imm),  // Input 3
      .sel(cu_rdtype),        // 2-bit select signal
      .data_out(rd_in)   // Output data
      );

    endmodule