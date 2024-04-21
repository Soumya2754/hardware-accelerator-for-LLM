`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2024 00:46:49
// Design Name: 
// Module Name: matrix_multi_norm_new
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


module matrix_multi_norm_new#(parameter WIDTH = 8)
    (
     input [WIDTH-1:0] A0, A1, A2, A3, // Input matrix A, 4 rows
     input [WIDTH-1:0] B0, B1, B2, B3, // Input matrix B, 4 rows
     output reg [WIDTH-1:0] C0, C1, C2, C3 // Output matrix C, 4 rows
    );

    // Constants for normalization
    parameter MAX_VALUE = (1 << (WIDTH - 1)) - 1; // Maximum positive value
    parameter MIN_VALUE = -MAX_VALUE; // Minimum value (two's complement)

    reg [WIDTH-1:0] temp;
    reg [WIDTH-1:0] scaling_factor; // Scaling factor for normalization
    reg [WIDTH-1:0] max_abs;

    integer i, j, k;

    // Calculate scaling factor
    always @*
    begin
        // Find the maximum absolute value of the input matrices
        max_abs = 0;
        for (i = 0; i < 4; i = i + 1)
        begin
            if (A0[i] > max_abs)
                max_abs = A0[i];
            if (-A0[i] > max_abs)
                max_abs = -A0[i];
            if (A1[i] > max_abs)
                max_abs = A1[i];
            if (-A1[i] > max_abs)
                max_abs = -A1[i];
            if (A2[i] > max_abs)
                max_abs = A2[i];
            if (-A2[i] > max_abs)
                max_abs = -A2[i];
            if (A3[i] > max_abs)
                max_abs = A3[i];
            if (-A3[i] > max_abs)
                max_abs = -A3[i];
            
            if (B0[i] > max_abs)
                max_abs = B0[i];
            if (-B0[i] > max_abs)
                max_abs = -B0[i];
            if (B1[i] > max_abs)
                max_abs = B1[i];
            if (-B1[i] > max_abs)
                max_abs = -B1[i];
            if (B2[i] > max_abs)
                max_abs = B2[i];
            if (-B2[i] > max_abs)
                max_abs = -B2[i];
            if (B3[i] > max_abs)
                max_abs = B3[i];
            if (-B3[i] > max_abs)
                max_abs = -B3[i];
        end

        // Determine scaling factor
        if (max_abs == 0)
            scaling_factor = 1; // Avoid division by zero
        else
            scaling_factor = MAX_VALUE / max_abs;
    end

    // Perform matrix multiplication with normalization
    always @*
    begin
        // Iterate over each row of A
        for (i = 0; i < 4; i = i + 1)
        begin
            // Iterate over each column of B
            for (j = 0; j < 4; j = j + 1)
            begin
                temp = 0;
                // Perform dot product of row i of A and column j of B
                for (k = 0; k < 4; k = k + 1)
                begin
                    temp = temp + (A0[i] * B0[j]) * scaling_factor;
                end
                // Store the result in C
                case (i)
                    0: C0[j] = temp;
                    1: C1[j] = temp;
                    2: C2[j] = temp;
                    3: C3[j] = temp;
                endcase
            end
        end
    end

endmodule