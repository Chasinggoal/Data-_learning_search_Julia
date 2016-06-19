using PyPlot
using Distributions

function plot_histogram(distribution, n)
    epsilon_values = rand(distribution, n)  # n draws from distribution
    plt[:hist](epsilon_values)
end

lp = Laplace()
plot_histogram(lp, 500)
