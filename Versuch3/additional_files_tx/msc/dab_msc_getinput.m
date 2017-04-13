%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% msc/dab_msc_getinput.m                                                  %
%                                                                         %
% Requires: - no_log_frames (scalar)                                      %
%           - subch_vars (struct)                                         %
%           - bits_for_LFs (scalar)                                       %
%           - subch_no (scalar)                                           %
%                                                                         %
% Returns:  - audio_frame_vector (vector)                                 %
%           - subch_vars (struct)                                         %
%-------------------------------------------------------------------------%
% This function loads a certain number of bits for the logical frames for %
% the MSC                                                                 %
%                                                                         %
% INPUT:                                                                  %
% Input is the number of logical frames, a struct (containing the number  %
% of runs (runs), the total number of logical frames (total_log_frames),  %
% the total number of runs (runs_total) and the location of the file      %
% toghether with its name (path_file)), the number of bits for one        %
% logical frame and the number of the actual peformed subchannel.         %
%                                                                         %
% OUTPUT:                                                                 %
% Output is a vector containaing all audio frames ( = logical frames) of  %
% the audio data and the parts of the information of the struct is        %
% updated.                                                                %
%                                                                         %
% DESCRIPTION:                                                            %
% Only one of the two parts of the code is performed. If there are enough %
% remaining logical frames, the first part is performed. In this part,    %
% further logical frames are read and the counter which indicates the     %
% number of times that this part has to be performed is decremented.      %
%                                                                         %
% If the counter is 0 (i.e. there are not enough logical frames remaining %
% in order to perform the chosen number of logical frames), the number of %
% bits for the remaining logical frames is calculated and the last        %
% logical frames are read. As yet no sequence of different audio files is %
% implemented, the same file is opended again, the counter and the        %
% pre-part matrix necessary for time interleaving is reset.               %
%                                                                         %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [audio_frame_vector subch_vars] = dab_msc_getinput(no_log_frames, subch_vars, bits_for_LFs, subch_no)


        % Read data and decrement counter
        if ~(subch_vars(subch_no).runs == 0)
            audio_frame_vector = fread(subch_vars(subch_no).music, bits_for_LFs, 'ubit1', 0,'ieee-be');
            subch_vars(subch_no).runs = subch_vars(subch_no).runs - 1;

            
        % Read last data part and re-open file --> endless loop
        else
            last_log_frames = subch_vars(subch_no).total_log_frames - subch_vars(subch_no).runs_total * no_log_frames;
            last_bits = last_log_frames * 0.024 * bitrate * 1000; % number of frames * frame duration * bitrate
            audio_frame_vector = fread(subch_vars(subch_no).music, last_bits, 'ubit1', 0,'ieee-be');
            audio_frame_vector = [audio_frame_vector; false(bits_for_LFs-size(audio_frame_vector,1),1)];
            subch_vars(subch_no).music = fopen(subch_vars(subch_no).path_file, 'r', 'ieee-be');
            subch_vars(subch_no).runs = floor(subch_vars(subch_no).total_log_frames / no_log_frames);
            subch_vars(subch_no).conv_pre = false(FICinfo.no_log_frames,15);
        end
        
end
