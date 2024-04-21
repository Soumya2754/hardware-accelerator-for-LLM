interface dut_if;
    logic clk;
    logic [7:0] input_tensor[2:0];
    logic [15:0] output_tensor[2:0];
endinterface

module layer_normalization_tb;

    // Parameters
    localparam int WIDTH = 8;
    localparam int SIZE = 3;

    // Declare interface signals
    dut_if dut_intf;

    // Instantiate DUT
    layer_normalization_inference dut (
        .clk(dut_intf.clk),
        .input_tensor(dut_intf.input_tensor),
        .output_tensor(dut_intf.output_tensor)
    );

    // Clock generation
    always #5 dut_intf.clk = ~dut_intf.clk;

    // Testbench stimulus
    initial begin
        // Initialize inputs
        foreach (dut_intf.input_tensor[i]) begin
            dut_intf.input_tensor[i] = $urandom_range(0, 255); // Random input values (0-255)
        end

        // Display initial input
        $display("Input tensor:");
        foreach (dut_intf.input_tensor[i]) begin
            $write("%d ", dut_intf.input_tensor[i]);
        end
        $display("");

        // Wait for a few clock cycles
        #10;

        // Display output after normalization
        $display("Output tensor:");
        foreach (dut_intf.output_tensor[i]) begin
            $write("%d ", dut_intf.output_tensor[i]);
        end
        $display("");
        
        // Stop simulation
        $stop;
    end

endmodule

