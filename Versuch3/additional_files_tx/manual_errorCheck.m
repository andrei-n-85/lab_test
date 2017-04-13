%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% manual_create_inputs.m                                                  %
%                                                                         %
% Requires: all variables created by manual.m                             %
% Returns: no returns                                                     %
%                                                                         %
%-------------------------------------------------------------------------%
% This function performs an error check for the input variables that were %
% inserted by hand. It ensures that certain values do not occur twice and %
% that all values inserted are correct. In case of an error, an error     %
% message is displayed and further calculations aborted                   %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function manual_errorCheck(ensemble_ref_no, ensemble_label, ensemble_label_chars,...
                           number_of_services, audio_file, audio_bit_rate, channels, protection_level, service_ref_no, ... 
                           service_label, service_label_chars, subchannel_id)

    
    %% Check if sufficient values are present    
    if ~(size(audio_bit_rate,2) >= number_of_services)
            error('Too less numbers of Audio Bit Rate specified')
    end
    
    if ~(size(channels,2) >= number_of_services)
            error('Too less Audio Channels specified')
    end
    
    if ~(size(protection_level,2) >= number_of_services)
            error('Too less Protection Levels specified')
    end
    
    if ~(size(service_ref_no,2) >= number_of_services)
            error('Too less Service Reference Numbers specified')
    end
    
    if ~(size(service_label_chars,2) >= number_of_services)
            error('Too less chars to be displayed for Service Reference Numbers specified')
    end
    
    if ~(size(subchannel_id,2) >= number_of_services)
        error('Too less Sub-Channel IDs specified')
    end        
    
    if ~(numel(audio_file) >= number_of_services)
        error('Too less Audio Files specified')
    end
    
    if ~(numel(service_label) >= number_of_services)
        error('Too less Service Labels specified')
    end 

    

    %% Check if values are correct

    % Check ensemble reference number
    if ischar(ensemble_ref_no)
        error('Ensemble Reference Number has to be and integer number');
    end
    if ((ensemble_ref_no < 0) || (ensemble_ref_no > 4095))
        error('Ensemble Reference Number has to be between 0 and 4095');
    end

    % Check ensemble label chars
    if ischar(ensemble_label_chars)
        error('Number of shown characters of Ensemble Label has to be and integer number');
    end
    if ((ensemble_label_chars < 1) || (ensemble_label_chars > 16))
        error('Number of shown characters of Ensemble Label has to be between 1 and 16');
    end

    % Check ensemble label
    if ~ischar(ensemble_label)
        error('The Esemble Label may not be numbers only');
    else
        if length(ensemble_label) > 16
            error('Ensemble Label: Maximum 16 characters are allowed');
        end
    end

    % Check number of services
    if ischar(number_of_services)
        error('The number of services has to be and integer number');
    end
    if (number_of_services < 1) || (number_of_services > 9)
        error('The number of services has to be between 1 and 9');
    end 

    for i = 1 : number_of_services

        % Check service label
        if ~ischar(service_label(i).service_label)
            error(['Service Label ' num2str(i) ' may not be numbers only']);
        else
            if length(service_label(i).service_label) > 16
                error(['Service Label ' num2str(i) ': Maximum 16 characters are allowed']);
            end
        end

        % Check service reference number
        if ischar(service_ref_no)
            error(['Service Reference Number ' num2str(i) ' has to be and integer number']);
        end
        if (service_ref_no(i) < 0) || (service_ref_no(i) > 4095)
            error(['Service Reference Number ' num2str(i) ' has to be between 0 and 4095']);
        end      

        % Check service label chars
        if ischar(service_label_chars(i))
            error(['Number of shown characters of Service Label ' num2str(i) ' has to be and integer number']);
        end
        if ((service_label_chars(i) < 1) || (service_label_chars(i) > 16))
            error(['Number of shown characters of Service Label ' num2str(i) ' has to be between 1 and 16']);
        end

        % Check sub-channel ID
        if ischar(subchannel_id)
            error(['Sub-Channel ID ' num2str(i) ' has to be and integer number']);
        end
        if (subchannel_id(i) < 0) || (subchannel_id(i) > 63)
            error(['Sub-Channel ID ' num2str(i) ' has to be between 0 and 63']);
        end    

        % Check audio bit rate
        if ischar(audio_bit_rate)
            error(['Audio Bit Rate for Service ' num2str(i) ' has to be and integer number']);
        end
        if ~(audio_bit_rate(i) == 32 || audio_bit_rate(i) == 48 || audio_bit_rate(i) == 56 || audio_bit_rate(i) == 64 || audio_bit_rate(i) == 80 || audio_bit_rate(i) == 96 || audio_bit_rate(i) == 112 || audio_bit_rate(i) == 128 || audio_bit_rate(i) == 160 || audio_bit_rate(i) == 192 || audio_bit_rate(i) == 224 || audio_bit_rate(i) == 256 || audio_bit_rate(i) == 320 || audio_bit_rate(i) == 384)
            error(['Audio Bit Rate for Service ' num2str(i) ' has to have one of the following values: 32, 48, 56, 64, 80, 96, 112, 128, 160, 192 224, 256, 320, 384']);
        end 

        % Check audio channels
        if ischar(subchannel_id)
            error(['Sub-Channel ID ' num2str(i) ' has to be and integer number']);
        end
        if (channels(i) < 1) || (channels(i) > 2)
            error(['Value for Audio Channels ' num2str(i) ' has to be between 1 for mono or 2 for stereo']);
        end    

        % Check protection level
        if ischar(protection_level)
            error(['Protection Level ' num2str(i) ' has to be and integer number']);
        end
        if ~((protection_level(i) == 1) || (protection_level(i) == 2) || (protection_level(i) == 3) || (protection_level(i) == 4) || (protection_level(i) == 5))
            error(['Protection Level ' num2str(i) ' has to be an integer between 1 and 5']);
        end   

        % Check audio file
        if ~ischar(audio_file(i).audio_file)
            error(['Audio File ' num2str(i) ': Enter valid file with its path']);
        end
        if ~(exist(audio_file(i).audio_file, 'file'))
             error(['Audio File ' num2str(i) ': Audio file does not exist or folder is incorrect.']);
        end

    end
                       
                       
         
                       
    %% Check for double occurence of values

    % Check service labels with other service labels and ensemble label
    for i = 1 : number_of_services

        if strcmp(ensemble_label, service_label(i).service_label)
            error(['Ensemble Label and Service Label ' num2str(i) ' are identical.']);
        end

        for j = i+1 : number_of_services
            if strcmp(service_label(i).service_label, service_label(j).service_label)
                error(['Service Label ' num2str(i) ' and Service Label ' num2str(j) ' are identical.']);
            end
        end

    end

    % Check service reference number, ensemble reference number and subchannel number
    for i = 1 : number_of_services

        % Check Service Ref. No. with Service Ref. No.
        for j = i+1 : number_of_services
            if isequal(service_ref_no(i), service_ref_no(j))
                error(['Service Ref. Number ' num2str(i) '  and Service Ref. Number ' num2str(j) ' are identical.']);
            end
        end

        % Check Service Ref. No. with Sub-Channel ID
        for k = 1 : number_of_services
            if isequal(service_ref_no(i), subchannel_id(k))
                error(['Service Ref. Number ' num2str(i) '  and Sub-Channel ID ' num2str(k) ' are identical.']);
            end

            % Check Sub-Channel ID with Sub-Channel ID
            for l = k+1 : number_of_services
                if isequal(subchannel_id(k), subchannel_id(l))
                    error(['Sub-Channel ID ' num2str(k) '  and Sub-Channel ID ' num2str(l) ' are identical.']);
                end
            end

        end
    end
            


    %% Check combinations of inputs
    for i = 1 : number_of_services
        
        % Check combination of audio bit rate and protection level
        if ( (protection_level(i) == 1) && ((audio_bit_rate(i) == 56)||(audio_bit_rate(i) == 112)||(audio_bit_rate(i) == 320)) || ...
             (audio_bit_rate(i)==384) && ((protection_level(i) == 4)||(protection_level(i) == 2)) || ...
             (audio_bit_rate(i)==320) && (protection_level(i) == 3) )

            error(['The combination of audio bit rate (' num2str(audio_bit_rate(i)) ') and protection level (' num2str(protection_level(i)) 'kbps) for service ' num2str(i) ' is not allowed ']);
            
        end
        
        % Check combination of audio bit rate and number of audio channels
        if (channels(i) == 1)
            if ((audio_bit_rate(i) == 224) || (audio_bit_rate(i) == 256) || (audio_bit_rate(i) == 320) || (audio_bit_rate(i) == 384))
                error(['The combination of mono and audio bit rate (' num2str(audio_bit_rate(i)) 'kbps) for service ' num2str(i) ' is not allowed ']);
            end
        end
        
        if (channels(i) == 2)
            if ((audio_bit_rate(i) == 32) || (audio_bit_rate(i) == 48) || (audio_bit_rate(i) == 56) || (audio_bit_rate(i) == 80))
                 error(['The combination of stero and audio bit rate (' num2str(audio_bit_rate(i)) 'kbps) for service ' num2str(i) ' is not allowed ']);
            end
        end
        
     
        
    end

end