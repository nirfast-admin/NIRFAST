function data=get_boundary_data_bem(elements,meas_int_func,phi)
k = 1;
nrow = size(meas_int_func,1);
for j = 1 : nrow
    vtx_ind = elements(meas_int_func(j,1),:);
    data(k) = meas_int_func(j,2:end)*phi(vtx_ind);
    k = k + 1;
end
  
  
