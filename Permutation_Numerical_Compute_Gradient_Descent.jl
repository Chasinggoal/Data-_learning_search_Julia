function Permutation_Numerical_Compute_Gradient_Descent_backtracking(filedir)
    #=UNTITLED7 Summary of this function goes here
    #   Detailed explanation goes here
    # T is an integer with the number of iterations
    # step is the step that we take for each iteration
    # Computes gradient directly without pre-calculating the gradient function
    =#
    using PyPlot
    using MATLAB
    T=10000
    step = 0.1  #initialize the step size
    alpha = 0.8  # backtracking constant

    [X,Y] = read_letor(filedir)
    w = zeros(length(X(1, :)), 1)
    param = zeros(length(w),T)
    X_divid = cell(length(Y))                       # create a cell array preparing to cal the likelihood
    cnt=0
    likelihood_vector = zeros(T,1)  #documenting the likelihooda
    likelihood_log_vector = zeros(T,1)  # documenting the log likelihood for graph
    for i = 1 : length(Y)
        [~, index] = sort(Y{i})      # sort Y in ascending order
        tmpX = zeros(length(Y{i}), length(w))   # initialize temporary value for X as 0 matrix for gradient descent

        for j = 1 : length(Y{i})
            tmpX(j, :) = X(cnt + index(j), :)   # document the X that corresponds to each Y
        end
        X_divid{i} = tmpX                       # documenting each X for each part of X_divid
        cnt = cnt + length(Y{i})
    end


    loop = 1
    while loop <= T
        tempW = w
        wrec = w
        inputval = cell(1 , length(w))
        for index = 1:length(w)
            inputval{index} = w(index)
        end
        for i = 1: length(w)
            num_grad = 0
            for j = 1:length(Y)
                for k = 1:length(Y{j})
                    temp_grad = -Permutation_Single_Compute_Gradient_Calc(X_divid,w,j,k,i)
                    num_grad = num_grad+temp_grad
                end
            end
            tempW(i) = w(i) + num_grad*step
        end
        w = tempW
        param(:,loop) = w
        likelihood = Permutation_multiple_query(w,X_divid)  # documenting the likelihood value
        println(w)
        println(log(likelihood))
        println(loop)
        likelihood_vector(loop)=likelihood
        likelihood_log_vector(loop) = log(likelihood)
        if loop > 20
            if likelihood_log_vector(loop)-likelihood_log_vector(loop-1) < 0 && adj<2000
                step = step * alpha
                w = wrec
                adj = adj+1
                continue
            elseif adj >= 2000
                println("too much adjustments")
                break
            end
        end
        if loop > 1
            if abs(likelihood_log_vector(loop)-likelihood_log_vector(loop-1))<0.0000000000001
                println("too small adjustment")
                break
            end
        end
        loop = loop + 1
        adj = 0
    end
    output = param(:,loop-1)
    println(step)
    plot(1:(loop-1),likelihood_log_vector(1:(loop-1)))
    return output
end

function read_letor(filename)
    # X is a feature matrix  Y is a ranking cell array
    using MATLAB
    f = open(filename)
    println(filename)
    X = zeros(10^5, 0)
    qid = ''
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



function Permutation_Single_Compute_Gradient_Calc(x, b, qid, oid, beta_id)
    #UNTITLED2 Summary of this function goes here
    #   Detailed explanation goes here
    # provides a specifc part of the gradient

    query = x{qid}
    s = size(query)
    item_number = s(1)
    e = exp(1)

    under = 0
    upper = 0

    if oid == item_number
        output = 1
    else
        for loop = oid+1 : item_number
            count = query(loop,:)-query(oid,:)
            under = under + e^(count*b)
            upper = upper + e^(count*b)*count(beta_id)
        end
        if upper == 0
            output = 0
        else
            output = upper/(under+1)
        end
    end
    return output
end


function Permutation_multiple_query( b,x )
    #UNTITLED5 Summary of this function goes here
    #   Detailed explanation goes here
    # b is a col vector of weights; x is a cell col vector consisted of outputs
    # of multiple queries

    import Permutation_single_query;
    si = size(x);
    s = si(1);
    p = 1;
    i = 1;
    while i <= s
        current = x{i};
        p = p*(Permutation_single_query(b, current));
        i =  i+1;
    end
    return p
end

function Permutation_single_query( b,x )
    #UNTITLED3 Summary of this function goes here
    #   Detailed explanation goes here
    # x is a matrix of features with ordered rank, b is the weight set col
    # vector

    g = x*b;
    e = exp(1);
    i = 1;
    s = size(g);
    y = 1;
    while i<=s(1)
        y = (y)*(e^(g(i,1)));
        denom = 0;
        indic = 1;
        while indic <= s(1)-i+1
            denom = denom + e^(g(s(1)-indic+1,1));
            indic = indic+1;
        end
        y = y/denom;
        i = i+1;
    end
    return y
end
