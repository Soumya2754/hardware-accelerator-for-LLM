`timescale 1ns / 1ps

module instruction_decoder_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Signals
    reg clk;
    reg rst_n;
    reg [2:0] instruction;
    wire enable_matrix_mult;
    wire enable_layer_norm;
    wire [15:0] A [0:1023];
    reg [15:0] B [0:1023];
    reg [15:0] C [0:1023];
    reg [15:0] layer_norm_input [0:1023]; // Wire for layer normalization input tensor

    // Instantiate the module under test
    instruction_decoder dut (
        .clk(clk),
        .rst_n(rst_n),
        .instruction(instruction),
        .enable_matrix_mult(enable_matrix_mult),
        .enable_layer_norm(enable_layer_norm),
        .A(A),
        .B(B),
        .C(C)
    );
    
    // Connect layer normalization input tensor to the DUT
    assign dut.layer_norm_inst.input_tensor = layer_norm_input;

    // Clock generation
    always #((CLK_PERIOD / 2)) clk = ~clk;

    // Initial stimulus
    initial begin
        clk = 0;
        rst_n = 0;
        instruction = 0;

        // Initialize B and C matrices with some test data
        initialize_matrices();

        #100; // Wait for 100 time units
        rst_n = 1;
        #100; // Wait for 100 time units

        // Test case 1: Matrix Multiplication
        instruction = 3'b000;
        #200; // Wait for the operation to complete

        // Verify matrix multiplication results
        verify_matrix_multiplication();

        // Test case 2: Layer Normalization
        instruction = 3'b001;
        #200; // Wait for the operation to complete

        // Provide input tensor values if needed
        // Convert part of the matrix multiplication output to the input tensor for layer normalization
        initialize_layer_norm_input(A);

        // Verify layer normalization results
        #400 verify_layer_normalization();

        #50 $finish; // Stop simulation
    end

    // Task to initialize B and C matrices
    task initialize_matrices;
        integer i;
        begin
            for (i = 0; i < 1024; i = i + 1) begin
                B[i] = i; // Example initialization, change as needed
                C[i] = 1024 - i; // Example initialization, change as needed
            end
        end
    endtask

    // Task to verify matrix multiplication result
    task verify_matrix_multiplication;
        integer i, j, k;
        reg [15:0] expected_value;
        reg [15:0] temp_sum;
        begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    temp_sum = 0;
                    for (k = 0; k < 16; k = k + 1) begin
                        temp_sum = temp_sum + B[i*32 + k] * C[k*32 + j];
                    end
                    expected_value = temp_sum;
                    if (A[i*16 + j] != expected_value) begin
                        $display("Error: A[%0d][%0d] = %h, expected = %h", i, j, A[i*16 + j], expected_value);
                    end else begin
                        $display("Pass: A[%0d][%0d] = %h", i, j, A[i*16 + j]);
                    end
                end
            end
        end
    endtask

    // Task to initialize layer normalization input tensor
    task initialize_layer_norm_input;
    input [15:0] D [0:1023];    
        integer i;
        begin
            for (i = 0; i < 1024; i = i + 1) begin
                layer_norm_input[i] = D[i];
            end
        end
    endtask

    // Task to verify layer normalization result
    task verify_layer_normalization;
        integer i;
        reg [15:0] expected_value;
        begin
            // Example calculation for expected values; replace with your logic
            for (i = 0; i < 1024; i = i + 1) begin
                expected_value = (layer_norm_input[i] - dut.layer_norm_inst.MEAN[i]) * dut.layer_norm_inst.GAMMA_OVER_SQRT_VARIANCE[i] + dut.layer_norm_inst.BETA[i];
                if (dut.layer_norm_inst.output_tensor[i] != expected_value) begin
                    $display("Error: output_tensor[%0d] = %h, expected = %h", i, dut.layer_norm_inst.output_tensor[i], expected_value);
                end else begin
                    $display("Pass: output_tensor[%0d] = %h", i, dut.layer_norm_inst.output_tensor[i]);
                end
            end
        end
    endtask

endmodule
