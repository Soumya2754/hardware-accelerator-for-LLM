`timescale 1ns / 1ps

module normalization_block #(parameter WIDTH = 8)
    (input [WIDTH-1:0] data_in, // Input data to be normalized
     output reg [WIDTH-1:0] data_out // Normalized output data
    );

    // Constants for normalization
    parameter MAX_VALUE = (1 << (WIDTH - 1)) - 1; // Maximum positive value
    parameter MIN_VALUE = -MAX_VALUE; // Minimum value (two's complement)

    // Find the maximum absolute value of the input data
    reg [WIDTH-1:0] max_abs;
    always @*
    begin
        max_abs = (data_in >= 0) ? data_in : -data_in; // Absolute value
    end

    // Determine the scaling factor to fit the data within the range [-1, 1)
    reg [WIDTH-1:0] scaling_factor;
    always @*
    begin
        scaling_factor = (max_abs == 0) ? 1 : MAX_VALUE / max_abs; // Prevent division by zero
    end

    // Normalize the input data by multiplying it with the scaling factor
    always @*
    begin
        data_out = data_in * scaling_factor;
    end

endmodule
