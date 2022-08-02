

function SensitiveMatrix(ode::ODEs,pam,H::Matrix{T}; method) where {T}
    sc::Sens_coeffs
    sc = SensitiveCoefficient(ode::ODEs,pam; method)

    num_add_con = size(H,1)
    Sens_matrix = zeros(sc.Time_count*num_add_con,sc.num_of_param)

    for index_time in 1:sc.Time_count
        start_ind = num_add_con*index_time-(num_add_con-1)
        finish_ind = num_add_con*index_time

        for index_pam in 1:sc.num_of_param
            Sens_matrix[start_ind:finish_ind,index_pam] = H*sc.Sens_coeff[index_pam][:,index_time]
        end
    
    end

    set_Index = []
    index_parametes = [i for i in 1:length(pam)]
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
            Spr[:,h]=sum((((Sens_matrix[:,h])'*matrix_E[:,i])/((matrix_E[:,i])'*matrix_E[:,i]))*matrix_E[:,i]  
                            for i=1:num_of_param-size(Sens_matrix,2))
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
end