set_bigfloat_precision(10000)


function Log_Permutation_multiple_query( b,x )
    #UNTITLED5 Summary of this function goes here
    #   Detailed explanation goes here
    # b is a col vector of weights  x is a cell col vector consisted of outputs
    # of multiple queries

    require("Log_Permutation_single_query.jl")
    si = size(x)
    s = si[1]
    p = 1
    i = 1
    while i <= s
        current = x[i]
        p = p+(Log_Permutation_single_query(b, current))
        i =  i+1
    end
    return p
end
