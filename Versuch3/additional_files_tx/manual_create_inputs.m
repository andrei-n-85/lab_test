%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% manual_create_inputs.m                                                  %
%                                                                         %
% Requires: all variables created by manual.m                             %
% Returns: - FICinfo (struct)                                             %
%          - subch_vars (struct)                                          %
%-------------------------------------------------------------------------%
% This function creates the structs FICinfo, which contains information   %
% about the FIC itself, and the structure subch_vars containing variable  %
% for all defined sub-channels.                                           %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [FICinfo, subch_vars] = manual_create_inputs(ensemble_ref_no, ensemble_label, ensemble_label_chars, number_LF_per_loop, ...
                                             number_of_services, audio_file, audio_bit_rate, channels, protection_level, ... 
                                             service_ref_no, service_label, service_label_chars, subchannel_id)
                                         
                                                   
    %% Create struct FICinfo
    FICinfo = struct;

    FICinfo.CIF_count = 0;

    FICinfo.no_log_frames = number_LF_per_loop;

    FICinfo.countryid = logical([1 1 0 1]);

    FICinfo.ensemble_label = dec2bin(double(ensemble_label),8)=='1';
    FICinfo.ensemble_label = FICinfo.ensemble_label'; 
    FICinfo.ensemble_label = (FICinfo.ensemble_label(:))';

    FICinfo.ensemble_label_chars = [true(1,ensemble_label_chars) zeros(1,16-ensemble_label_chars)];

    FICinfo.ensemble_ref_no = logical(de2bi(ensemble_ref_no,12, 'left-msb'));

    FICinfo.no_of_serv = number_of_services;


    %% Create struct subchvars
    subch_vars = struct;

    for i = 1 : number_of_services

        subch_vars(i).protlvl = protection_level(i);

        subch_vars(i).bitrate = audio_bit_rate(i);

        subch_vars(i).audio_ch = channels(i);

        subch_vars(i).sample_freq_48 = 1;

        subch_vars(i).subchid = logical(de2bi(subchannel_id(i),6,'left-msb'));

        subch_vars(i).service_label = dec2bin(double(service_label(i).service_label),8)=='1';
        subch_vars(i).service_label = subch_vars(i).service_label';
        subch_vars(i).service_label = (subch_vars(i).service_label(:))'; 

        subch_vars(i).service_label_chars = [true(1,service_label_chars(i)) false(1,16-service_label_chars(i))];

        subch_vars(i).service_ref = logical(de2bi(service_ref_no(i), 12, 'left-msb'));

        subch_vars(i).bits_for_LFs = FICinfo.no_log_frames * subch_vars(i).bitrate * 1000 * 0.024;

        subch_vars(i).path_file = audio_file(i).audio_file;

        subch_vars(i).first = 1;

    end

end
