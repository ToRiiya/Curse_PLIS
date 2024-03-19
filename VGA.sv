module VGA
#(
    // 640x480 Parameters
	parameter HS_Tpw640_480 = 16'd95, // Sync pulse Horizontal
	parameter HS_Ts640_480 = 16'd799, // Whole line Horizontal
	parameter VS_Tpw640_480 = 16'd1, // Sync pulse Vertical
	parameter VS_Ts640_480 = 16'd524, // Whole frame Vertical
	parameter HS_Tbp640_480 = 16'd48, // Back porch Horizontal
	parameter HS_Tfp640_480 = 16'd17, // Front porch Horizontal
	parameter VS_Tbp640_480 = 16'd33, // Back porch Vertical
	parameter VS_Tfp640_480 = 16'd11, // Front porch Vertical
	// 800x600 Parameters
	parameter HS_Tpw800_600 = 16'd119, // Sync pulse Horizontal
	parameter HS_Ts800_600 = 16'd1039, // Whole line Horizontal
	parameter VS_Tpw800_600 = 16'd5, // Sync pulse Vertical
	parameter VS_Ts800_600 = 16'd665, // Whole frame Vertical
	parameter HS_Tbp800_600 = 16'd64, // Back porch Horizontal
	parameter HS_Tfp800_600 = 16'd57, // Front porch Horizontal
	parameter VS_Tbp800_600 = 16'd23, // Back porch Vertical
	parameter VS_Tfp800_600 = 16'd38 // Front porch Vertical
)
(
	input clk, // Clock
	input rst_n, // Reset active-low
	(*mark_debug = "true"*) input sw, // Switch
	(*mark_debug = "true"*) output [5:0] VGA_B, // VGA Blue
	(*mark_debug = "true"*) output [5:0] VGA_G, // VGA Green
	(*mark_debug = "true"*) output [5:0] VGA_R, // VGA Red
	(*mark_debug = "true"*) output VGA_HS, // VGA Horizontal Sync
	(*mark_debug = "true"*) output VGA_VS // VGA Vertical Sync
);
	
wire VGA_clk640_480; // 640x480 Clock
(*mark_debug = "true"*) wire [5:0] VGA_B640_480; // 640x480 Blue
(*mark_debug = "true"*) wire [5:0] VGA_G640_480; // 640x480 Green
(*mark_debug = "true"*) wire [5:0] VGA_R640_480; // 640x480 Red
wire VGA_HS640_480; // 640x480 Horizontal Sync
wire VGA_VS640_480; // 640x480 Vertical Sync

wire VGA_clk800_600; // 800x600 Clock
(*mark_debug = "true"*) wire [5:0] VGA_B800_600; // 800x600 Blue
(*mark_debug = "true"*) wire [5:0] VGA_G800_600; // 800x600 Green
(*mark_debug = "true"*) wire [5:0] VGA_R800_600; // 800x600 Red
wire VGA_HS800_600; // 800x600 Horizontal Sync
wire VGA_VS800_600; // 800x600 Vertical Sync

// Clock Divider 100 MHz -> 25 MHz
clk_divider #(.DIVISOR(4)) divider640_480 
	(
		.clk(clk),
		.rst_n(rst_n),
		.en(VGA_clk640_480)
	);

// Clock Divider 100 MHz -> 50 MHz
clk_divider #(.DIVISOR(2)) divider800_600
	(
		.clk(clk),
		.rst_n(rst_n),
		.en(VGA_clk800_600)
	);

// 640x480 VGA Controller
controller #( 
			.VIDEO_W(640),
			.VIDEO_H(480),
			.HS_Tpw(HS_Tpw640_480), 
			.HS_Ts(HS_Ts640_480), 
			.VS_Tpw(VS_Tpw640_480), 
			.VS_Ts(VS_Ts640_480), 
			.HS_Tbp(HS_Tbp640_480), 
			.HS_Tfp(HS_Tfp640_480), 
			.VS_Tbp(VS_Tbp640_480), 
			.VS_Tfp(VS_Tfp640_480)) controller640_480
	(
		.clk(VGA_clk640_480),
		.rst_n(rst_n),
		.HS(VGA_HS640_480),
		.VS(VGA_VS640_480),
		.VGA_B(VGA_B640_480),
		.VGA_G(VGA_G640_480),
		.VGA_R(VGA_R640_480)
	);

// 800x600 VGA Controller
controller #( 
			.VIDEO_W(800),
			.VIDEO_H(600),
			.HS_Tpw(HS_Tpw800_600), 
			.HS_Ts(HS_Ts800_600), 
			.VS_Tpw(VS_Tpw800_600), 
			.VS_Ts(VS_Ts800_600), 
			.HS_Tbp(HS_Tbp800_600), 
			.HS_Tfp(HS_Tfp800_600), 
			.VS_Tbp(VS_Tbp800_600), 
			.VS_Tfp(VS_Tfp800_600)) controller800_600
	(
		.clk(VGA_clk800_600),
		.rst_n(rst_n),
		.HS(VGA_HS800_600),
		.VS(VGA_VS800_600),
		.VGA_B(VGA_B800_600),
		.VGA_G(VGA_G800_600),
		.VGA_R(VGA_R800_600)
	);

// Output (if sw == 0 -> 640x480, if sw == 1 -> 800x600)
assign VGA_B = !sw ? VGA_B640_480 : VGA_B800_600;
assign VGA_G = !sw ? VGA_G640_480 : VGA_G800_600;
assign VGA_R = !sw ? VGA_R640_480 : VGA_R800_600;
assign VGA_HS = !sw ? VGA_HS640_480 : VGA_HS800_600;
assign VGA_VS = !sw ? VGA_VS640_480 : VGA_VS800_600;

endmodule
