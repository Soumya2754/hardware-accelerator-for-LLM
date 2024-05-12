`timescale 1ns/1ps

module layer_normalization_tb;

    // Parameters
    localparam int WIDTH = 8;
    localparam int SIZE = 3;

    // Define interface
    interface norm;
        logic clk = 1'b0;
        logic [15:0] input_tensor[0:SIZE-1]; // Change index range to match SIZE
        logic [15:0] output_tensor[0:SIZE-1]; // Change index range to match SIZE
    endinterface

    // Declare interface signals
    norm norm_intf();

    // Instantiate DUT
    layer_normalization_inference dut (
        .clk(norm_intf.clk),
        .input_tensor(norm_intf.input_tensor),
        .output_tensor(norm_intf.output_tensor)
    );

    // Clock generation
    always #5 norm_intf.clk = ~norm_intf.clk;

    // Testbench stimulus
    initial 
    begin
        // Initialize inputs
        for (int i = 0; i < SIZE; i = i + 1) 
        begin
            norm_intf.input_tensor[i] = $urandom_range(0, 255); // Random input values (0-255)
        end

        // Display initial input
        $display("Input tensor:");
        
        for (int i = 0; i < SIZE; i = i + 1) 
        begin
            $write("%d ", norm_intf.input_tensor[i]);
        end
        $display("");

        // Wait for a few clock cycles
        #100;

        // Display output after normalization
        $display("Output tensor:");
        for (int i = 0; i < SIZE; i = i + 1) begin
            $write("%d ", norm_intf.output_tensor[i]);
        end
        $display("");
        
        // Stop simulation
        $stop;
    end

endmodule
