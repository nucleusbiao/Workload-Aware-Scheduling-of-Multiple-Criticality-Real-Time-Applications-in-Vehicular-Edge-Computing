function responseTime = responseTimeModelFuc(exec_priority_array, DAG_id)
% exec_priority_array = [exec_priority_array; exec_time_j, priority_j, vm_i];

responseTime = 0;
feasibleTime_vm = zeros(max(exec_priority_array(:,end)), 1);
if eq(DAG_id, 1)
    DAG_edge = zeros(5, 5);
    DAG_edge(1, 2) = 1;
    DAG_edge(1, 3) = 1;
    DAG_edge(1, 4) = 1;
    DAG_edge(2, 5) = 1;
    DAG_edge(3, 5) = 1;
    DAG_edge(4, 5) = 1;
    
    [temp, index] = sort(exec_priority_array(:,2), 'ascend');
    exec_priority_array = exec_priority_array(index, :);
    for i = 1:size(exec_priority_array, 1)
        vm_index = exec_priority_array(i, end);
        priority = exec_priority_array(i, end-1);
        finishTime_i = max(feasibleTime_vm(vm_index), max(DAG_edge(:,priority))) + exec_priority_array(i, 1);
        if eq(i, size(exec_priority_array, 1))
            DAG_edge(priority,end) =  finishTime_i;
        else
            DAG_edge(priority,:) = DAG_edge(priority,:)*finishTime_i;
        end
        feasibleTime_vm(vm_index) = finishTime_i;
    end    
    responseTime = max(max(DAG_edge));
    
elseif eq(DAG_id, 2)
    DAG_edge = zeros(10,10);
    DAG_edge(1, 2) = 1;
    DAG_edge(1, 3) = 1;
    DAG_edge(1, 4) = 1;
    DAG_edge(1, 5) = 1;
    DAG_edge(1, 6) = 1;
    DAG_edge(2, 8) = 1;
    DAG_edge(2, 9) = 1;
    DAG_edge(3, 7) = 1;
    DAG_edge(4, 8) = 1;
    DAG_edge(4, 9) = 1;
    DAG_edge(5, 9) = 1;
    DAG_edge(6, 8) = 1;
    DAG_edge(7, 10) = 1;
    DAG_edge(8, 10) = 1;
    DAG_edge(9, 10) = 1;
    
    [temp, index] = sort(exec_priority_array(:,2), 'ascend');
    exec_priority_array = exec_priority_array(index, :);
    for i = 1:size(exec_priority_array, 1)
        vm_index = exec_priority_array(i, end);
        priority = exec_priority_array(i, end-1);
        finishTime_i = max(feasibleTime_vm(vm_index), max(DAG_edge(:,priority))) + exec_priority_array(i, 1);
        if eq(i, size(exec_priority_array, 1))
            DAG_edge(priority,end) =  finishTime_i;
        else
            DAG_edge(priority,:) = DAG_edge(priority,:)*finishTime_i;
        end
        feasibleTime_vm(vm_index) = finishTime_i;
    end    
    responseTime = max(max(DAG_edge));
end