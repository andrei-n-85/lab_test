%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create_dab_frames.m                                                     %
%                                                                         %
% Requires: - FICinfo (struct)                                            %
%           - subch_vars (struct)                                         %
%           - channel_parameters(struct)                                  %
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
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function create_dab_frames(FICinfo, subch_vars, channel_parameters)

    % Adding all paths necessary 
    addpath additional_files
    addpath fic
    addpath msc
    addpath physical_layer

    % Create fixed variables for DAB signal generation
    fixed_vars = create_fixed_vars;
    
    % Create variables for DAB frame generation
    [fid, subch_vars max_runs] = create_dab_frames_init(subch_vars, FICinfo.no_log_frames, FICinfo.no_of_serv, fixed_vars);
    clear input
    
    % Set first frame to zero (no transmission) for channel
    first = zeros(192000,1);
    
    % Create transmission signal in a loop 
    %for loop = 1 : (max_runs+1)
    for loop = 1 
           
       tic

       % Creating MSC data
       [MSC subch_vars] = dab_create_msc(fixed_vars, FICinfo, subch_vars);

       
       % Creating the FIC                                                           
       FIC = dab_create_fic(fixed_vars, FICinfo, subch_vars);


       % Creating the transmission frame
      transmission_frame_raw = [FIC MSC];
      clear CIFs FIC   


       % Perform physical layer calculations
       TF = dab_physical_layer(transmission_frame_raw, fixed_vars.TFPR, fixed_vars.freq_perm, FICinfo.no_log_frames);

       
       % Apply artificial channel
       if isstruct(channel_parameters)
           [TF first] = channel(TF, channel_parameters, first);
       end
           
      
       % Save signal for transmission
       dab_save_transmission_frame(TF, fid)
       clear TF

       
       % Messages
       message = [num2str(loop) ' of ' num2str(max_runs) '. ' num2str(max_runs-loop) ' remaning'];       
       disp(message)
       disp('Creation time for 3.84s of music:')
       toc

    end
    
    fclose(fid);