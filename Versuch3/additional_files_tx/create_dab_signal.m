%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create_dab_signal.m                                                     %
%                                                                         %
% Requires: - FICinfo (struct)                                            %
%           - subch_vars (struct)                                         %
%                                                                         %
% Returns: no returns, transmission frames are stored in an external file %
%                                                                         %
%-------------------------------------------------------------------------%
% This is the main function to create a DAB signal. First, some values are%
% gathered that are necessary. In a loop, the MSC and the FIC are created %
% and the transmission frame created. Physical calculations are applied   %
% to the transmission frames (and if selected a channel simulation is     %
% performed) and the signal is stored in an external file.                %
%-------------------------------------------------------------------------%
% Edited version of CRISTOPHER TSCHISCHKA's code                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function TF = create_dab_signal(FICinfo, subch_vars)

% Adding all paths necessary
addpath additional_files
addpath fic
addpath msc
addpath physical_layer

testmode_all_zeros = 0;


% Create fixed variables for DAB signal generation
fixed_vars = create_fixed_vars;

% Create variables for DAB frame generation
[subch_vars max_runs] = create_dab_frames_init(subch_vars, FICinfo.no_log_frames, FICinfo.no_of_serv, fixed_vars);

clear input

% Set first frame to zero (no transmission) for channel
first = zeros(192000,1);

% Creating MSC data
[MSC subch_vars] = dab_create_msc(fixed_vars, FICinfo, subch_vars);


% Creating the FIC
FIC = dab_create_fic(fixed_vars, FICinfo, subch_vars);


% Creating the transmission frame
transmission_frame_raw = [FIC MSC];
if testmode_all_zeros == 1
   transmission_frame_raw = zeros(size(transmission_frame_raw));
end

clear CIFs FIC


% Perform physical layer calculations
TF = dab_physical_layer(transmission_frame_raw, fixed_vars.TFPR, fixed_vars.freq_perm, FICinfo.no_log_frames);




