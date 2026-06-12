function [lab] = lab2single (lab)
  if argn(2) <> 1 then
    error("lab2single: one input argument required");
  end
  lab = lab2cls (lab, "single");
endfunction
