module synch
#(
	parameter HS_Tpw = 10'd95,
	parameter HS_Ts = 10'd799,
	parameter VS_Tpw = 10'd1,
	parameter VS_Ts = 10'd524,
	parameter HS_Tbp = 10'd48,
	parameter HS_Tfp = 10'd17,
	parameter VS_Tbp = 10'd33,
	parameter VS_Tfp = 10'd11
)
(
	input clk, // Clock
	input rst_n, // Reset active-low
	output reg HS, // Horizontal Sync
	output reg VS, // Vertical Sync
	output reg [15:0] cnt_x, // X Coordinate
	output reg [15:0] cnt_y // Y Coordinate
);

reg [15:0] pixel_cnt; // Pixel Counter
reg [15:0] line_cnt; // Line Counter

// Syncronization
always @ (posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		pixel_cnt <= 16'd0;
		line_cnt <= 16'd0;
		HS <= 1'd0;
		VS <= 1'd0;
		cnt_x <= 0;
		cnt_y <= 0;
	end
	else begin
		pixel_cnt <= pixel_cnt + 16'd1;
		if (pixel_cnt == HS_Ts) begin
			pixel_cnt <= 16'd0;
			HS <= 1'd0;
			line_cnt <= line_cnt + 16'd1;
			if ((line_cnt >= (VS_Tpw + VS_Tbp)) && (line_cnt <= (VS_Ts - VS_Tfp))) begin
				cnt_y <= cnt_y + 1;
			end
			else begin 
				cnt_y <= 0;
			end
                    
			if (line_cnt == VS_Ts) begin
				line_cnt <= 16'd0;
				VS <= 1'd0;
			end
			else if (line_cnt >= VS_Tpw)
				VS <= 1'd1;
		end
		else if (pixel_cnt >= HS_Tpw)
			HS <= 1'd1;
            
		if ((pixel_cnt >= (HS_Tpw + HS_Tbp)) && (pixel_cnt <= (HS_Ts - HS_Tfp))) begin
			cnt_x <= cnt_x + 1;
		end
		else
			cnt_x <= 0;
	end
end

endmodule