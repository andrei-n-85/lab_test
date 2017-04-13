%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% frequency_permutation.m                                                 %
%                                                                         %
% Requires: - no requirements                                             %
% Returns:  - Vector with position permutation for frquency interleaving  %
%-------------------------------------------------------------------------%
% The unequal error protection (UEP) punctures the content of the         %
% convoluted matrix with its logical frames depending on the desired      %
% protection level and the audio bit rate                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function freq_table = frequency_permutation

    % A contains the general permutation of 2048 values, whereas freq_table contains all
    % values of A without elements smaller then 256, greater than 1024 or 1024
    j = 1;
    A = zeros(1,2048);
    
    for i=2 : 2048
        A(i) = mod(13*A(i-1)+511,2048);
        
        if ( (A(i) >= 256) && (A(i) <= 1792) && ~(A(i) == 1024) )
            freq_table(j) = A(i)-255;
            if freq_table(j) >= 769
                freq_table(j) = freq_table(j) -1;
            end
            j = j+1;     
        end
        
    end
    
    
end

