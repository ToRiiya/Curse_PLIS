`timescale 1 ns / 1 ns

module testbench;

parameter Tt = 10;

parameter HS_Tpw640_480 = 16'd95;
parameter HS_Ts640_480 = 16'd799;
parameter VS_Tpw640_480 = 16'd1;
parameter VS_Ts640_480 = 16'd524;
parameter HS_Tbp640_480 = 16'd48;
parameter HS_Tfp640_480 = 16'd17;
parameter VS_Tbp640_480 = 16'd33;
parameter VS_Tfp640_480 = 16'd11;
	
parameter HS_Tpw800_600 = 16'd119; // Sync pulse Horizontal
parameter HS_Ts800_600 = 16'd1039; // Whole line Horizontal
parameter VS_Tpw800_600 = 16'd5; // Sync pulse Vertical
parameter VS_Ts800_600 = 16'd665; // Whole frame Vertical
parameter HS_Tbp800_600 = 16'd64; // Back porch Horizontal
parameter HS_Tfp800_600 = 16'd57; // Front porch Horizontal
parameter VS_Tbp800_600 = 16'd23; // Bach porch Vertical
parameter VS_Tfp800_600 = 16'd38; // Front porch Vertical

logic clk;
logic rst_n;
logic sw;
logic [5:0] VGA_B;
logic [5:0] VGA_G;
logic [5:0] VGA_R;
logic VGA_HS;
logic VGA_VS;

VGA #(
		.HS_Tpw640_480(HS_Tpw640_480),
		.HS_Ts640_480(HS_Ts640_480),
		.VS_Tpw640_480(VS_Tpw640_480),
		.VS_Ts640_480(VS_Ts640_480),
		.HS_Tbp640_480(HS_Tbp640_480),
		.HS_Tfp640_480(HS_Tfp640_480),
		.VS_Tbp640_480(VS_Tbp640_480),
		.VS_Tfp640_480(VS_Tfp640_480),
		
		.HS_Tpw800_600(HS_Tpw800_600),
		.HS_Ts800_600(HS_Ts800_600),
		.VS_Tpw800_600(VS_Tpw800_600),
		.VS_Ts800_600(VS_Ts800_600),
		.HS_Tbp800_600(HS_Tbp800_600),
		.HS_Tfp800_600(HS_Tfp800_600),
		.VS_Tbp800_600(VS_Tbp800_600),
		.VS_Tfp800_600(VS_Tfp800_600)) vga
	(
		.clk(clk),
		.rst_n(rst_n),
		.sw(sw),
		.VGA_B(VGA_B),
		.VGA_G(VGA_G),
		.VGA_R(VGA_R),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS)
	);

initial begin
	clk = 0;
	forever clk = #(Tt/2) ~clk;
end

initial begin
	rst_n = 0;
	sw = 0;
	repeat(4) @(posedge clk);
	rst_n = 1;
	repeat(1000000) @(posedge clk);
	sw = 1;
end

endmodule