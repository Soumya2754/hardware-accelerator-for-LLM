`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2024 17:06:23
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench;

    // Define parameters for the matrices
    parameter MATRIX_SIZE = 32; // Size of the matrices
    parameter MATRIX_ELEMENTS = MATRIX_SIZE * MATRIX_SIZE; // Total number of elements

    // Declare signals for the matrices
    interface MatrixInterface(input bit clk);
        logic rst_n;
        logic [15:0] B [0:1023]; // Matrix B (32x32)
        logic [15:0] C [0:1023]; // Matrix C (32x32)
        logic [31:0] A [0:1023]; // Matrix A (32x32)
        clocking cb @(posedge clk);
            input A;
            output B,C;
        endclocking
    endinterface

    // Instantiate interface
        bit clk ;
    always #5 clk = ~clk;
    MatrixInterface intf(clk);
    static int unsigned sum;
    // Instantiate DUT with interface
    matrix_multiplication uut (
        .clk(intf.clk),
        .rst_n(intf.rst_n),
        .B(intf.B),
        .C(intf.C),
        .A(intf.A)
    );

    // Clock and reset generation
 // Toggle clock every 5 time units
    // Test case: Random matrix
    initial begin
        // Generate random B and C matrices
       
        intf.rst_n = 1;
        #10;
        intf.rst_n = 0;
        #10;
        intf.rst_n = 1;

        repeat (10)@(negedge clk) // Synchronize with clock
begin
         for (int i = 0; i < MATRIX_ELEMENTS; i = i + 1) begin
            intf.B[i] = $urandom ; // Random value between 0 and 255
            intf.C[i] = $urandom ; // Random value between 0 and 255
        end
end
end        // Perform matrix multiplication to obtain expected output A
 initial begin
 #25
 repeat(10)@(posedge clk) begin
 #3
        for (int i = 0; i < MATRIX_SIZE; i = i + 1) begin
            for (int j = 0; j < MATRIX_SIZE; j = j + 1) begin
                sum = 0;
                for (int k = 0; k < MATRIX_SIZE; k = k + 1) begin
                    sum = sum + intf.B[i * MATRIX_SIZE + k] * intf.C[k * MATRIX_SIZE + j];
                end
                if (intf.A[i * MATRIX_SIZE + j] != sum) begin
                    $display("Error at index [%d][%d]: %d Expected %d, Got %d", i, j, i*MATRIX_SIZE+j, sum, intf.A[i * MATRIX_SIZE + j]);
                end
                end
        end
        $display("Test passed: Output A matches expected result");
        // Terminate simulation
    end
end

initial begin 
#130
     $finish;
    end
endmodule

