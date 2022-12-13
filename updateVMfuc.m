function vm_update = updateVMfuc(vm_i, DAG_id, j)

vm_update = [];
for i = 1:size(vm_i, 1)
    if ~eq(vm_i(i,1), DAG_id)
        vm_update = [vm_update; vm_i(i, :)];
    elseif eq(i, j) 
        vm_update = [vm_update; vm_i(i, :)];
    end
end