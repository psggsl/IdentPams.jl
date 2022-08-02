struct ODEs
    model::Function
    ID
    time
    step
    
  end
  
struct Sens_coeffs
    Sens_coeff
    Time_count
    num_of_param
    num_of_eq
end

function SensitiveCoefficient(ode::ODEs,pam; method=Tsit5()) 
    
    prob = ODELocalSensitivityProblem(ode.model,ode.ID,ode.time,pam)
    sol = solve(prob,method,saveat=val_Time)

    Solve_odes,Sens_coeff = extract_local_sensitivities(sol)
    Time_count = length(sol.t)
    num_of_param = length(pam)
    num_of_eq = length(ode.ID)
    return Sens_coeffs(Sens_coeff,Time_count,num_of_param,num_of_eq)
end


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
