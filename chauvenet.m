function [filtered, removed, devs] = chauvenet(raw_data)
    % pull stats from data
    avg = mean(raw_data);
    stdev = std(raw_data);
    
    % compute chauvenet's critereon for the sample size
    % based on a natural log regression of a chauvenet's critereon table
    n = length(raw_data);
    a = 0.3625;
    b = 22.78;
    crit = a * log(b * n);
    clear a b
    
    % create blank arrays to be filled
    filtered = [];
    removed = [];
    devs = [];
    
    % run chauvenet's element-wise
    for x = raw_data
       x_dev = (x - avg) / stdev;
       devs = [devs x_dev];
       
       if x_dev > crit
           removed = [removed x];
       elseif x_dev < (-1*crit)
           removed = [removed x];
       else
           filtered = [filtered x]
       end
    end
end