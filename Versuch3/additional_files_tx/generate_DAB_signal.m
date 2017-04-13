function TF = generate_DAB_signal(frame_number)


    %% Information about ensemble

    % Ensemble reference number: number between 0 and 4095
    ensemble_ref_no = 4;

    % Ensemble Label: string with 16 letters
    ensemble_label = 'LNT             ';

    % Shown characters of Ensemble Label: number x denotes the first x
    % characters that will be shown at the receiver
    ensemble_label_chars = 16;

    % Number of Logical Frames to be performed each loop of frame creation: number 
    number_LF_per_loop = (frame_number+2)*4;

    % Number of services: number between 1 and 9
    number_of_services = 2;



    %% Information for services: vectors or structs which have to contain as many elements as there are services
    
    % Location of audio file with file itself: elements are strings
    audio_file(1).audio_file = 'additional_files_tx/kiev_48m192c.mp2';
    
    % Audio bit rate for services: elements are numbers with allowed audio bit rates
    audio_bit_rate(1) = 192; 
    
    % Number of audio channels: elements are numbers (1=mono or 2=stereo)
    channels(1) = 1;
        
    % Protection Level: elements are numbers between 1 and 5
    protection_level(1) = 1; 
    
    % Service Reference Number: elements are numbers between 0 and 4095
    service_ref_no(1) = 1;
    
    % Service Label: elements are stings with 16 letters
    service_label(1).service_label = 'Radio DLNT 1    ';
    
    % Shown characters of Service Label: the number x denotes the first x
    % characters that will be shown for the service label at the receiver
    service_label_chars(1) = 16;
    
    % Sub-Channel ID: elements are numbers from 0 to 63
    subchannel_id(1) = 3;
    
    
    %% Information for services: vectors or structs which have to contain as many elements as there are services
    
    % Location of audio file with file itself: elements are strings
    audio_file(2).audio_file = 'additional_files_tx/kiev_48m192c.mp2';
    
    % Audio bit rate for services: elements are numbers with allowed audio bit rates
    audio_bit_rate(2) = 192; 
    
    % Number of audio channels: elements are numbers (1=mono or 2=stereo)
    channels(2) = 1;
        
    % Protection Level: elements are numbers between 1 and 5
    protection_level(2) = 1; 
    
    % Service Reference Number: elements are numbers between 0 and 4095
    service_ref_no(2) = 2;
    
    % Service Label: elements are stings with 16 letters
    service_label(2).service_label = 'Radio DLNT 2    ';
    
    % Shown characters of Service Label: the number x denotes the first x
    % characters that will be shown for the service label at the receiver
    service_label_chars(2) = 16;
    
    % Sub-Channel ID: elements are numbers from 0 to 63
    subchannel_id(2) = 4;
    
     %% Check for errors and perform transmission
     manual_errorCheck(ensemble_ref_no, ensemble_label, ensemble_label_chars,...
                       number_of_services, audio_file, audio_bit_rate, channels, protection_level, service_ref_no, ... 
                       service_label, service_label_chars, subchannel_id);
                             
    % Create inputs for DAB transmission frames signal generation               
    [FICinfo, subch_vars] = manual_create_inputs(ensemble_ref_no, ensemble_label, ensemble_label_chars, number_LF_per_loop,...
                            number_of_services, audio_file, audio_bit_rate, channels, protection_level, service_ref_no, ... 
                            service_label, service_label_chars, subchannel_id);
                            
    % Create DAB frames signal             
    TF = create_dab_signal(FICinfo, subch_vars);
    
    TF = TF(:);
    
    disp([num2str(frame_number) ' DAB frames generated!']);