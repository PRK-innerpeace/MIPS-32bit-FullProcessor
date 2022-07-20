module add4
#(parameter size=12)
(input [size-1:0] addin,
 output [size-1:0] addout,overflow
);

	
	reg signed[size-1:0] inner_result;
	reg inner_cout;
	
	assign addout = inner_result;
	assign overflow = inner_cout != inner_result[size-1];

always @(addin)
begin
{inner_cout, inner_result} = addin + 3'd1;  // ADD+4
end

endmodule