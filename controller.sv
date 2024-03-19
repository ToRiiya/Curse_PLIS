module controller
#(
	parameter VIDEO_W = 640,
	parameter VIDEO_H = 480,
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
	output [5:0] VGA_B, // Blue
	output [5:0] VGA_G, // Green
	output [5:0] VGA_R // Red
);

wire cHS, cVS; // Sync wires
wire [15:0] pixel_cnt; // X Coordinate
wire [15:0] line_cnt; // Y Coordinate

// Syncronisation
synch #( .HS_Tpw(HS_Tpw), 
			.HS_Ts(HS_Ts), 
			.VS_Tpw(VS_Tpw), 
			.VS_Ts(VS_Ts), 
			.HS_Tbp(HS_Tbp), 
			.HS_Tfp(HS_Tfp), 
			.VS_Tbp(VS_Tbp), 
			.VS_Tfp(VS_Tfp)) synchronyser
	(
		.clk(clk),
		.rst_n(rst_n),
		.HS(cHS),
		.VS(cVS),
		.cnt_x(pixel_cnt),
		.cnt_y(line_cnt)
	);

integer j;
reg [3:0] squareX; // X Squares counter
reg [3:0] squareY; // Y Squares counter
reg [5:0] blue; // Blue - constant

// Squares counter
always @ (posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		squareX <= 0;
		squareY <= 0;
		blue <= 0;
	end
	else begin
	   // X Squares counter, screen is divided into 16 rectangles
		for (j = 1; j < 17; j = j + 1) begin
			if (pixel_cnt == (VIDEO_W/16) * j) begin
				squareX <= squareX + 1;
			end
		end
        
        // Y Squares counter, screen is divided into 16 rectangles
		if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > 0 && line_cnt <= VIDEO_H/16)
			squareY <= 0;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H/16 && line_cnt <= VIDEO_H*2/16)
			squareY <= 1;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H*2/16 && line_cnt <= VIDEO_H*3/16)
			squareY <= 2;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H*3/16 && line_cnt <= VIDEO_H*4/16)
			squareY <= 3;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H*4/16 && line_cnt <= VIDEO_H*5/16)
			squareY <= 4;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H*5/16 && line_cnt <= VIDEO_H*6/16)
			squareY <= 5;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H*6/16 && line_cnt <= VIDEO_H*7/16)
			squareY <= 6;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H*7/16 && line_cnt <= VIDEO_H*8/16)
			squareY <= 7;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H*8/16 && line_cnt <= VIDEO_H*9/16)
			squareY <= 8;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H*9/16 && line_cnt <= VIDEO_H*10/16)
			squareY <= 9;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H*10/16 && line_cnt <= VIDEO_H*11/16)
			squareY <= 10;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H*11/16 && line_cnt <= VIDEO_H*12/16)
			squareY <= 11;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H*12/16 && line_cnt <= VIDEO_H*13/16)
			squareY <= 12;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H*13/16 && line_cnt <= VIDEO_H*14/16)
			squareY <= 13;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H*14/16 && line_cnt <= VIDEO_H*15/16)
			squareY <= 14;
		else if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > VIDEO_H*15/16 && line_cnt <= VIDEO_H)
			squareY <= 15;
		else 
			squareY <= 0;			
		
		// Blue - constant, VGA_B = 4		
		if (pixel_cnt > 0 && pixel_cnt <= VIDEO_W && line_cnt > 0 && line_cnt <= VIDEO_H)
			blue <= 6'b000100;
		else
			blue <= 0;
	end
end

// Filling squares
assign VGA_B = pixel_cnt <= VIDEO_W && line_cnt <= VIDEO_H ? blue : 0;
assign VGA_G = pixel_cnt <= VIDEO_W && line_cnt <= VIDEO_H ? {2'b00, squareY} : 0;
assign VGA_R = pixel_cnt <= VIDEO_W && line_cnt <= VIDEO_H ? {2'b00, squareX} : 0;

reg mHS, mVS; // output Sync regs

always @ (posedge clk) begin
	mHS <= cHS;
	mVS <= cVS;
	HS <= mHS;
	VS <= mVS;
end

endmodule