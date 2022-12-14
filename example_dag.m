clc
clear

DAG_load = 10+randi(80, 1, 5);
DAG_priority = [1, 2, 3, 4, 5];
DAG_period = 100;
DAG_deadline = 100;
DAG_id = 1;
DAG_communicationCost = zeros(5,5) - 1;
DAG_communicationCost(1, 2) = 2;
DAG_communicationCost(1, 3) = 4;
DAG_communicationCost(1, 4) = 3;
DAG_communicationCost(2, 5) = 2;
DAG_communicationCost(3, 5) = 3;
DAG_communicationCost(4, 5) = 1;

C_s_1 = 10;
Assign = {};
DAG_load_new = [];
for i = 1:size(DAG_load, 2)
    for j = 1:C_s_1
        if isequal(j, 1)
            DAG_load_new(i,j) = DAG_load(i);
        else
            DAG_load_new(i,j) = randi([(j-1)*100,j*100])/(j*100)*DAG_load_new(i,j-1);
        end
    end
end
DAG_load = DAG_load_new;
%%
for i = 1:size(DAG_load, 2)
    for j = 1:C_s_1
        resource = j;
        if eq(i,1)
            Assign{i}{j}{1} = [DAG_id, DAG_period, DAG_load(i,j), DAG_deadline, DAG_priority(i), resource];
        else
            newjob = [DAG_id, DAG_period, DAG_load(i,j), DAG_deadline, DAG_priority(i)];
            
            % 合的情况
            valueTemp = [];
            insertPositionTemp = [];
            virtualMachines = Assign{i-1}{j};
            if isempty(virtualMachines)
                valueMaxMerge = inf;
            else
                for k = 1:size(virtualMachines, 2)
                    [responseTimeNewJob, insertPosition] = responseTimeMergeFuc(virtualMachines, newjob, k);% 改
                    valueTemp = [valueTemp, responseTimeNewJob];
                    insertPositionTemp = [insertPositionTemp, insertPosition];
                end
                [valueMaxMerge, indexMerge] = min(valueTemp);
                indexPosition = insertPositionTemp(indexMerge);
            end
            
            % 分的情况
            valeMaxSep = inf;
            resourceAssigned = 0;
            for k = 1:resource-1
                value_Sep_Temp = DAG_load(i)/k;
                resource_left = resource - k;
                virtualMachines = Assign{i-1}{resource_left};
                if ~isempty(virtualMachines)
                    responseTimeNewJob = responseTimeSepFuc(virtualMachines, newjob, k);% 改
                    if responseTimeNewJob < valeMaxSep
                        valeMaxSep = responseTimeNewJob;
                        resourceAssigned = k;
                    end
                end
            end
            
            % 最终处理
            if min(valeMaxSep, valueMaxMerge) > DAG_deadline
                Assign{i}{j} = [];
            elseif valeMaxSep >= valueMaxMerge% 合的情况
                Assign{i}{j} = Assign{i-1}{j};
                job_VM = Assign{i}{j}{indexMerge};
                job_VM = [job_VM(1:indexPosition,:); newjob, job_VM(end,end); job_VM(indexPosition+1:end, :)];
                Assign{i}{j}{indexMerge} = job_VM;
                
            else% 分的情况
                Assign{i}{j} = Assign{i-1}{resource - resourceAssigned};
                size_vm = size(Assign{i}{j}, 2);
                job_VM = [newjob, resourceAssigned];
                Assign{i}{j}{size_vm+1} = job_VM;
            end
        end
    end
end
%%
Assign = {};
DAG2_load = 10+randi(50, 1, 10);
DAG2_priority = 1:1:10;
DAG2_period = 150;
DAG2_deadline = 150;
DAG2_id = 2;
DAG2_communicationCost = zeros(10,10) - 1;
DAG2_communicationCost(1, 2) = 2;
DAG2_communicationCost(1, 3) = 4;
DAG2_communicationCost(1, 4) = 3;
DAG2_communicationCost(1, 5) = 2;
DAG2_communicationCost(1, 6) = 2;
DAG2_communicationCost(2, 8) = 3;
DAG2_communicationCost(2, 9) = 1;
DAG2_communicationCost(3, 7) = 1;
DAG2_communicationCost(4, 8) = 1;
DAG2_communicationCost(4, 9) = 1;
DAG2_communicationCost(5, 9) = 1;
DAG2_communicationCost(6, 8) = 1;
DAG2_communicationCost(7, 10) = 1;
DAG2_communicationCost(8, 10) = 1;
DAG2_communicationCost(9, 10) = 1;
DAG2_lambda = 1.1;

for i = 1:size(DAG2_load, 2)
    for j = 1:C_s_1
        resource = j;
        newjob = [DAG2_id, DAG2_period, DAG2_load(i), DAG2_period, DAG2_priority(i)];
        
        % 合的情况       
        valueTemp = [];
        insertPositionTemp = [];
        virtualMachines = Assign{5+i-1}{j};
        if isempty(virtualMachines)
            valueMaxMerge = inf;
        else
            for k = 1:size(virtualMachines, 2)
                [responseTimeNewJob, insertPosition] = responseTimeMergeFuc(virtualMachines, newjob, k);% 改
                valueTemp = [valueTemp, responseTimeNewJob];
                insertPositionTemp = [insertPositionTemp, insertPosition];
            end
            [valueMaxMerge, indexMerge] = min(valueTemp);
            indexPosition = insertPositionTemp(indexMerge);
        end
        
        % 分的情况
        valeMaxSep = inf;
        resourceAssigned = 0;
        for k = 1:resource-1
            value_Sep_Temp = DAG2_load(i)/k;
            resource_left = resource - k;
            virtualMachines = Assign{5+i-1}{resource_left};
            if ~isempty(virtualMachines)
                responseTimeNewJob = responseTimeSepFuc(virtualMachines, newjob, k);% 改
                if responseTimeNewJob < valeMaxSep
                    valeMaxSep = responseTimeNewJob;
                    resourceAssigned = k;
                end
            end
        end
        
        % 最终处理
        if min(valeMaxSep, valueMaxMerge) > DAG2_deadline
            Assign{5+i}{j} = [];
        elseif  valeMaxSep >= valueMaxMerge% 合的情况
            Assign{5+i}{j} = Assign{5+i-1}{j};
            job_VM = Assign{5+i}{j}{indexMerge};
            job_VM = [job_VM; newjob, job_VM(end,end)];
            Assign{5+i}{j}{indexMerge} = job_VM;
            
            
            Assign{5+i}{j} = Assign{5+i-1}{j};
            job_VM = Assign{5+i}{j}{indexMerge};
            job_VM = [job_VM(1:indexPosition,:); newjob, job_VM(end,end); job_VM(indexPosition+1:end, :)];
            Assign{5+i}{j}{indexMerge} = job_VM;
            
        else% 分的情况
            Assign{5+i}{j} = Assign{5+i-1}{resource - resourceAssigned};
            size_vm = size(Assign{5+i}{j}, 2);
            job_VM = [newjob, resourceAssigned];
            Assign{5+i}{j}{size_vm+1} = job_VM;
        end
    end
end

