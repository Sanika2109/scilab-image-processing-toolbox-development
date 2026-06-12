function [lab] = lab2uint16 (lab)
  if argn(2) <> 1 then
    error("lab2uint16: one input argument required");
  end
  lab = lab2cls (lab, "uint16");
endfunction
