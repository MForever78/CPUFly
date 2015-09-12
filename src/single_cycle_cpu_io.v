/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module CPU (clk,reset,pc,inst,Addr,Data_I,Data_O,WE,ACK,STB,debug_next_pc); // cpu kbd i/o
    input  clk, reset;                                  // clock and reset
    input  [31:0] inst;                                 // instruction
    input  [31:0] Data_I;                               // load data
    input  ACK;
    output [31:0] pc;                                   // program counter
    output [31:0] Addr;                                 // mem or i/o addr
    output [31:0] Data_O;                               // store data
    output WE;                                          // data memory write
    output STB;
    // debug signals
    output [31: 0] debug_next_pc;
    // control signals
    reg           wreg;                                 // write regfile
    reg           wmem,rmem;                            // write/read memory
    reg    [31:0] alu_out;                              // alu output
    reg     [4:0] dest_rn;                              // dest reg number
    reg    [31:0] next_pc;                              // next pc
    wire   [31:0] pc_plus_4 = pc + 4;                   // pc + 4
    // instruction format
    wire  [05:00] opcode = inst[31:26];
    wire  [04:00] rs     = inst[25:21];
    wire  [04:00] rt     = inst[20:16];
    wire  [04:00] rd     = inst[15:11];
    wire  [04:00] sa     = inst[10:06];
    wire  [05:00] func   = inst[05:00];
    wire  [15:00] imm    = inst[15:00];
    wire  [25:00] addr   = inst[25:00];
    wire          sign   = inst[15];
    wire  [31:00] offset = {{14{sign}},imm,2'b00};
    wire  [31:00] j_addr = {pc_plus_4[31:28],addr,2'b00};
    // instruction decode
    wire i_add  = (opcode == 6'h00) & (func == 6'h20);  // add
    wire i_sub  = (opcode == 6'h00) & (func == 6'h22);  // sub
    wire i_and  = (opcode == 6'h00) & (func == 6'h24);  // and
    wire i_or   = (opcode == 6'h00) & (func == 6'h25);  // or
    wire i_xor  = (opcode == 6'h00) & (func == 6'h26);  // xor
    wire i_sll  = (opcode == 6'h00) & (func == 6'h00);  // sll
    wire i_srl  = (opcode == 6'h00) & (func == 6'h02);  // srl
    wire i_sra  = (opcode == 6'h00) & (func == 6'h03);  // sra
    wire i_jr   = (opcode == 6'h00) & (func == 6'h08);  // jr
    wire i_addi = (opcode == 6'h08);                    // addi
    wire i_andi = (opcode == 6'h0c);                    // andi
    wire i_ori  = (opcode == 6'h0d);                    // ori
    wire i_xori = (opcode == 6'h0e);                    // xori
    wire i_lw   = (opcode == 6'h23);                    // lw
    wire i_sw   = (opcode == 6'h2b);                    // sw
    wire i_beq  = (opcode == 6'h04);                    // beq
    wire i_bne  = (opcode == 6'h05);                    // bne
    wire i_lui  = (opcode == 6'h0f);                    // lui
    wire i_j    = (opcode == 6'h02);                    // j
    wire i_jal  = (opcode == 6'h03);                    // jal
    // pc
    reg [31:0] pc;
    always @ (posedge clk or posedge reset) begin
        if (reset) pc <= 0;
        // slave is not ready, you stay here
        else begin
            if (STB)
                pc <= ACK ? next_pc : pc;
            else
                pc <= next_pc;
        end
    end
    // data written to register file
    wire   [31:0] data_2_rf = i_lw ? Data_I : alu_out;
    // register file
    reg    [31:0] regfile [1:31];                       // $1 - $31
    wire   [31:0] a = (rs==0) ? 0 : regfile[rs];        // read port
    wire   [31:0] b = (rt==0) ? 0 : regfile[rt];        // read port
    always @ (posedge clk) begin
        if (wreg && (dest_rn != 0)) begin
            regfile[dest_rn] <= data_2_rf;              // write port
        end
    end
    // output signals
    assign WE = wmem;    // data memory write
    assign Data_O = b;                               // data to store
    assign Addr = alu_out;                         // memory address
    assign STB = rmem | wmem;
    // control signals, will be combinational circuit
    always @(*) begin
        alu_out = 0;                                    // alu output
        dest_rn = rd;                                   // dest reg number
        wreg    = 0;                                    // write regfile
        wmem    = 0;                                    // write memory (sw)
        rmem    = 0;                                    // read  memory (lw)
        next_pc = pc_plus_4;
        case (1'b1)
            i_add: begin                                // add
                alu_out = a + b;
                wreg    = 1; end
            i_sub: begin                                // sub
                alu_out = a - b;
                wreg    = 1; end
            i_and: begin                                // and
                alu_out = a & b;
                wreg    = 1; end
            i_or: begin                                 // or
                alu_out = a | b;
                wreg    = 1; end
            i_xor: begin                                // xor
                alu_out = a ^ b;
                wreg    = 1; end
            i_sll: begin                                // sll
                alu_out = b << sa;
                wreg    = 1; end
            i_srl: begin                                // srl
                alu_out = b >> sa;
                wreg    = 1; end
            i_sra: begin                                // sra
                alu_out = $signed(b) >>> sa;
                wreg    = 1; end
            i_jr: begin                                 // jr
                next_pc = a; end
            i_addi: begin                               // addi
                alu_out = a + {{16{sign}},imm};
                dest_rn = rt;
                wreg    = 1; end
            i_andi: begin                               // andi
                alu_out = a & {16'h0,imm};
                dest_rn = rt;
                wreg    = 1; end
            i_ori: begin                                // ori
                alu_out = a | {16'h0,imm};
                dest_rn = rt;
                wreg    = 1; end
            i_xori: begin                               // xori
                alu_out = a ^ {16'h0,imm};
                dest_rn = rt;
                wreg    = 1; end
            i_lw: begin                                 // lw
                alu_out = a + {{16{sign}},imm};
                dest_rn = rt;
                rmem    = 1;
                wreg    = 1; end
            i_sw: begin                                 // sw
                alu_out = a + {{16{sign}},imm};
                wmem    = 1; end
            i_beq: begin                                // beq
                if (a == b) 
                  next_pc = pc_plus_4 + offset; end
            i_bne: begin                                // bne
                if (a != b) 
                  next_pc = pc_plus_4 + offset; end
            i_lui: begin                                // lui
                alu_out = {imm,16'h0};
                dest_rn = rt;
                wreg    = 1; end
            i_j: begin                                  // j
                next_pc = j_addr; end
            i_jal: begin                                // jal
                alu_out = pc_plus_4;
                wreg    = 1;
                dest_rn = 5'd31;
                next_pc = j_addr; end
            default: ;
        endcase
        wreg = STB ? wreg & ACK : wreg;
    end

    // debug signals
    assign debug_next_pc = next_pc;
endmodule
