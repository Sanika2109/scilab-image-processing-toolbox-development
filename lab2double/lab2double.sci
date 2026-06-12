function [lab] = lab2double (lab)
  if argn(2) <> 1 then
    error("lab2double: one input argument required");
  end
  lab = lab2cls (lab, "double");
endfunction
