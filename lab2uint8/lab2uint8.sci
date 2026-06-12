function [lab] = lab2uint8 (lab)
  if argn(2)<> 1 then
    error ("lab2uint8: one input argument required");
  end
  lab = lab2cls (lab, "uint8");
endfunction
