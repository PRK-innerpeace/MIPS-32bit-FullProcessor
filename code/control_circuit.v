module control_circuit(
input [4:0]opcode ,
output RegDst,Jump,Branch,MemToReg,ALUop,MemWrite,ALUinB,
	 RegWriteEnable,Jalbit,Jrbit,setxbit,bexbit
);

parameter Rtype =5'b00000,addi=5'b00101,sw=5'b00111,lw=5'b01000,j=5'b00001,bne=5'b00010,
			jal=5'b00011,	jr=5'b00100,blt=5'b00110,bex=5'b10110,setx=5'b10101;
//parameter j=5'b00001,bne=5'b00010,jal=5'b00011,jr=5'b00100,blt=5'b00110,
//			 bex=5'b10110,setx=5'b10101 ;//This will be used in Full processor
reg [11:0] out;
assign RegDst = out[0];
assign Jump = out[1];
assign Branch = out[2];
assign MemToReg = out[3];
assign ALUop = out[4];
assign MemWrite = out[5];
assign ALUinB = out[6];
assign RegWriteEnable = out[7];
assign Jalbit = out[8];
assign Jrbit=out[9];
assign setxbit=out[10];
assign bexbit=out[11];

always @ (opcode)
begin
 case (opcode)
 Rtype:out=12'b0000_1001_0000;
 addi:out=12'b0000_1100_0001;
 sw:out=12'b0000_0110_0001;
 lw:out=12'b0000_1100_1001;
 j:out=12'b0000_0000_0010;
 bne:out=12'b0000_0000_0101;
 blt:out=12'b0000_0000_0101;
 jal:out=12'b0001_1000_0000;
 jr:out=12'b0010_0000_0001;
 bex:out=12'b1000_0000_0000;
 setx:out=12'b0100_1000_0000;
 
 default:out=12'b000000000000;
 
 endcase
end
endmodule
