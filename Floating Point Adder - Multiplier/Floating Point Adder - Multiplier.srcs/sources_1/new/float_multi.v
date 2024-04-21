`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2024 20:44:27
// Design Name: 
// Module Name: float_multi
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//float multi multiplier floating point numbers.
module float_multi(num1, num2, result, overflow, zero, NaN, precisionLost);
  //Operands
  input [15:0] num1, num2;
  output [15:0] result;
  //Flags
  output overflow;//overflow flag
  output zero; //zero flag
  output NaN; //Not a Number flag
  output precisionLost;
  //Decode numbers
  wire sign1, sign2, signR; //hold signs
  wire [4:0] ex1, ex2, exR; //hold exponents
  wire [4:0] ex1_pre, ex2_pre, exR_calc; //hold exponents
  reg [4:0] exSubCor;
  wire [4:0] exSum_fault;
  wire ex_cannot_correct;
  wire [9:0] fra1, fra2, fraR; //hold fractions
  reg [9:0] fraSub, fraSub_corrected;
  wire [20:0] float1;
  wire [10:0] float2;
  wire exSum_sign;
  wire [6:0] exSum;
  wire [5:0] exSum_prebais, exSum_abs; //exponent sum
  wire [11:0] float_res, float_res_preround; //result
  wire [9:0] float_res_fra;
  wire [9:0] dump_res; //Lost precision
  reg [21:0] res_full;
  wire [21:0] res_full_preshift;
  reg [20:0] mid[10:0];
  wire inf_num; //at least on of the operands is inf.
  wire subNormal;
  wire zero_num_in, zero_calculated;

  //Partial flags
  assign zero_num_in = ~(|num1[14:0] & |num2[14:0]);
  assign zero_calculated = (subNormal & (fraSub == 10'd0)) | (exSum_sign & (~|res_full[20:11]));
  assign ex_cannot_correct = {1'b0,exSubCor} > exSum_abs; //?: or >=

  //Flags
  assign zero = zero_num_in | zero_calculated;
  assign NaN = (&num1[14:10] & |num1[9:0]) | (&num2[14:10] & |num2[9:0]);
  assign inf_num = (&num1[14:10] & ~|num1[9:0]) | (&num2[14:10] & ~|num2[9:0]); //check for infinate number
  assign overflow = inf_num | (~exSum[6] & exSum[5]);
  assign subNormal = ~|float_res[11:10];
  assign precisionLost = |dump_res | (exSum_prebais < 6'd15);
  
  //decode-encode numbers
  assign {sign1, ex1_pre, fra1} = num1;
  assign {sign2, ex2_pre, fra2} = num2;
  assign ex1 = ex1_pre + {4'd0, ~|ex1_pre};
  assign ex2 = ex2_pre + {4'd0, ~|ex2_pre};
  assign result = {signR, exR, fraR};
  
  //exponentials are added
  assign exSum = exSum_prebais - 7'd15;
  assign exSum_prebais = {1'b0,ex1} + {1'b0,ex2};
  assign exSum_abs = (exSum_sign) ? (~exSum[5:0] + 6'd1) : exSum[5:0];
  assign exSum_sign = exSum[6];

  //Get floating numbers
  assign float1 = {|ex1_pre, fra1, 10'd0};
  assign float2 = {|ex2_pre, fra2};

  //Calculate result
  assign signR = (sign1 ^ sign2);
  assign exR_calc = exSum[4:0] + {4'd0, float_res[11]} + (~exSubCor & {5{subNormal}}) + {4'd0, subNormal};
  assign exR = (exR_calc | {5{overflow}}) & {5{~(zero | exSum_sign | ex_cannot_correct)}};
  assign fraR = ((exSum_sign) ? res_full[20:11] :((subNormal) ? fraSub_corrected : float_res_fra)) & {10{~(zero | overflow)}} ;
  assign float_res_fra = (float_res[11]) ? float_res[10:1] : float_res[9:0];
  assign float_res = float_res_preround + {10'd0,dump_res[9]}; //? possibly generates wrong result due to overflow
  assign {float_res_preround, dump_res} = res_full_preshift;
  assign res_full_preshift = mid[0] + mid[1] + mid[2] + mid[3] + mid[4] + mid[5] + mid[6] + mid[7] + mid[8] + mid[9] + mid[10];
  assign exSum_fault = exSubCor - exSum_abs[4:0];
  
  always@*
    begin
      if(exSum_sign)
        case(exSum_abs)
          6'h0: res_full = res_full_preshift;
          6'h1: res_full = (res_full_preshift >> 1);
          6'h2: res_full = (res_full_preshift >> 2);
          6'h3: res_full = (res_full_preshift >> 3);
          6'h4: res_full = (res_full_preshift >> 4);
          6'h5: res_full = (res_full_preshift >> 5);
          6'h6: res_full = (res_full_preshift >> 6);
          6'h7: res_full = (res_full_preshift >> 7);
          6'h8: res_full = (res_full_preshift >> 8);
          6'h9: res_full = (res_full_preshift >> 9);
          6'ha: res_full = (res_full_preshift >> 10);
          6'hb: res_full = (res_full_preshift >> 11);
          6'hc: res_full = (res_full_preshift >> 12);
          6'hd: res_full = (res_full_preshift >> 13);
          6'he: res_full = (res_full_preshift >> 14);
          6'hf: res_full = (res_full_preshift >> 15);
          default: res_full = (res_full_preshift >> 16);
        endcase
      else
        res_full = res_full_preshift;
    end
    
  always@*
    begin
      if(ex_cannot_correct)
        case(exSum_fault)
          5'h0: fraSub_corrected = fraSub;
          5'h1: fraSub_corrected = (fraSub >> 1);
          5'h2: fraSub_corrected = (fraSub >> 2);
          5'h3: fraSub_corrected = (fraSub >> 3);
          5'h4: fraSub_corrected = (fraSub >> 4);
          5'h5: fraSub_corrected = (fraSub >> 5);
          5'h6: fraSub_corrected = (fraSub >> 6);
          5'h7: fraSub_corrected = (fraSub >> 7);
          5'h8: fraSub_corrected = (fraSub >> 8);
          5'h9: fraSub_corrected = (fraSub >> 9);
          default: fraSub_corrected = 10'h0;
        endcase
      else
        fraSub_corrected = fraSub;
    end

  always@* //create mids from fractions
    begin
      mid[0] = (float1 >> 10) & {21{float2[0]}};
      mid[1] = (float1 >> 9)  & {21{float2[1]}};
      mid[2] = (float1 >> 8)  & {21{float2[2]}};
      mid[3] = (float1 >> 7)  & {21{float2[3]}};
      mid[4] = (float1 >> 6)  & {21{float2[4]}};
      mid[5] = (float1 >> 5)  & {21{float2[5]}};
      mid[6] = (float1 >> 4)  & {21{float2[6]}};
      mid[7] = (float1 >> 3)  & {21{float2[7]}};
      mid[8] = (float1 >> 2)  & {21{float2[8]}};
      mid[9] = (float1 >> 1)  & {21{float2[9]}};
      mid[10] = float1        & {21{float2[10]}};
    end
  //Corrections for subnormal normal op
  always@*
    begin
      casex(res_full)
        22'b001xxxxxxxxxxxxxxxxxxx:
          begin
            fraSub = res_full[18:9];
          end
        22'b0001xxxxxxxxxxxxxxxxxx:
          begin
            fraSub = res_full[17:8];
          end
        22'b00001xxxxxxxxxxxxxxxxx:
          begin
            fraSub = res_full[16:7];
          end
        22'b000001xxxxxxxxxxxxxxxx:
          begin
            fraSub = res_full[15:6];
          end
        22'b0000001xxxxxxxxxxxxxxx:
          begin
            fraSub = res_full[14:5];
          end
        22'b00000001xxxxxxxxxxxxxx:
          begin
            fraSub = res_full[13:4];
          end
        22'b000000001xxxxxxxxxxxxx:
          begin
            fraSub = res_full[12:3];
          end
        22'b0000000001xxxxxxxxxxxx:
          begin
            fraSub = res_full[11:2];
          end
        22'b00000000001xxxxxxxxxxx:
          begin
            fraSub = res_full[10:1];
          end
        22'b000000000001xxxxxxxxxx:
          begin
            fraSub = res_full[9:0];
          end
        22'b0000000000001xxxxxxxxx:
          begin
            fraSub = {res_full[8:0], 1'd0};
          end
        22'b00000000000001xxxxxxxx:
          begin
            fraSub = {res_full[7:0], 2'd0};
          end
        22'b000000000000001xxxxxxx:
          begin
            fraSub = {res_full[6:0], 3'd0};
          end
        22'b0000000000000001xxxxxx:
          begin
            fraSub = {res_full[5:0], 4'd0};
          end
        22'b00000000000000001xxxxx:
          begin
            fraSub = {res_full[4:0], 5'd0};
          end
        22'b000000000000000001xxxx:
          begin
            fraSub = {res_full[3:0], 6'd0};
          end
        22'b0000000000000000001xxx:
          begin
            fraSub = {res_full[2:0], 7'd0};
          end
        22'b00000000000000000001xx:
          begin
            fraSub = {res_full[1:0], 8'd0};
          end
        22'b000000000000000000001x:
          begin
            fraSub = {res_full[0], 9'd0};
          end
        default:
          begin
            fraSub = 10'd0;
          end
      endcase
    end
    
  always@*
    begin
      casex(res_full)
        22'b001xxxxxxxxxxxxxxxxxxx:
          begin
            exSubCor = 5'd1;
          end
        22'b0001xxxxxxxxxxxxxxxxxx:
          begin
            exSubCor = 5'd2;
          end
        22'b00001xxxxxxxxxxxxxxxxx:
          begin
            exSubCor = 5'd3;
          end
        22'b000001xxxxxxxxxxxxxxxx:
          begin
            exSubCor = 5'd4;
          end
        22'b0000001xxxxxxxxxxxxxxx:
          begin
            exSubCor = 5'd5;
          end
        22'b00000001xxxxxxxxxxxxxx:
          begin
            exSubCor = 5'd6;
          end
        22'b000000001xxxxxxxxxxxxx:
          begin
            exSubCor = 5'd7;
          end
        22'b0000000001xxxxxxxxxxxx:
          begin
            exSubCor = 5'd8;
          end
        22'b00000000001xxxxxxxxxxx:
          begin
            exSubCor = 5'd9;
          end
        22'b000000000001xxxxxxxxxx:
          begin
            exSubCor = 5'd10;
          end
        22'b0000000000001xxxxxxxxx:
          begin
            exSubCor = 5'd11;
          end
        22'b00000000000001xxxxxxxx:
          begin
            exSubCor = 5'd12;
          end
        22'b000000000000001xxxxxxx:
          begin
            exSubCor = 5'd13;
          end
        22'b0000000000000001xxxxxx:
          begin
            exSubCor = 5'd14;
          end
        22'b00000000000000001xxxxx:
          begin
            exSubCor = 5'd15;
          end
        22'b000000000000000001xxxx:
          begin
            exSubCor = 5'd16;
          end
        22'b0000000000000000001xxx:
          begin
            exSubCor = 5'd17;
          end
        22'b00000000000000000001xx:
          begin
            exSubCor = 5'd18;
          end
        22'b000000000000000000001x:
          begin
            exSubCor = 5'd19;
          end
        default:
          begin
            exSubCor = 5'd0;
          end
      endcase
    end
    
endmodule
