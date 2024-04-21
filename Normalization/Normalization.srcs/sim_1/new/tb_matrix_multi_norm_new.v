`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2024 00:47:18
// Design Name: 
// Module Name: tb_matrix_multi_norm_new
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


module tb_matrix_multi_norm_new;

    // Parameters
    localparam WIDTH = 8; // Width of input data
    
    integer i;

    // Signals
    reg [WIDTH-1:0] A0 [0:3]; // Input matrix A, 4 rows
    reg [WIDTH-1:0] A1 [0:3];
    reg [WIDTH-1:0] A2 [0:3];
    reg [WIDTH-1:0] A3 [0:3];
    reg [WIDTH-1:0] B0 [0:3]; // Input matrix B, 4 rows
    reg [WIDTH-1:0] B1 [0:3];
    reg [WIDTH-1:0] B2 [0:3];
    reg [WIDTH-1:0] B3 [0:3];
    wire [WIDTH-1:0] C0 [0:3]; // Output matrix C, 4 rows
    wire [WIDTH-1:0] C1 [0:3];
    wire [WIDTH-1:0] C2 [0:3];
    wire [WIDTH-1:0] C3 [0:3];
    
    // Instantiate the matrix multiplication module
    matrix_multi_norm #(WIDTH) dut (
        .A0(A0[0], A0[1], A0[2], A0[3]),
        .A1(A1[0], A1[1], A1[2], A1[3]),
        .A2(A2[0], A2[1], A2[2], A2[3]),
        .A3(A3[0], A3[1], A3[2], A3[3]),
        .B0(B0[0], B0[1], B0[2], B0[3]),
        .B1(B1[0], B1[1], B1[2], B1[3]),
        .B2(B2[0], B2[1], B2[2], B2[3]),
        .B3(B3[0], B3[1], B3[2], B3[3]),
        .C0(C0[0], C0[1], C0[2], C0[3]),
        .C1(C1[0], C1[1], C1[2], C1[3]),
        .C2(C2[0], C2[1], C2[2], C2[3]),
        .C3(C3[0], C3[1], C3[2], C3[3])
    );

    // Stimulus
    initial begin
        // Initialize input matrices A and B
        // Example values for matrix A
        A0[0] = 10; A0[1] = 20; A0[2] = 30; A0[3] = 40;
        A1[0] = 50; A1[1] = 60; A1[2] = 70; A1[3] = 80;
        A2[0] = 90; A2[1] = 100; A2[2] = 110; A2[3] = 120;
        A3[0] = 130; A3[1] = 140; A3[2] = 150; A3[3] = 160;
        
        // Example values for matrix B
        B0[0] = 1; B0[1] = 2; B0[2] = 3; B0[3] = 4;
        B1[0] = 5; B1[1] = 6; B1[2] = 7; B1[3] = 8;
        B2[0] = 9; B2[1] = 10; B2[2] = 11; B2[3] = 12;
        B3[0] = 13; B3[1] = 14; B3[2] = 15; B3[3] = 16;
        
        // Wait for some time to allow the calculation to complete
        #100;

        // Display the input and output matrices
        $display("Input Matrix A:");
        for (i = 0; i < 4; i = i + 1)
            $display("A[%0d] = %d, %d, %d, %d", i, A0[i], A1[i], A2[i], A3[i]);
        
        $display("Input Matrix B:");
        for (i = 0; i < 4; i = i + 1)
            $display("B[%0d] = %d, %d, %d, %d", i, B0[i], B1[i], B2[i], B3[i]);

        $display("Output Matrix C:");
        for (i = 0; i < 4; i = i + 1)
            $display("C[%0d] = %d, %d, %d, %d", i, C0[i], C1[i], C2[i], C3[i]);
        
        // Finish simulation
        $finish;
    end

endmodule
