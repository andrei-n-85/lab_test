%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% additional_file/TFPR_generation.m                                       %
%                                                                         %
% Requires: no requirements                                               %
%                                                                         %
% Returns: - TFPR (vector)                                                %
%                                                                         %
%-------------------------------------------------------------------------%
% This function creates the TFPR symbol according to the DAB Standard     %
% defined by the ETSI.                                                    %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function TFPR = TFPR_generation

    % Matrix K contains values k ,k', i, n and j
    K=zeros(5,1536);

    % First row are values of k = [-768 ; 768] \ {0}
    K(1,:) = [(-768:-1) (1:768)];

    % Vector with all values for n
    n_values = [1 2 0 1 3 2 2 3 2 1 2 3 1 2 3 3 2 2 2 1 1 3 1 2 3 1 1 1 2 2 1 0 2 2 3 3 0 2 1 3 3 3 3 0 3 0 1 1];

    % Second row is k', fourth row is n
    for a = 1 : 48    
        K(2,(a-1)*32+1:a*32) = K(1,(a-1)*32+1);
        K(4,(a-1)*32+1:a*32) = n_values(a);
    end

    first = [zeros(1,32) ones(1,32) ones(1,32)*2 ones(1,32)*3];
    second = [zeros(1,32) ones(1,32)*3 ones(1,32)*2 ones(1,32)];
    % Third row are values for index i
    K(3,1:768)=repmat(first,1,6);
    K(3,769:end)=repmat(second,1,6);

    % Fifth row contains values of j
    K(5,:) = K(1,:) - K(2,:);

    % Matrix H contains values for h(i,j) --> Table 48, DAB-Standard
    H = [ 0 2 0 0 0 0 1 1 2 0 0 0 2 2 1 1 0 2 0 0 0 0 1 1 2 0 0 0 2 2 1 1;
          0 3 2 3 0 1 3 0 2 1 2 3 2 3 3 0 0 3 2 3 0 1 3 0 2 1 2 3 2 3 3 0;
          0 0 0 2 0 2 1 3 2 2 0 2 2 0 1 3 0 0 0 2 0 2 1 3 2 2 0 2 2 0 1 3;
          0 1 2 1 0 3 3 2 2 3 2 1 2 1 3 2 0 1 2 1 0 3 3 2 2 3 2 1 2 1 3 2;];

    % Generate h(j) = h(i,k-k')
    for a = 1 : 1536
       h(a) = H( K(3,a)+1 , K(5,a)+1 ); 
    end

    % Generate term h(j) + n
    phi = (h + K(4,:));  


    % Generate TFPR-symbol (phase reference symbol)     
    % TFPR = exp(1i * pi / 2 * phi);  
    TFPR = zeros(1,1536);
    for i = 1 : 1536
        if mod(phi(i),4) == 0
            TFPR(i) = 1;
        end
        if mod(phi(i),4) == 1
            TFPR(i) = 1i;
        end
        if mod(phi(i),4) == 2
            TFPR(i) = -1;
        end
        if mod(phi(i),4) == 3
            TFPR(i) = -1i;
        end
    end

end