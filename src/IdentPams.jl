module IdentPams

using DiffEqSensitivity

#=

tspan=[t_start,t_end];
prob = ODELocalSensitivityProblem(model_hiv,X0,tspan,p)
sol = solve(prob,Tsit5(), saveat=val_Time)

Solve_odes,Sens_coeff = extract_local_sensitivities(sol)
Time_count = length(sol.t)
num_of_param = length(df.symbol)
num_of_eq=length(X0)


H = [
    1 1 1 1 0 0 0 0;
    0 0 0 0 1 1 0 0;
    0 0 0 0 0 0 1 0;
    0 0 0 0 0 0 0 1
    ]
    
num_add_con = size(H,1)
Sens_matrix = zeros(Time_count*num_add_con,num_of_param)

for index_time in 1:Time_count
    start_ind = num_add_con*index_time-(num_add_con-1)
    finish_ind = num_add_con*index_time

    for index_pam in 1:num_of_param
        Sens_matrix[start_ind:finish_ind,index_pam] = H*Sens_coeff[index_pam][:,index_time]
    end
  
end

set_Index = []
index_parametes = [i for i in 1:length(df.symbol)]
set_Values = []

matrix_E = []
value, index = maxim(Sens_matrix)
append!(set_Index,index_parametes[index])
index_parametes = index_parametes[1:end .!= index]
append!(set_Values,value)
matrix_E = append!(matrix_E,Sens_matrix[:,index])
Sens_matrix = Sens_matrix[:, 1:end .!= index]

stop_criteria = 0.001
while size(Sens_matrix,2)!=0
   
    Sort = zeros(size(Sens_matrix,1),size(Sens_matrix,2))
    Spr = zeros(size(Sens_matrix,1),size(Sens_matrix,2))
    
    for h in 1:size(Sens_matrix,2)
        Spr[:,h]=sum((((Sens_matrix[:,h])'*matrix_E[:,i])/((matrix_E[:,i])'*matrix_E[:,i]))*matrix_E[:,i]  for i=1:num_of_param-size(Sens_matrix,2))
        Sort[:,h]=Sens_matrix[:,h]-Spr[:,h]
    end
 
    value, index = maxim(Sort)

    if (index == 0 || value<stop_criteria)
        break
    end
    append!(set_Index,index_parametes[index])
    index_parametes = index_parametes[1:end .!= index]
    append!(set_Values,value)

    matrix_E = hcat(matrix_E,Sens_matrix[:,index])
    Sens_matrix = Sens_matrix[:, 1:end .!= index]

end
=#


using LinearAlgebra

function maxim(S)
    max_value = 0
    max_index = 0 
    for j in 1:size(S,2)
        value = sum((S[i,j])^2 for i=1:size(S,1))
        if value>max_value
            max_value = value
            max_index = j
        end
    end

return (max_value, max_index)
end


#=
df_sa = DataFrame(parameter=df.TexSymbols[set_Index], log_val=log.(abs.(set_Values)))
print(sort!(df_sa, [:log_val, :parameter], rev = true))

using Plots, LaTeXStrings


bar(df_sa.parameter,df_sa.log_val,size = (1600,900),xticks=(1:30,df_sa.parameter),legend=false)


=#


end # module
