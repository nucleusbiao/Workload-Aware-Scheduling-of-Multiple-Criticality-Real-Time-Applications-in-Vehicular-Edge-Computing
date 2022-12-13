function [responseTime, insertPosition] = responseTimeMergeFuc(virtualMachines, newjob, k)
% newjob = [DAG_id, DAG_period, DAG_load(i), DAG_period, DAG_priority(i)];

priorityMax = newjob(end);
DAG_id = newjob(1);
exec_priority_array = [];
for i = 1:size(virtualMachines, 2)
    vm_i = virtualMachines{i};
    if ~eq(i, k)
        for j = 1:size(vm_i, 1)
            if eq(DAG_id, vm_i(j, 1))
                vm_update = updateVMfuc(vm_i, DAG_id, j);
                exec_time_j = executionTimeFuc(vm_update, DAG_id);
                priority_j = vm_i(j, end-1);
                exec_priority_array = [exec_priority_array; exec_time_j, priority_j, i];
            end
        end
    end
end

vm_k = virtualMachines{k};
index = find(vm_k(:,1) == DAG_id);
if isempty(index)
    indexMax = 0;
else
    indexMax = max(index);
end
responseTime = inf;
insertPosition = -1;
for position_newjob = indexMax+1:1:size(vm_k,1)+1
    vm_k_temp = [vm_k(1:position_newjob-1,:); newjob, vm_k(end,end); vm_k(position_newjob:end,:)];
    pass_DAG = true;
    for i = 1:DAG_id-1
        DAG_id_check = i;
        virtualMachinesOfi = virtualMachines;
        virtualMachinesOfi{k} = vm_k_temp;
        pass_DAG_id = responseTimeCheckFuc(virtualMachinesOfi, DAG_id_check);
        pass_DAG = pass_DAG & pass_DAG_id;
    end

    if pass_DAG
        for j = 1:size(vm_k_temp, 1)
            if eq(DAG_id, vm_k_temp(j, 1))
                vm_update = updateVMfuc(vm_k_temp, DAG_id, j);
                exec_time_j = executionTimeFuc(vm_update, DAG_id);
                priority_j = vm_k_temp(j, end-1);
                exec_priority_array = [exec_priority_array; exec_time_j, priority_j, k];
            end
        end
        responseTimeTemp = responseTimeModelFuc(exec_priority_array, DAG_id);
        if responseTimeTemp < responseTime
            responseTime = responseTimeTemp;
            insertPosition = position_newjob-1;
        end
    end
end