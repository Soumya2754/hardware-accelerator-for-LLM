`timescale 1ns / 1ps

module my_IP_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns
    
    // Signals
    logic clk = 0;
    logic rst = 1;
    logic [31:0] va;
    logic write_req;
    logic [31:0] data_in;
    logic [31:0] data_out;
    logic [1:0] resp;
    
    // Simulate SMMU requests
    logic smmu_req;
    logic [2:0] smmu_op;
    logic [31:0] smmu_addr;
    logic [1:0] smmu_size;
    logic smmu_valid;
    logic [31:0] smmu_data_in;
    //logic [31:0] smmu_data_out;
    //logic [1:0] smmu_resp;
    
    // Instantiate the DUT
    my_IP dut (
        .clk(clk),
        .rst(rst),
        .va(va),
        .write_req(write_req),
        .data_in(data_in),
        .data_out(data_out),
        .resp(resp)
    );
    
    // Clock generation
    initial begin
        // Clock generation
        forever #((CLK_PERIOD)/2) clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Reset
        rst = 0;
        #100;
        rst = 1;

        // Test read operation
        va = 32'h12345678;
        write_req = 0;
        data_in = 32'h0;
        #90;
        // Assertion: Check if data_out is correctly updated
        if (data_out == 32'h55555555) begin
            $display("Read operation successful");
            // Assertion: Check if data_out is updated correctly after read operation
            if (data_out == 32'h12345678) begin
                $display("Data out updated correctly after read operation");
            end else begin
                $display("Data out not updated correctly after read operation");
            end
        end else begin
            $display("Read operation failed");
        end

        // Test write operation
        va = 32'h87654321;
        write_req = 1;
        data_in = 32'hABCDEFFF;
        #90;
        // Assertion: Check if write request is successful
        if (resp == 2'b00) begin
            $display("Write operation successful");
            // Assertion: Check if data_out is updated correctly after write operation
            if (data_out == 32'hABCDEFFF) begin
                $display("Data out updated correctly after write operation");
            end else begin
                $display("Data out not updated correctly after write operation");
            end
        end else begin
            $display("Write operation failed");
        end
    end

    // Simulate SMMU requests
    // Read operation
    always @(posedge clk) begin
        if (rst) begin
            smmu_req <= 1'b0;
            smmu_valid <= 1'b0;
        end else begin
            smmu_req <= 1'b1;
            smmu_op <= 3'b000; // Normal memory access
            smmu_addr <= 32'h12345678;
            smmu_size <= 2'b10; // 32 bytes transaction size
            smmu_valid <= 1'b1;
            #10; // Delay for simulation
            smmu_req <= 1'b0; // Clear the request
            smmu_valid <= 1'b0; // Clear the valid signal
        end
    end

    // Write operation
    always @(posedge clk) begin
        if (rst) begin
            smmu_req <= 1'b0;
            smmu_valid <= 1'b0;
        end else begin
            smmu_req <= 1'b1;
            smmu_op <= 3'b010; // Secure register write
            smmu_addr <= 32'h87654321;
            smmu_data_in <= 32'hABCDEFFF; // Data to be written
            smmu_size <= 2'b10; // 32 bytes transaction size
            smmu_valid <= 1'b1;
            #10; // Delay for simulation
            smmu_req <= 1'b0; // Clear the request
            smmu_valid <= 1'b0; // Clear the valid signal
        end
    end

    // Monitor SMMU response
    /*always @(posedge clk) begin
        if (smmu_valid) begin
            smmu_resp <= smmu_resp;
            smmu_data_out <= smmu_data_out;
        end
    end*/

endmodule
