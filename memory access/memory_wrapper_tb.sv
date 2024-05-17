`timescale 1ns / 1ps

module memory_wrapper_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Signals
    logic clk;
    logic rst;
    logic req_valid;
    logic [31:0] va;          // Virtual address
    logic write_req;          // Write request signal
    logic [31:0] data_in;     // Data to be written (for write request)
    logic [31:0] data_out;
    logic resp;         // Response: OKAY, EXOKAY, or SLVERR

    // Instantiate the module under test
    memory_wrapper dut (
        .clk(clk),
        .rst(rst),
        .req_valid(req_valid),
        .va(va),
        .write_req(write_req),
        .data_in(data_in),
        .data_out(data_out),
        .resp(resp)
    );

    logic [31:0] write_data;

    // Clock generation
    initial 
    begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Initial stimulus
    initial 
    begin
        // Initialize signals
        rst = 0;
        req_valid = 0;
        va = 32'h0;
        write_req = 0;
        data_in = 32'h0;

        // Apply reset
        rst = 1;
        #50; // Wait for 20 time units
        rst = 0;
        #50; // Wait for 20 time units

        // Test case 2: Simple write operation
        req_valid = 1;
        va = 32'h2000;
        write_req = 1;
        data_in = 32'h12345678;
        #20;
        write_data = dut.smmu_data_in;
      	dut.smmu_resp = 0;
        #20; // Wait for 20 time units

        // Check resp for write operation
        if (resp != 0) 
        begin
            $display("Error: Write operation failed. resp = %h", resp);
        end 
        else 
        begin
            $display("Pass: Write operation successful. resp = %h", resp);
        end
		dut.smmu_resp = 1;
        

        // Test case 3: Read operation to verify write
        req_valid = 1;
        va = 32'h2000;
        write_req = 0;
        dut.smmu_data_out = write_data;
      	dut.smmu_resp = 0;
        #20; // Wait for 20 time units

        // Check data_out and resp for read operation
        if (data_out != 32'h12345678 || resp != 0) 
        begin
            $display("Error: Read operation after write failed. data_out = %h, resp = %h", data_out, resp);
        end 
        else 
        begin
            $display("Pass: Read operation after write successful. data_out = %h, resp = %h", data_out, resp);
        end
    end

    // Stop simulation after a certain time
    initial
    begin
        #500 $finish; // Stop simulation
    end
	initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
endmodule
