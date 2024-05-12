module multiplication_tb;

reg [15:0] a_operand, b_operand;
wire Exception, Overflow, Underflow;
wire [31:0] result;

reg clk = 1'b1;

Multiplication dut(a_operand, b_operand, Exception, Overflow, Underflow, result);

always clk = #5 ~clk;

initial begin
    iteration (16'h851F, 16'h851F, 1'b0, 1'b0, 1'b0, 16'h10E9, `__LINE__); // 45.13 * 63.13 = 2849.0569;

    iteration (16'h999A, 16'h3D71, 1'b0, 1'b0, 1'b0, 16'h5062, `__LINE__); // 3.15 * -14.39 = -45.3285

    iteration (16'h6666, 16'hA3D7, 1'b0, 1'b0, 1'b0, 16'h5375, `__LINE__); // -13.15 * -48.16 = 633.304

    iteration (16'h8000, 16'h8000, 1'b0, 1'b0, 1'b0, 16'h8000, `__LINE__); // 4096 * 4096 = 16777216

    iteration (16'h62C1, 16'h62C1, 1'b0, 1'b0, 1'b0, 16'hFFE7, `__LINE__); // 0.00154408081 * 0.00154408081 = 0.00000238418

    iteration (16'h0000, 16'h0000, 1'b0, 1'b0, 1'b0, 16'h0000, `__LINE__); // 0 * 0 = 0;

    iteration (16'h6666, 16'h0000, 1'b0, 1'b0, 1'b0, 16'h5375, `__LINE__); //-13.15 * 0 = 0;

    iteration (16'h8000, 16'h8000, 1'b1, 1'b1, 1'b0, 16'h0000, `__LINE__); 

    iteration (16'h8000, 16'h18000, 1'b0, 1'b0, 1'b1, 16'h0000, `__LINE__);

    $stop;
end

task iteration(
    input [15:0] operand_a, operand_b,
    input Expected_Exception, Expected_Overflow, Expected_Underflow,
    input [31:0] Expected_result,
    input integer linenum
);
begin
    @(negedge clk)
    begin
        a_operand = operand_a;
        b_operand = operand_b;
    end

    @(posedge clk)
    begin
        if ((Expected_result == result) && (Expected_Exception == Exception) && (Expected_Overflow == Overflow) && (Expected_Underflow == Underflow))
            $display ("Test Passed - %d", linenum);

        else
            $display ("Test failed - Expected_result = %h, Result = %h, \n Expected_Exception = %d, Exception = %d,\n Expected_Overflow = %d, Overflow = %d, \n Expected_Underflow = %d, Underflow = %d - %d \n ", Expected_result, result, Expected_Exception, Exception, Expected_Overflow, Overflow, Expected_Underflow, Underflow, linenum);
    end
end
endtask
endmodule
