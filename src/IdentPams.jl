module IdentPams

using LinearAlgebra
using DiffEqSensitivity
using Plots,LaTeXStrings

include("SensitiveCoefficients.jl")
include("SensitiveMatrixs.jl")
include("plotbars.jl")

end # module
