function pass_DAG_id = responseTimeCheckFuc(virtualMachinesOfi, DAG_id_check)

DAG_id = DAG_id_check;
exec_priority_array = [];
for i = 1:size(virtualMachinesOfi, 2)
    vm_i = virtualMachinesOfi{i};
    for j = 1:size(vm_i, 1)
        if eq(DAG_id, vm_i(j, 1))
            deadline = vm_i(j, 4);
            vm_update = updateVMfuc(vm_i, DAG_id, j);
            exec_time_j = executionTimeFuc(vm_update, DAG_id);
            priority_j = vm_i(j, end-1);
            exec_priority_array = [exec_priority_array; exec_time_j, priority_j, i];
        end
    end
end
responseTime = responseTimeModelFuc(exec_priority_array, DAG_id);

if responseTime < deadline
    pass_DAG_id = true;
else
    pass_DAG_id = false;
end