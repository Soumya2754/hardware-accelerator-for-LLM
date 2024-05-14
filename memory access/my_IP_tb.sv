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
        // Example: Read operation
        // (Hardcoded simulation of SMMU characteristics)
        logic smmu_req;
        logic [2:0] smmu_op;
        logic [31:0] smmu_addr;
        logic [1:0] smmu_size;
        logic smmu_valid;
        logic [31:0] smmu_data_in;
        logic [31:0] smmu_data_out;
        logic [1:0] smmu_resp;
    
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
    #10;
    // Assertion: Check if data_out is correctly updated
    if (data_out == 32'h55555555) begin
        $display("Read operation successful");
    end else begin
        $display("Read operation failed");
    end

    // Test write operation
    va = 32'h87654321;
    write_req = 1;
    data_in = 32'hABCDEFFF;
    #10;
    // Assertion: Check if write request is successful
    if (resp == 2'b00) begin
        $display("Write operation successful");
    end else begin
        $display("Write operation failed");
    end

    // Simulate SMMU requests
    // Example: Read operation
    // (Hardcoded simulation of SMMU characteristics)
    smmu_req <= 1'b1;
    smmu_op <= 3'b000; // Normal memory access
    smmu_addr <= 32'h12345678;
    smmu_size <= 2'b10; // 32 bytes transaction size
    smmu_valid <= 1'b1;
    
    // Example: Write operation
    // (Hardcoded simulation of SMMU characteristics)
    smmu_req <= 1'b1;
    smmu_op <= 3'b010; // Secure register write
    smmu_addr <= 32'h87654321;
    smmu_data_in <= 32'hABCDEFFF; // Data to be written
    smmu_size <= 2'b10; // 32 bytes transaction size
    smmu_valid <= 1'b1;

    // End simulation
    #10;
    $finish;
end

endmodule
