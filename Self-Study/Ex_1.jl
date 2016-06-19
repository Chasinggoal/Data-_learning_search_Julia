function factorial2(n)
    output = 1
    for loop=1:n
        output = output * loop
    end
    return output
end

function Binomial_rv(n,p)
    output = 0
    for loop=1:n
        a = rand()
        println(a)
        if a > p
            output = output + 1
        end
    end
    return output
end
