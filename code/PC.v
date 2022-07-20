//The pc actually stores the address of the imem, 
//so if the imem uses a 12-bit address, the pc is a 12-bit register. 
//This can be achieved with 12 DFFs.
module PC
#(parameter size=12)
(
 input clk,reset,input [size-1:0] addin,
 output reg[size-1:0] addout
);

always @(posedge clk,posedge reset)
begin
if(reset)
 addout<=0;
else

 addout <= addin;
end

endmodule
