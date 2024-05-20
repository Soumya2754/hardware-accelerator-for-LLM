`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//By: Basant Loay Abdalla
//////////////////////////////////////////////////////////////////////////////////

//calculating exponential using Taylor Expansion
module exponential(inputX,temp);
localparam size=16;
localparam noOfTerms=6;
localparam [15:0] constants[5:0]={  16'b0000101100000111, // IEEE representation of 1/720
                                    16'b0000110000010001, // IEEE representation of 1/120
                                    16'b0000110101010111, // IEEE representation of 1/24
                                    16'b0000111000010111, // IEEE representation of 1/6
                                    16'b0000111100000000, // IEEE representation of 1/2
                                    16'b0000111110000000}; // IEEE representation of 1  
                                                   
input [15:0] inputX;
wire  [95:0] outY;
output [15:0] temp;
reg[15:0] exception=16'b0000111110000000;
wire [95:0] powerX ;
wire [95:0] holder;
reg [15:0] sum=16'b0000000000000000;//initialized by 0

assign outY[15:0] =16'b0000111110000000;//initialzed by 1
assign powerX[15:0] =16'b0000111110000000;//initialzed by 1

//calculating first six terms as first of value 1 initialized in outY
// module term multiply input number consequetively and multiply by constant 
genvar z;
for (z = 1; z < noOfTerms; z = z + 1)
begin
    term firstTerm(.originalNum(inputX),
                   .poweredNum(powerX[(z+1)*size-1 : (z)*size]),
                   .reciporical(constants[z]),
                   .outPower(powerX[(z+1)*size-1 : (z)*size]),
                   .outTerm(holder[(z+1)*size-1 : (z)*size]));
                   
    add addition1(.A_FP(holder[(z+1)*size-1 : (z)*size]),
                  .B_FP(outY[(z+1)*size-1 : (z)*size]),
                  .out(outY[(z+1)*size-1 : (z)*size]));
end            

assign temp = outY[95:80];
endmodule
