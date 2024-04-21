`timescale 1ns / 1ps

module matrix_multi_norm #(parameter WIDTH = 8) //(A, B, C);
     (input [WIDTH-1:0] A [0:3], // Input matrix A, 4 rows
      input [WIDTH-1:0] B [0:3], // Input matrix B, 4 rows
      output reg [WIDTH-1:0] C [0:3] // Output matrix C, 4 rows
      );

    // Constants for normalization
    parameter MAX_VALUE = (1 << (WIDTH - 1)) - 1; // Maximum positive value
    parameter MIN_VALUE = -MAX_VALUE; // Minimum value (two's complement)

    reg [WIDTH-1:0] temp;
    reg [WIDTH-1:0] scaling_factor; // Scaling factor for normalization
    reg [WIDTH-1:0] max_abs;
    
    integer i, j, k;
    
    // Calculate scaling factor
    always @(*)
    begin
        // Find the maximum absolute value of the input matrices
        max_abs = 0;
        for ( i = 0; i < 4; i = i + 1) 
        begin
            if (A[i] > max_abs)
                max_abs = A[i];
            if (-A[i] > max_abs)
                max_abs = -A[i];
            if (B[i] > max_abs)
                max_abs = B[i];
            if (-B[i] > max_abs)
                max_abs = -B[i];
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
        for ( i = 0; i < 4; i = i + 1) 
        begin
            // Iterate over each column of B
            for ( j = 0; j < 4; j = j + 1) 
            begin
                temp = 0;
                // Perform dot product of row i of A and column j of B
                for ( k = 0; k < 4; k = k + 1) 
                begin
                    temp = temp + (A[i] * B[j]) * scaling_factor;
                end
                // Store the result in C
                C[i][j] = temp;
            end
        end
    end

endmodule
