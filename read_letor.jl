workspace()
using DataFrames

function read_letor(filename)
    # X is a feature matrix  Y is a ranking cell array


    df = readtable(filename)
    X = convert(Matrix, df[4:end])
    qid_cnt = df[1,1]
    height = size(df)[1]
    row_start = 1
    q=1
    for loop in 1:height
        if df[loop,1] != qid_cnt
            qid_cnt = df[loop,1]
            q = q+1
        end
    end
    Y = cell(q)
    q = 1
    qid_cnt = df[1,1]
    for loop in 1:height
        if df[loop,1] != qid_cnt
            Y[q] = convert(Array, df[row_start:loop-1,3])
            row_start = loop
            q = q+1
            qid_cnt = df[loop,1]
        end
        if loop == height
            Y[q] = convert(Array, df[row_start:loop-1,3])
        end
    end
    return X, Y
end
