function [7:0] genFlt(input sign, input [2:0] exp, 
                      input [3:0] frac);
begin 
    genFlt = {sign, exp, frac}; 
end
endfunction

function real getReal(input [7:0] inp); 
begin
    if (inp[6:0] == 'b0) begin 
        getReal = 0.0;
    end else begin
        getReal = $pow(-1.0, $itor(inp[7]))*(1 + ($itor(inp[3:0])/16.0))
                  *$pow(2.0, ($itor(inp[6:4]) - 3));
   end
end
endfunction  