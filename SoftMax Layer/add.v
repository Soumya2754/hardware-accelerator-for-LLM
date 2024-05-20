`timescale 1ns / 1ps

module add (
    input [15:0] A_FP, 
    input [15:0] B_FP,
    output reg [15:0] out
); 
    reg       sign; 
    reg [4:0] exponent; 
    reg [10:0] mantissa;
    integer i;
    //variables used in an always block
    //are declared as registers
    reg sign_a, sign_b, sign_c;
    reg [4:0] e_A, e_B;
    reg [11:0] fract_a, fract_b, fract_c;
    reg [4:0] shift_cnt;
    reg cout;
    
    always @ (A_FP or B_FP)
    begin
        if(A_FP==0)
        begin
            sign = B_FP[15];
            exponent = B_FP[14:10];
            mantissa = B_FP[9:0];
        end
        else if(B_FP==0)
        begin
            sign = A_FP[15];
            exponent = A_FP[14:10];
            mantissa = A_FP[9:0];
        end
        else
        begin
            sign_a = A_FP[15];
            sign_b = B_FP[15];
            e_A = A_FP[14:10];
            e_B = B_FP[14:10];
            fract_a = {1'b1, A_FP[9:0]};
            fract_b = {1'b1, B_FP[9:0]};
            
            // Align fractions
            if(sign_a==sign_b)
            begin
                if (e_A < e_B)
                begin
                    shift_cnt = e_B - e_A;
                    fract_a = fract_a >> shift_cnt;
                    e_A = e_A + shift_cnt;  
                end 
                if (e_B < e_A)
                begin
                    shift_cnt = e_A - e_B;
                    fract_b = fract_b >> shift_cnt;
                    e_B = e_B + shift_cnt;
                end 
                
                // Add fractions
                fract_c = fract_a + fract_b;
                {cout, fract_c} = fract_a + fract_b;
                
                // Normalize result
                if (cout==1)
                begin
                    {cout, fract_c} = {cout, fract_c} >> 1;
                    e_B = e_B + 1;
                end
                
                sign = sign_a;
                exponent = e_B;
            end
            else
            begin 
                if({e_A, fract_a} > {e_B, fract_b})
                begin
                    sign = sign_a;
                    shift_cnt = e_A - e_B;
                    e_B = e_B + shift_cnt;
                    fract_b = fract_b >> shift_cnt;
                    fract_c = fract_a - fract_b;
                    exponent = e_A;
                    
                    for(i = 0; i < 11; i = i + 1)
                    begin
                        if(fract_c[11]==0)
                        begin
                            fract_c = fract_c << 1;
                            exponent = exponent - 1;
                        end
                    end
                end
                else
                begin
                    sign = sign_b;
                    shift_cnt = e_B - e_A;
                    e_A = e_A + shift_cnt;
                    fract_a = fract_a >> shift_cnt;
                    fract_c = fract_b - fract_a;
                    exponent = e_B;
                    
                    if(fract_c==12'b0) 
                    begin 
                        exponent = 0;
                        sign = 0;
                    end
                    
                    if(fract_c!=12'b0)  
                    begin
                        for(i = 0; i < 11; i = i + 1)
                        begin
                            if(fract_c[11]==0)
                            begin
                                fract_c = fract_c << 1;
                                exponent = exponent - 1;
                            end
                        end
                    end
                end
            end
            mantissa = (fract_a == 0 && fract_b == 0) ? 11'b0 : fract_c[10:0];
        end
        
   end
   
   always@(*)
        begin
         out[15] = sign;
         out[14:10] = exponent;
         out[9:0] = mantissa; 
        end
        
endmodule
