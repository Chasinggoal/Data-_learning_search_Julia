set_bigfloat_precision(10000)


function Permutation_Single_Compute_Gradient_Calc(x, b, qid, oid, beta_id)
    #UNTITLED2 Summary of this function goes here
    #   Detailed explanation goes here
    # provides a specifc part of the gradient

    query = x[qid]
    s = size(query)
    item_number = s[1]

    under = 0
    upper = 0

    if oid == item_number
        output = 1
    else
        for loop in oid+1 : item_number
            count = query[loop,:]-query[oid,:]
            result = count*b
            under = under + exp(result[1])
            upper = upper + exp(result[1])*count[beta_id]
        end
        if upper == 0
            output = 0
        else
            output = upper/(under+1)
        end
    end
    return output
end
