module mul_invert_2_tb;

reg i_rst,i_start;
reg [31:0] i_operand_a,i_operand_b;
reg [31:0] captured_data_A[0:29];
reg [31:0] captured_data_B[0:29];
reg i_clk = 1'b1;

wire o_exception,o_overflow,o_underflow;
wire [31:0] o_operand_o;
wire o_done;

integer f,i;





mul_invert_2 uut(  .i_clk(i_clk),
                   .i_rst(i_rst),
                   .i_start(i_start),
                   .i_operand_a(i_operand_a),
                   .i_operand_b(i_operand_b),
                   .o_operand_o(o_operand_o),
                   .o_exception(o_exception),
                   .o_overflow(o_overflow),
                   .o_underflow(o_underflow),
                   .o_done(o_done)
                   );

always i_clk = #5 ~i_clk;

initial begin
f = $fopen("operand_O_verilog_ex_inverted_2.txt");
end

initial begin
$readmemh("operand_A_014.txt",captured_data_A);
$readmemh("operand_B_014.txt",captured_data_B);
end

initial begin
reset_trigger();
for(i=0;i<30;i=i+1) begin
iteration(captured_data_A[i],captured_data_B[i],o_exception,o_overflow,o_underflow);
$fdisplay(f,"%h",o_operand_o);
end
end


task iteration(
input [31:0] op_a,op_b,
input Expected_Exception,Expected_Overflow,Expected_Underflow
);
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
