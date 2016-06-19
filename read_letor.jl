function read_letor(filename)
    # X is a feature matrix  Y is a ranking cell array
    using MATLAB
    f = open(filename)
    println(filename)
    X = zeros(10^5, 0)
    qid = ""
    i = 0
    q = 0
    Y=cell(10^5)
    while 1
        l = readline(f)
        if !typeof(l)==ASCIIString
            break
        end

        i = i + 1
        [lab,  ~, ~, ind] = sscanf(l, "#d qid:", 1)
        l(1:ind-1) = []
        [nqid, ~, ~, ind] = sscanf(l, "#s", 1)
        l(1:ind-1 )= []

        if nqid != qid
            q = q + 1
            qid = nqid
            Y{q} = lab
        else
            Y{q} = [Y{q}  lab]
        end

        tmp = sscanf(l, "#d:#f")
        X(i, tmp(1 : 2 : end)) = tmp(2 : 2 : end)
    end

    X = X(1 : i, :)
    Y = Y(1:q)
    fclose(f)
    return [X,Y]
end
