%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create_dab_frames_init.m                                                %
%                                                                         %
% Requires: - subch_vars (struct)                                         %
%           - no_log_frames (scalar)                                      %
%           - no_of_serv (scalar)                                         %
%           - fixed_vars (struct)                                         %
%                                                                         %
% Returns: - fid (scalar?)                                                %
%          - subch_vars (struct)                                          %
%          - max_runs (scalar)                                            %
%                                                                         %
%-------------------------------------------------------------------------%
% This function creates the remaining values for the sub-channels. The    %
% location of the file containing the transmission frames is stored in    %
% fid. The number of maximal runs of the main loop is denoted by max_runs.%
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ subch_vars max_runs] = create_dab_frames_init(subch_vars, no_log_frames, no_of_serv, fixed_vars)

    % First sub-channel starts at CU number 0
    length_cu = 0;

    % Select output file
    %fid = fopen('output2.bin','a');
    
    %Vector with all bitrates
    bitratevector  = [32 48 56 64 80 96 112 128 160 192 224 256 320 384];
    
    % Length of a logical frame for a bit rate(cols) and a protection level(rows)
    table = [ 2240  1856  1536  1344  1024;
              3328  2688  2240  1856  1536;
                 0  3328  2688  2240  1856;
              4480  3712  3072  2688  2048;
              5376  4480  3712  3328  2560;
              6656  5376  4480  3712  3072;
                 0  6656  5952  4480  3712;
              8960  7424  6144  5376  4096;
             10752  8960  7424  6656  5120;
             13312 10752  8960  7424  6144;
             14848 13312 10752  8960  7424;
             17920 14848 12288 10752  8192;
                 0 17920     0 13312 10240;
             26624     0 17920     0 12288; ];
    
    % Create some information for DAB frame creation
    for subch_no = 1 : no_of_serv
        
        % Size of input file in bits
        subch_vars(subch_no).file = dir(subch_vars(subch_no).path_file);
        subch_vars(subch_no).filesize = subch_vars(subch_no).file.bytes * 8;

        % Calculate number of bits per logical frame
        subch_vars(subch_no).bits_for_LF = subch_vars(subch_no).bitrate * 1000 * 0.024;
        
        % Get number of total logical frames
        subch_vars(subch_no).total_log_frames = floor(subch_vars(subch_no).filesize / subch_vars(subch_no).bits_for_LF);

        % Calculate number of loops that can be perfomed before corrections
        subch_vars(subch_no).runs = floor(subch_vars(subch_no).total_log_frames / no_log_frames);
        subch_vars(subch_no).runs_total = subch_vars(subch_no).runs;
        
        % maximal runs
        max_runs = subch_vars(subch_no).runs_total;
        
        % Open audio files
        subch_vars(subch_no).music = fopen(subch_vars(subch_no).path_file, 'r', 'ieee-be');

        % Preallocate input for time interleaving
        subch_vars(subch_no).conv_pre = false(table(find((bitratevector==subch_vars(subch_no).bitrate) == 1),subch_vars(subch_no).protlvl),15); %#ok<*FNDSB>
        
        % Obtain length of sub channel in number of CUs
        subch_vars(subch_no).length_cu = get_length_cu(subch_vars(subch_no).protlvl, subch_vars(subch_no).bitrate, fixed_vars.audio_bit_rates, fixed_vars.table7_length);

        % Set start address in number of CUs
        subch_vars(subch_no).start_addr_cu_dec = length_cu;
        subch_vars(subch_no).start_addr_cu = dec2bin(length_cu,10)=='1';
        length_cu = length_cu + subch_vars(subch_no).length_cu;      

    end
