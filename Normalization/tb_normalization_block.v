`timescale 1ns / 1ps

module tb_normalization_block;

    // Parameters
    localparam WIDTH = 8; // Width of input data

    // Signals
    reg [WIDTH-1:0] data_in;
    wire [WIDTH-1:0] data_out;

    // Instantiate the normalization block
    normalization_block #(WIDTH) dut (
        .data_in(data_in),
        .data_out(data_out)
    );

    // Stimulus
    initial begin
        // Test case 1: Positive input data
        data_in = 100; // Example input value
        #10; // Wait for 10 time units
        // Test case 2: Negative input data
        data_in = -50; // Example input value
        #10; // Wait for 10 time units
        // Test case 3: Zero input data
        data_in = 0; // Example input value
        #10; // Wait for 10 time units
        // Add more test cases as needed
        $finish; // Finish simulation
    end

    // Display the results
    always @* begin
        $display("Input: %d, Output: %d", data_in, data_out);
    end

endmodule
