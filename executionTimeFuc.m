function exec_time_i = executionTimeFuc(vm_update, DAG_id)
% newjob = [DAG_id, DAG_period, DAG_load(i), DAG_period, DAG_priority(i), resource];

resource = vm_update(1, end);
position = find(vm_update(:, 1) == DAG_id);
currentJob = vm_update(position,:);
job_ahead = vm_update(1:position-1, :);
job_lag = vm_update(position+1:end, :);
if isempty(job_lag)
    execMax = 0;
else
    execMax = max(job_lag(:,3)/job_lag(end,end));
end

if isempty(job_ahead)
    exec_time_i = execMax + currentJob(3)/resource;
else
    exec_time_currentJob = currentJob(3)/resource;
    reponseTime = exec_time_currentJob;
    while 1
        exec_time_ahead = exec_time_currentJob;
        for i = 1:size(job_ahead, 1)
            exec_time_ahead = exec_time_ahead + ceil(reponseTime/job_ahead(i,2))*job_ahead(i,3)/resource;
        end
        if abs(exec_time_ahead - reponseTime) > 1e-3
            reponseTime = exec_time_ahead;
        else
            exec_time_i = execMax + exec_time_ahead;
            break
        end
    end
end


