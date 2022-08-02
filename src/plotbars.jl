



df_sa = DataFrame(parameter=df.TexSymbols[set_Index], log_val=log.(abs.(set_Values)))
print(sort!(df_sa, [:log_val, :parameter], rev = true))


bar(df_sa.parameter,df_sa.log_val,size = (1600,900),xticks=(1:30,df_sa.parameter),legend=false)

