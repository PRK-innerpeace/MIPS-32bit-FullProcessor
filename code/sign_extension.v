module sign_extension(
input [16:0] in,
output [31:0] outp);

assign outp[16:0] =in;
assign outp[31:17]=in[16]?15'b111_1111_1111_1111:15'b000_0000_0000_0000;

endmodule
