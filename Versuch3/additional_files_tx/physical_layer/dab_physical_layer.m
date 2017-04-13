%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /physical_layer/dab_physical_layer.m                                    %
%                                                                         %
% Requires: - transmission_frame_raw (matrix)                             %
%           - TFPR (vector)                                               %
%           - freq_perm (vector)                                          %
%           - no_log_frames (scalar)                                      %
%                                                                         %
% Returns:  - transmssion_frame (matrix)                                  %
%-------------------------------------------------------------------------%
% Physical layer calculations for DAB in transmission mode 1 is applied   %
% with this function. The inputs required are the TFPR symbol for         %
% transmission mode 1, the frequency permutation vector for transmission  %
% mode 1, the number of logical frames within the MSC and the             %
% transmission frame matrix containing the FIC and the MSC, which number  %
% of rows corresponds to the number of transmission frames with 230400    %
% elements in each row.                                                   %
%                                                                         %
% Here, frequency interleaving is performed before QPSK mapping, as it is %
% performed faster this way. For the common order of creating the DAB     %
% sigal according to the DAB standard, frequency interleaving has to be   %
% performed after mapping and the function transmission_frame_mapped and  %
% to be replaced by transmission_frame_mapped1.                           %
% After frequency interleaving and QPSK mapping, differential modulation  %
% is applied. As the IFFT is performed column-wise, the input matrix for  %
% the IFFT has to be transposed. Afterwards, the OFDM symbols are         %
% arranged column-wise, the cyclic prefix of the last 504 values is       %
% appended, and always 76 OFDM symbols are merged together in order to    %
% form the content of the transmission signal. The last step is the       %
% annexion of the NULL-symbol. Then, the transmission signal is created   %
%-------------------------------------------------------------------------%
% PHYSICAL LAYER CALCULATION FOR TRANSMISSION MODE 1 ONLY                 %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function transmission_frame = dab_physical_layer(transmission_frame_raw, TFPR, freq_perm, no_log_frames)


    %-------------------------------------------------------------------------%
    %     Interleaving first and mapping later is faster than vice versa      %
    %-------------------------------------------------------------------------%
    
    
    % Frequency Interleaving
    transmission_frame_interleaved = dab_freq_interleave(transmission_frame_raw, freq_perm);
    clear transmission_frame_raw;

    
    % Mapping
    transmission_frame_mapped = dab_qpsk_mapping(transmission_frame_interleaved);
    clear transmission_frame_interleaved;

    
    % Differential Modulation 
    transmission_frame_dqpsk = dab_diffmod(transmission_frame_mapped.', no_log_frames, TFPR);
    clear transmission_frame_mapped; 

    
    % Perform IFFT 
    length_IFFT = 2048;
    TF = ifft(ifftshift(transmission_frame_dqpsk.',1),length_IFFT);

    
    clear transmission_frame_dqpsk;
    
    
%---------------------------------------------------------------------------%
%        FROM HERE ON, TRANSMISSION FRAMES ARE STORE COLUMN WISE            %
%---------------------------------------------------------------------------%

    % Add cyclic prefix
    TF = [TF(1545:2048,:); TF]; % 504 last values of TF

        
    % Add NULL-Symbol
    % Reshape TF
    length_TF = 76 * 2552; % #OFDM-symbols * length of OFDM-symbols 
    TF = reshape(TF,length_TF,no_log_frames/4);
    
    % Create NULL symbol
    length_null_symbol = 2656; % Duration of NULL symbol for 2048 kHz rate
    null_matrix = zeros(length_null_symbol,no_log_frames/4);

    % Append NULL symbol to the beginning of TF 
    transmission_frame = [null_matrix; TF];
 

end