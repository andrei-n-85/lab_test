function [ret] = mode1_freqTable

permTable = [];
ret = [];
for i=1:2047
    
    if i==1
        permTable(i) = mod((13*0 + 511),2048);
    else
        permTable(i) = mod((13*permTable(i-1) + 511),2048);
    end
end

permTable(1024) = [];
d_n = [];
for i = 1:length(permTable)
    if ((permTable(i) >= 256) && (permTable(i) <= 1792))
        d_n = [d_n permTable(i)];
    end
end

freqTable = [];
for i=1:1536
    freqTable(i) = d_n(i)-1024;
end
  
for i = 1:1537
    p = i-769;
        ret = [ret find(freqTable==p)];
    end
end

