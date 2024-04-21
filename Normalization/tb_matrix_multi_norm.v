`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2024 00:05:27
// Design Name: 
// Module Name: tb_matrix_multi_norm
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


module tb_matrix_multi_norm;

    // Parameters
    localparam WIDTH = 8; // Width of input data
    
    integer i;

    // Signals
    reg [WIDTH-1:0] A [0:3]; // Input matrix A, 4 rows
    reg [WIDTH-1:0] B [0:3]; // Input matrix B, 4 rows
    wire [WIDTH-1:0] C [0:3]; // Output matrix C, 4 rows

    // Instantiate the matrix multiplication module
    matrix_multi_norm #(WIDTH) dut(A, B, C);//(.A(A), .B(B), .C(C));

    // Stimulus
    initial 
    begin
        // Initialize input matrices A and B
        A[0] = 10; A[1] = 20; A[2] = 30; A[3] = 40; // Example values for matrix A
        B[0] = 1; B[1] = 2; B[2] = 3; B[3] = 4; // Example values for matrix B
        
        // Wait for some time to allow the calculation to complete
        #100;

        // Display the input and output matrices
        $display("Input Matrix A:");
        for (i = 0; i < 4; i = i + 1)
            $display("A[%0d] = %d", i, A[i]);
        
        $display("Input Matrix B:");
        for (i = 0; i < 4; i = i + 1)
            $display("B[%0d] = %d", i, B[i]);

        $display("Output Matrix C:");
        for (i = 0; i < 4; i = i + 1)
            $display("C[%0d] = %d", i, C[i]);
        
        // Finish simulation
        $finish;
    end

endmodule
