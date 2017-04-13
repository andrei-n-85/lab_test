%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% msc/dab_msc_convolution.m                                               %
%                                                                         %
% Requires: - mother_matrix (matrix)                                      %
%           - bitrate (scalar)                                            %
%           - prot_lvl (scalar)                                           %
%           - fixed_vars (struct)                                         %
%                                                                         %
% Returns:  - convoluted_matrix (matrix)                                  %
%           - table_7_binary                                              %
%                                                                         %
%-------------------------------------------------------------------------%
% This function performs Unequal Error protection for the MSC             %
%                                                                         %
% INPUT: As input serves the convolutional encoded mother matrix with as  %
% many rows as there are logical frames, the audio bit rate in kbps, the  %
% protection level and a struct containing variables that are defined for %
% a DAB transmission, consisting of five tables with information to       %
% perform UEP, a puncturing vector matrix and  a puncturing vector for    %
% the tail bits                                                           %
%                                                                         %
% OUTPUT:                                                                 %
% Output is the punctured convolutional matrix and the binary value for   %
% table 7 of the DAB standard denoting error protection, sub-channel size %
% and the audio bitrate in kbps.                                          %
%                                                                         %
% DESCRIPTION:                                                            %
% First, the table containing information about the kind of puncturing    %
% vectors, their length and the number of padding bits is selected        %
% depending on the protection level chosen. By creating a binary vector   %
% with a '1' element at the audio bit rate position, the right row is     %
% selected and thus all information for the given audio bitrate. The next %
% step is to create the puncturing vector by repeating certain puncturing %
% vectors a certain time and appending the tail puncturing vector. At     %
% the end, puncturing is applied.                                         %
%                                                                         %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [convoluted_matrix table7_binary] = dab_uep(mother_matrix, bitrate, prot_lvl, fixed_vars)
    
    % For each protection level, a table is generated which entries depend on 
    % the audio bit rate. Thus, L and PI (from Table 36 p.158ff) are derived
    % Scheme:     table = [ L1 L2 L3 L4 PI1 PI2 PI3 PI4 padding] % bit rate
    switch prot_lvl
        case 1
            table = fixed_vars.table_protlvl_1;
        case 2
            table = fixed_vars.table_protlvl_2;
        case 3
            table = fixed_vars.table_protlvl_3;
        case 4
            table = fixed_vars.table_protlvl_4;
        case 5
            table = fixed_vars.table_protlvl_5;
    end
    
    % Get audio bit rates 
    bitrate_index = fixed_vars.audio_bit_rates==bitrate;

    blocknumbers = table(bitrate_index, 1:4);
    punct_vect_for_blocks = table(bitrate_index, 5:8);
    padding_bits = table(bitrate_index, 9);

    
    % create puncturing vector for the logical frames 
    frame_punc_vect = false(1,size(mother_matrix,2));
    k = 0;
    for h = 1 : 4
        for i=1 : blocknumbers(h)
            for j=1 : 4
                frame_punc_vect(1, k*32+1: (k+1)*32) = fixed_vars.punct_vectors(punct_vect_for_blocks(h),:);
                k=k+1;
            end
        end
    end

    
    % Add tail vector and convert vector representation to logical
    frame_punc_vect(1, (size(frame_punc_vect,2)-23) : size(frame_punc_vect,2)) = fixed_vars.punct_tail;
    frame_punc_vect = logical(frame_punc_vect);

    
    % Apply puncturing of the mother matrix by the block puncturing vector. The
    % length of the resulting matrix is the number of '1' in the puncturing
    % vector plus the number of padding bits
    convoluted_matrix = false(size(mother_matrix,1), length(find(frame_punc_vect)));
    for i=1 : size(mother_matrix,1)
        convoluted_matrix(i,:) = mother_matrix(i,frame_punc_vect);
    end
    convoluted_matrix = [convoluted_matrix false(size(convoluted_matrix,1),padding_bits)];
    

    % Create values table7
    table_7_vector = bitrate_index * fixed_vars.table_7;
    table_7 = table_7_vector(prot_lvl);
    table7_binary = dec2bin(table_7,6)=='1';

end
