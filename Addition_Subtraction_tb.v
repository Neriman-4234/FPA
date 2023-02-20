module Addition_Subtraction_tb;

reg [31:0] i_operand_a,i_operand_b;
reg i_clk = 1'b1;
reg	i_rst;
reg add_sub_signal;
reg [31:0] captured_data_A[0:34];
reg [31:0] captured_data_B[0:34];

wire [31:0] o_operand_o;
wire o_exception;

integer f,f1,i;

Addition_Subtraction uut(.i_clk(i_clk),
                         .i_rst(i_rst),
                         .i_operand_a(i_operand_a),
                         .i_operand_b(i_operand_b),
                         .add_sub_signal(add_sub_signal),
                         .o_exception(o_exception),
                         .o_operand_o(o_operand_o)
                         );

always #5 i_clk = ~i_clk;

initial begin
f  = $fopen("operand_O_verilog_ex_b0.txt");
f1 = $fopen("operand_O_verilog_ex_b1.txt");
end

initial begin
$readmemh("operand_A_020.txt",captured_data_A);
$readmemh("operand_B_020.txt",captured_data_B);
end

initial begin
reset_trigger();
add_sub_signal = 1'b0;
for(i=0; i<35; i=i+1) begin
iteration(captured_data_A[i],captured_data_B[i]);
$fdisplay(f,"%h",o_operand_o);
end
add_sub_signal = 1'b1;
for(i=0; i<35; i=i+1) begin
iteration(captured_data_A[i],captured_data_B[i]);
$fdisplay(f1,"%h",o_operand_o);
end
end

task iteration(
input [31:0] op_a,op_b);
begin
	i_operand_a = op_a;
	i_operand_b = op_b;
#200;
end
endtask

task reset_trigger;
begin
i_rst <= 1'b1;
#100;
i_rst <= 1'b0;
end
endtask

endmodule
