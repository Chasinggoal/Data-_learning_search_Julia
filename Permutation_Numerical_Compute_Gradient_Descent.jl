using PyPlot
set_bigfloat_precision(10000)

function Permutation_Numerical_Compute_Gradient_Descent_backtracking(filedir)
    #=UNTITLED7 Summary of this function goes here
    #   Detailed explanation goes here
    # T is an integer with the number of iterations
    # step is the step that we take for each iteration
    # Computes gradient directly without pre-calculating the gradient function
    =#
    push!(LOAD_PATH,"/Users/David/Documents/Julia/Data_Plus")
    require("Permutation_single_query.jl")
    require("Permutation_multiple_query.jl")
    require("Permutation_Single_Compute_Gradient_Calc.jl")
    require("read_letor.jl")

    T=1000
    step = 0.1  #initialize the step size
    alpha = 0.8  # backtracking constant

    X,Y = read_letor(filedir)
    w = zeros(length(X[1, :]), 1)
    param = zeros(length(w),T)
    X_divid = cell(length(Y))                       # create a cell array preparing to cal the likelihood
    cnt=0
    likelihood_vector = zeros(T,1)  #documenting the likelihooda
    likelihood_log_vector = zeros(T,1)  # documenting the log likelihood for graph
    for i in 1 : length(Y)
        index = sortperm(Y[i])      # sort Y in ascending order
        tmpX = zeros(length(Y[i]), length(w))   # initialize temporary value for X as 0 matrix for gradient descent
        for j in 1 : length(Y[i])
            tmpX[j, :] = X[cnt + index[j], :]   # document the X that corresponds to each Y
        end
        X_divid[i] = tmpX                       # documenting each X for each part of X_divid
        cnt = cnt + length(Y[i])
    end


    loop = 1
    while loop <= T
        tempW = w
        wrec = w
        for i in 1:length(w)
            num_grad = 0
            for j in 1:length(Y)
                for k in 1:length(Y[j])
                    temp_grad = -Permutation_Single_Compute_Gradient_Calc(X_divid,w,j,k,i)
                    num_grad = num_grad+temp_grad
                end
            end
            tempW[i] = w[i] + num_grad*step
        end
        w = tempW
        param[:,loop] = w
        likelihood = Permutation_multiple_query(w,X_divid)  # documenting the likelihood value
        println(w)
        println(log(likelihood))
        println(loop)
        likelihood_vector[loop]=likelihood
        likelihood_log_vector[loop] = log(likelihood)
        if loop > 20
            if likelihood_log_vector[loop]-likelihood_log_vector[loop-1] < 0 && adj<2000
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
            if abs(likelihood_log_vector[loop]-likelihood_log_vector[loop-1])<0.0000000000001
                println("too small adjustment")
                break
            end
        end
        loop = loop + 1
        adj = 0
    end
    output = param[:,loop-1]
    println(step)
    plot(1:(loop-1),likelihood_log_vector[1:(loop-1)])
    return output
end
