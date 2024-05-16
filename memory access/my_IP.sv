module memory_wrapper (
    input  logic                   clk,
    input  logic                   rst,
    input  logic                   req_valid,
    input  logic [31:0]            va,          // Virtual address
    input  logic                   write_req,   // Write request signal
    input  logic [31:0]            data_in,     // Data to be written (for write request)
    output logic [31:0]            data_out,
    output logic                   resp         // Response: OKAY, EXOKAY, or SLVERR
);

// SMMU control signals
logic [31:0]                     smmu_addr;    // SMMU address (Virtual address or register address)
logic [31:0]                     smmu_data_in; // SMMU data in (for write operations)
logic                            smmu_valid;   // SMMU request valid signal
logic [31:0]                     smmu_data_out;// SMMU data out (for read operations)
logic                            smmu_resp;   

assign resp = smmu_resp;

// Generate SMMU request based on IP inputs
always @(posedge clk or posedge rst) 
begin
    if (rst) 
    begin
        smmu_valid <= 1'b0;
        smmu_addr <= 32'b0;
        smmu_data_in <= 32'b0;
    end
    else if (req_valid) 
    begin
        smmu_valid <= 1'b1;
        smmu_addr <= va;
        smmu_data_in <= data_in;
    end
    else 
    begin
        smmu_valid <= 1'b0;
    end
end

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        data_out <= 32'b0;
    end
    else if (smmu_valid && write_req && smmu_resp == 0)
    begin
        data_out <= smmu_data_out;
    end
end

endmodule
