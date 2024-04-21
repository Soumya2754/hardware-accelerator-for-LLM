`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2024 16:40:41
// Design Name: 
// Module Name: matrix_multiplication
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


module matrix_multiplication (
    input wire clk,
    input wire rst_n,
    input wire [15:0] B [0:1023],
    input wire [15:0] C [0:1023],
    output reg [31:0] A [0:1023]
);
reg [31:0] temp_A [0:1023]; // Temporary storage for matrix A
parameter MATRIX_SIZE = 32; // Size of the matrices
parameter MATRIX_ELEMENTS = MATRIX_SIZE * MATRIX_SIZE; // Total number of elements

integer i, j, k,x;
integer a_i_outcols, b_i_incols;
integer a_index, b_index, c_index;

always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Asynchronous reset
            for (int i = 0; i < MATRIX_ELEMENTS; i = i + 1) begin
                A[i] <= 0;
                temp_A[i] <= 0;
            end
        end else begin
            // Synchronize inputs with clock
 for (i = 0; i < MATRIX_ELEMENTS; i = i + 1) begin
        A[i] <= temp_A[i];
    end
end
end
/*always @* begin
for (x=0; x<1024; x = x+1) begin
A[x] = temp_A[x];
end
end*/

// Output reg for A
always @*
begin
      for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
        // Calculate a_i_outcols and b_i_incols
        a_i_outcols = i * MATRIX_SIZE;
        b_i_incols = i * MATRIX_SIZE;

        // Unroll inner loop (j)
        for (j = 0; j < MATRIX_SIZE; j = j + 1) begin
            // Calculate a_index
            a_index = a_i_outcols + j;
            temp_A[a_index] = 0 ;           
            // Unroll innermost loop (k)
            for (k = 0; k < MATRIX_SIZE; k = k + 1) begin
                // Calculate indices and perform multiplication
                b_index = b_i_incols + k;
                c_index = k * MATRIX_SIZE + j;

                // Accumulate product into temp_A[a_index]
                temp_A[a_index] = temp_A[a_index] + B[b_index] * C[c_index];
            end
        end
    end
end
endmodule


