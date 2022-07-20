module ALU_control(
input [4:0] in,input ALUop,
output [4:0]out
);
assign out=ALUop?in:5'b0;
endmodule
