function tf = isa(obj, typeName)
    //==========================================================================
    // ISA - Check whether an object is of a specified type or class.
    //
    // Syntax:
    //    tf = isa(obj, typeName)
    //
    // Inputs:
    //    obj      - Any Scilab variable
    //    typeName - Type/class name (string)
    //
    // Output:
    //    tf       - Boolean
    //==========================================================================
    if argn(2) <> 2 then
        error(msprintf("%s: Wrong number of input arguments: %d expected.\n", ..
              "isa", 2));
    end
    if typeof(typeName) <> "string" | size(typeName, "*") <> 1 then
        error(msprintf("%s: Second argument must be a single string.\n", ..
              "isa"));
    end
    typeName = convstr(typeName, "l");
    objType  = convstr(typeof(obj), "l");
    tf = %f;
    select typeName
    //==============================================================
    // Basic types
    //==============================================================
    case "double" then
        tf = (objType == "constant");
    case "string" then
        tf = (objType == "string");
    case "boolean" then
        tf = (objType == "boolean");
    case "bool" then
        tf = (objType == "boolean");
    case "poly" then
        tf = (objType == "polynomial");
    case "polynom" then
        tf = (objType == "polynomial");
    case "polynomial" then
        tf = (objType == "polynomial");
    case "list" then
        tf = (objType == "list");
    case "tlist" then
        tf = (objType == "tlist");
    case "mlist" then
        tf = (objType == "mlist");
    case "sparse" then
        tf = (objType == "sparse");
    case "bsparse" then
        tf = (objType == "boolean sparse");
    case "booleansparse" then
        tf = (objType == "boolean sparse");
    case "boolean sparse" then
        tf = (objType == "boolean sparse");
    case "library" then
        tf = (objType == "library");
    case "lib" then
        tf = (objType == "library");
    case "cell" then
        tf = (objType == "ce");
    case "ce" then
        tf = (objType == "ce");
    case "function" then
        tf = or(objType == ["function" "fptr"]);
    case "macro" then
        tf = (objType == "function");
    case "fptr" then
        tf = (objType == "fptr");
    case "builtin" then
        tf = (objType == "fptr");
    //==============================================================
    // Integer types
    //==============================================================
    case "int8" then
        tf = (objType == "int8");
    case "int16" then
        tf = (objType == "int16");
    case "int32" then
        tf = (objType == "int32");
    case "int64" then
        tf = (objType == "int64");
    case "uint8" then
        tf = (objType == "uint8");
    case "uint16" then
        tf = (objType == "uint16");
    case "uint32" then
        tf = (objType == "uint32");
    case "uint64" then
        tf = (objType == "uint64");
    //==============================================================
    // Integer families
    //==============================================================
    case "int" then
        tf = or(objType == ["int8" "int16" "int32" "int64" ..
                            "uint8" "uint16" "uint32" "uint64"]);
    case "integer" then
        tf = or(objType == ["int8" "int16" "int32" "int64" ..
                            "uint8" "uint16" "uint32" "uint64"]);
    case "signed" then
        tf = or(objType == ["int8" "int16" "int32" "int64"]);
    case "unsigned" then
        tf = or(objType == ["uint8" "uint16" "uint32" "uint64"]);
    //==============================================================
    // Fallback: user-defined tlist/mlist types
    //==============================================================
    else
        // For user-defined tlist/mlist classes, typeof() returns
        // the type name directly, so a simple comparison works.
        tf = (objType == typeName);
    end
endfunction
