module clk_divider
#(
	parameter DIVISOR = 2 // Clock divisor
)
(
	input clk, // Input Clock
	input rst_n, // Reset active-low
	output reg en // Output Clock
);

reg [15:0] cnt; // Counter

always @ (posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		en <= 1'b0;
		cnt <= 16'b0;
	end
	else begin
		cnt <= cnt + 16'b1;
		if (cnt >= (DIVISOR - 1)) begin
			cnt <= 16'b0;
		end
		en <= (cnt < DIVISOR/2) ? 1'b1 : 1'b0; // If counter < DIVISOR/2 -> 1 else 0
	end
end

endmodule	