clc
clear
%%
sumValue = 0;
for xxxxxxx=1:100
Job_Period = 5*(1+randi(20, 1, 30));
Job_Load = randi(20, 1, 30)/10.*Job_Period;
Job_Deadline = randi(30, 1, 30)/10.*Job_Period;
Job_Lambda = (5+randi(10, 1, 30))/10;
C_s_1 = 20;

Job_Load_PerUnit = Job_Load./Job_Lambda;
Job_Util_PerUnit = Job_Load_PerUnit./Job_Period;
Job_UtilD_PerUnit = Job_Load_PerUnit./Job_Deadline;

%%
[Job_Util_PerUnit, Index] = sort(Job_Util_PerUnit, 'ascend');
Job_Period = Job_Period(Index);
Job_Load = Job_Load(Index);
Job_Lambda = Job_Lambda(Index);
Job_Load_PerUnit = Job_Load_PerUnit(Index);
Job_Deadline = Job_Deadline(Index);
Job_UtilD_PerUnit = Job_UtilD_PerUnit(Index);

%%
Assign = {};
value = {};
jobSingleValue = 1e2;
for i = 1:size(Job_Period, 2)
    for j = 1:C_s_1
        resource = j;
        if eq(i,1)
            if Job_Load_PerUnit(i)/resource < Job_Deadline(i)
                Assign{i}{j}{1} = [Job_Period(i), Job_Load_PerUnit(i), Job_Deadline(i), resource];
                value{i}{j} = jobSingleValue + Job_UtilD_PerUnit(i)/resource;
            else
                Assign{i}{j} = {};
                value{i}{j} = 0;
            end
        else
            if isempty(Assign{i-1}{j})
               if Job_Load_PerUnit(i)/resource < Job_Deadline(i)
                   Assign{i}{j}{1} = [Job_Period(i), Job_Load_PerUnit(i), Job_Deadline(i), resource];
                   value{i}{j} = jobSingleValue + Job_UtilD_PerUnit(i)/resource;
               else
                    Assign{i}{j} = {};
                    value{i}{j} = 0;
                end
            else
                newjob = [Job_Period(i), Job_Load_PerUnit(i), Job_Deadline(i)];
                % 合的情况
                valueTemp = [];
                for k = 1:size(Assign{i-1}{j}, 2)
                    job_VM = Assign{i-1}{j}{k};                    
                    scheduleFlag = responseTimeFuc(job_VM, newjob);
                    if scheduleFlag
                        valueTemp = [valueTemp; jobSingleValue + Job_UtilD_PerUnit(i)/job_VM(end,end)];
                    else
                        valueTemp = [valueTemp; 0];
                    end
                end  
                [valueMax, index] = max(valueTemp);
                valeMaxMerge = valueMax + value{i-1}{j};
                
                % 分的情况
                resourceAssigned = 0;
                value_Sep_max = 0;
                for k = 1:resource-1
                    if Job_Load_PerUnit(i)/k < Job_Deadline(i)
                        value_Sep_Temp = jobSingleValue + Job_UtilD_PerUnit(i)/k;
                        resource_left = resource - k;
                        if (value_Sep_Temp + value{i-1}{resource_left} > valeMaxMerge) & (value_Sep_Temp + value{i-1}{resource_left} > value_Sep_max)
                            value_Sep_max = value_Sep_Temp + value{i-1}{resource_left};
                            resourceAssigned = k;
                        end                            
                    end
                end
                
                % 最终处理
                if eq(resourceAssigned,0) & (valueMax > 1e-3) % 合的情况  
                    Assign{i}{j} = Assign{i-1}{j};
                    job_VM = Assign{i}{j}{index};    
                    job_VM = [job_VM; newjob, job_VM(end,end)];
                    Assign{i}{j}{index} = job_VM;    
                    value{i}{j} = valeMaxMerge;
                    
                elseif ~eq(resourceAssigned,0) % 分的情况
                    Assign{i}{j} = Assign{i-1}{resource - resourceAssigned};
                    size_vm = size(Assign{i}{j}, 2);
                    job_VM = [newjob, resourceAssigned];
                    Assign{i}{j}{size_vm+1} = job_VM;
                    value{i}{j} = value_Sep_max;
                    
                else % 合不进，分不了
                    Assign{i}{j} = Assign{i-1}{j};
                    value{i}{j} = value{i-1}{j};
                end
            end
        end
    end
end


for i = 1:size(value{size(Job_Period, 2)}, 2)
    sumValue = sumValue + value{size(Job_Period, 2)}{i};
end
end
sumValue
    