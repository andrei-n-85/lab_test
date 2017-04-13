%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% msc/dab_msc_tinterleave.m                                               %
%                                                                         %
% Requires: - conv_matrix (matrix)                                        %
%           - conv_pre (matrix)                                           %
%                                                                         %
% Returns:  - interleaved_matrix (matrix)                                 %
%           - conv_pre_next (matrix)                                      %
%                                                                         %
%-------------------------------------------------------------------------%
% This function performs time interleaving for the MSC.                   %
%                                                                         %
% INPUT:                                                                  %
% Inputs are the convoluted logical frames with one frame in each row and %
% a matrix that serves as 'pre part' in order to be able to perform time  %
% interleaving.                                                           %
%                                                                         %
% OUTPUT:                                                                 %
% The output is the time interleaved audio frame matrix with as many rows %
% as there are logical frames and the 'pre part' for the next time        %
% interleaving.                                                           %
%                                                                         %
% DESCRIPTION:                                                            %
% The input matrix is created and the output preallocated. With a         %
% slightly modified table, time interleaving can be performed. At % last, %
% the 'pre part' for the next time interleaving is created.               %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [interleaved_matrix, conv_pre_next] = dab_msc_tinterleave(conv_matrix, conv_pre)
    
    % Pre allocation of the interleaved matrix
    interleaved_matrix = false(size(conv_matrix,1),size(conv_matrix,2)); 
    
    
    % Creation of input matrix
    conv_matrix = [conv_pre conv_matrix];
    
    
    % Other table as depicted in the DAB standard, but with the following
    % calculation the output remains the same
    table_enc = [16 8 12 4 14 6 10 2 15 7 11 3 13 5 9 1];
    
    
    % Interleaving done here
    for h = 0 : size(conv_matrix,1)-1 
       interleaved_matrix(h+1,1:end) = conv_matrix(h+1,table_enc(mod(h,16)+1):size(interleaved_matrix,2)+table_enc(mod(h,16)+1)-1);   
    end

    
    % Create output for next interleaving
    conv_pre_next = conv_matrix(:,end-14:end);
    
    interleaved_matrix = interleaved_matrix.';
end
