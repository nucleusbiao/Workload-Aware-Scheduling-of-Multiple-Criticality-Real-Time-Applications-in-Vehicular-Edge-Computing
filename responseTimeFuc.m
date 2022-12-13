function responseTimeNewJob = responseTimeFuc(job_VM, newjob)
% job_VM = [Job_Period(i), Job_Load_PerUnit(i), Job_Deadline(i), resource];
resource = job_VM(end, end);
job_VM = [job_VM; newjob, resource];


priority_last = job_VM(end, end-1);

[rows,cols,vals] = find(job_VM(:,end-1) == priority_last);

job_VM_options = {};
for i = 1:size(rows, 1)
    job_last = job_VM(rows(i), :);
    job_VM_options{i} = [job_VM(1:rows(i)-1, :); job_VM(rows(i)+1:end, :); job_last];
end

responseTimeNewJobArray = [];
for j = 1:size(rows, 1)    
    job_VM = job_VM_options{j};
    responseTimeNewJob = job_VM(end,2)/resource;
    for i = 1:size(job_VM, 1)-1
        responseTimeNewJob = responseTimeNewJob + ceil(responseTimeNewJob/job_VM(i,1))*job_VM(i,2)/resource;
    end
    responseTimeNewJobArray = [responseTimeNewJobArray, responseTimeNewJob];
end
responseTimeNewJob = min(responseTimeNewJobArray);