/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit v
 e at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;
	 

    /* YOUR CODE STARTS HERE */
	 wire [11:0] pc_out,pc_in,pc_plus1_out,jump_Branch,jr_jump,bex_jr,jal_wire_pc;
	 wire overflow_inPC;
	 wire RegDst,Jump,Branch,MemToReg,ALUop,MemWrite,ALUinB,RegWriteEnable,Jalbit,Jrbit,setxbit,bexbit;
	 wire [4:0] ctrl_ALUopcode,setx_overflow,jal_wire;
	 wire isNotEqual, isLessThan, overflow;
	 wire [31:0]setx_data_jalbit,data_result,extension_out,data_operandA,data_for_Regwrite;
	 
	 
	 wire[31:0] jal_MemToReg;
	 wire [4:0] read_Awire,read_Bwire;
	 reg [31:0] status_value;
	 reg [11:0] sum,bex_sum;
	
	 assign address_imem=pc_out;
	 
	 
	 PC PC1(clock,reset,pc_in,pc_out);
	 add4 add4_1(pc_out,pc_plus1_out,overflow_inPC);
	 control_circuit  control_circuit1(q_imem[31:27],RegDst,Jump,Branch,MemToReg,ALUop,MemWrite,ALUinB,
	 RegWriteEnable,Jalbit,Jrbit,setxbit,bexbit);
	 assign ctrl_writeEnable=overflow?1'b1:RegWriteEnable;
	
	 assign setx_overflow=setxbit?5'b11110:q_imem[26:22];
	 assign jal_wire=overflow?5'b11110:setx_overflow;
	 assign ctrl_writeReg=Jalbit?5'b11111:jal_wire;
	//connect rd but if we have overflow this is connected to $r30($rstatus)
	 
	 
	 
	 assign read_Awire = RegDst?q_imem[26:22]:q_imem[21:17];
	 assign ctrl_readRegA=bexbit?5'b11110:read_Awire;//connect rs but when you excute sw or bne,beq it is connected to rd	
	 
	 assign read_Bwire =RegDst?q_imem[21:17]:q_imem[16:12];
	 assign ctrl_readRegB=bexbit?5'b00000:read_Bwire;//connect rt but when you excute sw or bne,beq it is connected to rd	
	 
	 
	 ALU_control ALU_control1(q_imem[6:2],ALUop,ctrl_ALUopcode);
	 sign_extension sign_extension1(q_imem[16:0],extension_out);
	 
	 //mux curcuit for j instruction
	// assign 
	 //
	 
	 assign data_operandA = ALUinB?extension_out:data_readRegA;
	 
	 assign setx_data_jalbit=setxbit?q_imem[26:0]:data_result;
	 assign jal_MemToReg=Jalbit?pc_plus1_out:setx_data_jalbit;
	 assign data_for_Regwrite = MemToReg?q_dmem:jal_MemToReg;
	 assign data_writeReg=overflow?status_value:data_for_Regwrite;
	 
	 
	 assign address_dmem=data_result[11:0];
	 assign wren=MemWrite;
	 assign data=data_readRegA;
	  

	  
	 
	 
	 alu alu1(data_operandA, data_readRegB, ctrl_ALUopcode,
			q_imem[11:7],data_result, isNotEqual, isLessThan, overflow);
	
	 always@(q_imem)
	 begin
	 
	 if(q_imem[31:27]==5'b00101)
			status_value =2;
	 else if(q_imem[31:27]==5'b00000 && ctrl_ALUopcode==5'b00000)
			status_value =1;
	 else if(q_imem[31:27]==5'b00000 && ctrl_ALUopcode==5'b00001)
			status_value =3;
	 else status_value =0;


	 end
	 
	 always@(Branch,bexbit,isNotEqual,isLessThan)
	 begin
	 if((isNotEqual||isLessThan)&&Branch)
			sum=pc_plus1_out+q_imem[11:0];
	 else sum =pc_plus1_out;
	 if(bexbit&&isNotEqual)
	      bex_sum=q_imem[11:0];
	 else bex_sum=pc_plus1_out;
	 
	 
	 end
	 wire [11:0]sum_wire;
	 wire [11:0] bexsum_wire;
	 assign sum_wire=sum; 
	 assign bexsum_wire=bex_sum;
	 assign jump_Branch=Branch?sum_wire:pc_plus1_out;
	 assign jr_jump =Jump?q_imem[11:0]:jump_Branch;
	 assign bex_jr  =Jrbit? data_readRegA[11:0]:jr_jump;
	 assign jal_wire_pc=Jalbit?q_imem[11:0]:bex_jr;
	 assign pc_in =bexbit?bexsum_wire:jal_wire_pc;
	 
endmodule