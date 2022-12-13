function responseTime = responseTimeSepFuc(virtualMachines, newjob, k)


virtualMachines_size = size(virtualMachines, 2);
new_virtualMachine = [newjob, k];
virtualMachines{virtualMachines_size + 1} = new_virtualMachine;

DAG_id = newjob(1);
exec_priority_array = [];
for i = 1:size(virtualMachines, 2)
    vm_i = virtualMachines{i};
    for j = 1:size(vm_i, 1)
        if eq(DAG_id, vm_i(j, 1))
            vm_update = updateVMfuc(vm_i, DAG_id, j);
            exec_time_j = executionTimeFuc(vm_update, DAG_id);
            priority_j = vm_i(j, end-1);
            exec_priority_array = [exec_priority_array; exec_time_j, priority_j, i];
        end
    end
end
responseTime = responseTimeModelFuc(exec_priority_array, DAG_id);