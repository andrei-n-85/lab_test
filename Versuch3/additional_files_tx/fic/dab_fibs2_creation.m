%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIC/dab_fibs2_creation.m                                                %
%                                                                         %
% Requires: - subch_vars (struct)                                         %
%           - FICinfo (struct)                                            %
%                                                                         %
% Returns:  - FIBs2 (matrix)                                              %
%           - FICinfo (struct)                                            %
%-------------------------------------------------------------------------%
% This function creates the first three FIBs for the FIC in Transmission  %
% Mode 1. The FIGs are allocated the following:                           %
%  - FIB1: Contains FIG11 for service 3 and always FIG00                  %
%  - FIB2: Contains FIG11 for service 4 and FIG01 for service 5 and 6     %
%  - FIB3: Contains FIG11 for service 5 and FIG01 for service 7 and 8     %
%                                                                         %
% FIGs are only present if necessary. If FIB is empty, an empty FIB is    %
% created.                                                                %
%                                                                         %
% The variable FICinfo is returned in order to update the CIF counter     %
%-------------------------------------------------------------------------%
% FIB CREATION FOR TRANSMISSION MODE 1 ONLY                               %
%-------------------------------------------------------------------------%
% MASTER THESIS: CHRISTOPHER TSCHISCHKA                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [FIBs2 FICinfo] = dab_fibs2_creation(FICinfo, subch_vars)

    
    %% Creation of first FIB
        % Creation FIG type 0 extension 0
        FIG00 = false(1,32);                                                       % Preallocation
        FIG00(1,1:4) = FICinfo.countryid;                                          % country ID
        FIG00(1,5:16) = FICinfo.ensemble_ref_no;                                   % ensemble reference
        FIG00(1,17:18) = [false false];                                            % change flag
        FIG00(1,19) = false;                                                       % AI

        % Update lowercounter and uppercounter
        lowercounter = mod(FICinfo.CIF_count,250);                                 % values 0 - 249
        uppercounter = floor((FICinfo.CIF_count - lowercounter)/250);              % values 0 - 20

        % store lowercounter and uppercounter in their positions
        FIG00(1,20:24) = dec2bin(uppercounter,5)=='1';
        FIG00(1,25:32) = dec2bin(lowercounter,8)=='1';

        % Increment counter (maximum: 250 * 20 = 5000)
        FICinfo.CIF_count = FICinfo.CIF_count + 1;
        FICinfo.CIF_count = mod(FICinfo.CIF_count,5000);

        % FIG header: FIG type = 000, length = 00101 (5 Byte)
        FIG_type_0_header = [false false false    false false true false true];    
        % FIG0-0: Header, C/N = 0, OE = 0, P/D = 0, extension type = 00000 and FIG0-0 information 
        FIG_type_0_ext_0 = [FIG_type_0_header   false    false    false    false false false false false   FIG00];
        clear FIG00 FIG_type_0_header uppercounter lowercounter


        % For at least 3 services present
        % Creation of FIG type 1 extension 1 for service 3
        if (FICinfo.no_of_serv >= 3)
        
            FIG11(1,1:4) = FICinfo.countryid;                                       % country ID 
            FIG11(1,5:16) = subch_vars(3).service_ref;                              % service reference
            FIG11(1,17:144) = subch_vars(3).service_label;                          % service label 
            FIG11(1,145:160) = subch_vars(3).serv_label_chars;                      % showed chars 

            % FIG header: FIG type = 001, length = 10101 (21 Byte)
            FIG_type_1_header = [false false true    true false true false true];    
            % FIG0-0: Header, charset = 0000 OE = 0, extension type = 001 and FIG1-0 information  
            FIG_type_1_ext_1 = [FIG_type_1_header   false false false false    false    false false true   FIG11];

            clear FIG11 FIG_type_1_header

        else
            
            FIG_type_1_ext_1 = [];
        end
        
        
        % Creating first FIB
        FIB1 = [FIG_type_0_ext_0   FIG_type_1_ext_1   true(1,8)   false(1,240 - ( size(FIG_type_0_ext_0,2) + size(FIG_type_1_ext_1,2) + 8))];
        FIB1 = [FIB1 crcX25(FIB1)];
        clear FIG_type_0_ext_0 FIG_type_1_ext_1;
    
    

    

    
    
        
    %% Creation of second FIB
        % For at least 4 services present
        % Creation of FIG type 1 extension 1 for service 4
            if (FICinfo.no_of_serv >= 4)

                FIG11(1,1:4) = FICinfo.countryid;                                       % country ID 
                FIG11(1,5:16) = subch_vars(4).service_ref;                              % service reference
                FIG11(1,17:144) = subch_vars(4).service_label;                          % service label 
                FIG11(1,145:160) = subch_vars(4).serv_label_chars;                      % showed chars 

                % FIG header: FIG type = 001, length = 10101 (21 Byte)
                FIG_type_1_header = [false false true    true false true false true];    
                % FIG0-0: Header, charset = 0000 OE = 0, extension type = 001 and FIG1-0 information  
                FIG_type_1_ext_1 = [FIG_type_1_header   false false false false    false    false false true   FIG11];

                clear FIG11 FIG_type_1_header
            else
                FIG_type_1_ext_1 = [];
            end   

        
        
        % For at least 5 services present
        % Creation of FIG type 0 extension 1 for service 5
            if (FICinfo.no_of_serv == 5)

                % For 5 services present
                % Create one FIG 0 extension 1
                if (FICinfo.no_of_serv == 5)
                    FIG01 = false(1,24);                                         % Pre-allocation
                    FIG01(1,1:6) = subch_vars(5).subchid;                        % identify sub-channel
                    FIG01(1,7:16) = subch_vars(5).start_addr_cu;                 % start address
                    FIG01(1,17) = false;                                         % short (as stream audio)
                    FIG01(1,18) = false;                                         % table 7 is used
                    FIG01(1,19:24) = subch_vars(5).table7;                       % table 7 value derived by the DAB-frame creation at uep.m

                    % FIG header: FIG type = 000
                    length_FIG01 = dec2bin( (24+8)/8,5 )=='1';
                    FIG_type_0_header = [false false false    length_FIG01];
                    % FIG0-0: Header, C/N = 0, OE = 0, P/D = 0, extension type = 00001 and FIG0-1 information 
                    FIG_type_0_ext_1 = [FIG_type_0_header  false   false   false   false false false false true   FIG01 ];

                % For 6 or more services present
                % Create two FIGs 0 extension 1 for service 5 and 6
                else
                    FIG01 = false(1,48);                                         % Pre-allocation
                    FIG01(1,1:6) = subch_vars(5).subchid;                        % identify sub-channel
                    FIG01(1,7:16) = subch_vars(5).start_addr_cu;                 % start address
                    FIG01(1,17) = false;                                         % short (as stream audio)
                    FIG01(1,18) = false;                                         % table 7 is used
                    FIG01(1,19:24) = subch_vars(5).table7;                       % table 7 value derived by the DAB-frame creation at uep.m
                    FIG01(1,25:30) = subch_vars(6).subchid;                      % identify sub-channel
                    FIG01(1,31:40) = subch_vars(6).start_addr_cu;                % start address
                    FIG01(1,41) = false;                                         % short (as stream audio)
                    FIG01(1,42) = false;                                         % table 7 is used
                    FIG01(1,43:48) = subch_vars(6).table7;                       % table 7 value derived by the DAB-frame creation at uep.m

                    % FIG header: FIG type = 000
                    length_FIG01 = dec2bin( (2*24+8)/8,5 )=='1';
                    FIG_type_0_header = [false false false    length_FIG01];
                    % FIG0-0: Header, C/N = 0, OE = 0, P/D = 0, extension type = 00001 and FIG0-1 information 
                    FIG_type_0_ext_1 = [FIG_type_0_header  false   false   false   false false false false true   FIG01 ];
                end

                clear FIG01 length_FIG01 FIG_type_0_header
            % For less than 3 services present
            else   
                FIG_type_0_ext_1 = [];
            end
        
             
        
        % FIB creation
            % Create empty FIB for less than 4 services
            if (FICinfo.no_of_serv < 4)
                FIB2 = dab_emptyFIB_creation;

            % Create FIB for 4 or more services
            else
                FIB2_content = [FIG_type_1_ext_1 FIG_type_0_ext_1];

                % Set endmarker and padding bits if necessary
                if (size(FIB2_content,2) == 240)
                    FIB2 = FIB2_content;
                elseif (size(FIB2_content,2) == 232)
                    FIB2 = [FIB2_content true(1,8)];
                else
                    FIB2 = [FIB2_content true(1,8) false(1,240-(size(FIB2_content,2)+8))];
                end

                FIB2 = [FIB2 crcX25(FIB2)];

                clear FIB2_content FIG_type_1_ext_1 FIG_type_0_ext_1
            end
        
    
    
            
            
            
            
            
    
    

    %% Creation of third FIB
        % For 5 or more services present
        % Creation of FIG type 1 extension 1 for service 5
            if (FICinfo.no_of_serv >= 5)

                FIG11(1,1:4) = FICinfo.countryid;                                       % country ID 
                FIG11(1,5:16) = subch_vars(5).service_ref;                              % service reference
                FIG11(1,17:144) = subch_vars(5).service_label;                          % service label 
                FIG11(1,145:160) = subch_vars(5).serv_label_chars;                      % showed chars 

                % FIG header: FIG type = 001, length = 10101 (21 Byte)
                FIG_type_1_header = [false false true    true false true false true];    
                % FIG0-0: Header, charset = 0000 OE = 0, extension type = 001 and FIG1-0 information  
                FIG_type_1_ext_1 = [FIG_type_1_header   false false false false    false    false false true   FIG11];
            
                clear FIG11 FIG_type_1_header
                
            % For 4 or less services present
            else
                FIG_type_1_ext_1 = [];
            end   

        
        
        % Creation of FIG type 0 extension 1 for 7 or more services present
            if (FICinfo.no_of_serv >= 7)

                % For 7 services present
                % Create one FIG 0 extension 1 for service 7
                if (FICinfo.no_of_serv == 7)
                    FIG01 = false(1,24);                                         % Pre-allocation
                    FIG01(1,1:6) = subch_vars(7).subchid;                        % identify sub-channel
                    FIG01(1,7:16) = subch_vars(7).start_addr_cu;                 % start address
                    FIG01(1,17) = false;                                         % short (as stream audio)
                    FIG01(1,18) = false;                                         % table 7 is used
                    FIG01(1,19:24) = subch_vars(7).table7;                       % table 7 value derived by the DAB-frame creation at uep.m

                    % FIG header: FIG type = 000
                    length_FIG01 = dec2bin( (24+8)/8,5 )=='1';
                    FIG_type_0_header = [false false false    length_FIG01];
                    % FIG0-0: Header, C/N = 0, OE = 0, P/D = 0, extension type = 00001 and FIG0-1 information 
                    FIG_type_0_ext_1 = [FIG_type_0_header  false   false   false   false false false false true   FIG01 ];

                % For 8 or more services present
                % Create two FIGs 0 extension 1 for service 7 and 8
                else
                    FIG01 = false(1,48);                                         % Pre-allocation
                    FIG01(1,1:6) = subch_vars(7).subchid;                        % identify sub-channel
                    FIG01(1,7:16) = subch_vars(7).start_addr_cu;                 % start address
                    FIG01(1,17) = false;                                         % short (as stream audio)
                    FIG01(1,18) = false;                                         % table 7 is used
                    FIG01(1,19:24) = subch_vars(7).table7;                       % table 7 value derived by the DAB-frame creation at uep.m
                    FIG01(1,25:30) = subch_vars(8).subchid;                      % identify sub-channel
                    FIG01(1,31:40) = subch_vars(8).start_addr_cu;                % start address
                    FIG01(1,41) = false;                                         % short (as stream audio)
                    FIG01(1,42) = false;                                         % table 7 is used
                    FIG01(1,43:48) = subch_vars(8).table7;                       % table 7 value derived by the DAB-frame creation at uep.m

                    % FIG header: FIG type = 000
                    length_FIG01 = dec2bin( (2*24+8)/8,5 )=='1';
                    FIG_type_0_header = [false false false    length_FIG01];
                    % FIG0-0: Header, C/N = 0, OE = 0, P/D = 0, extension type = 00001 and FIG0-1 information 
                    FIG_type_0_ext_1 = [FIG_type_0_header  false   false   false   false false false false true   FIG01 ];
                end

                clear FIG01 length_FIG01 FIG_type_0_header
                
            % For less than 7 services present
            else   
                FIG_type_0_ext_1 = [];
            end
        
             
        
        % FIB creation
            % Create empty FIB for less than 5 services
            if (FICinfo.no_of_serv < 5)
                FIB3 = dab_emptyFIB_creation;

            % Create FIB for 5 or more services
            else
                FIB3_content = [FIG_type_1_ext_1 FIG_type_0_ext_1];

                % Set endmarker and padding bits if necessary
                if (size(FIB3_content,2) == 240)
                    FIB3 = FIB3_content;
                elseif (size(FIB3_content,2) == 232)
                    FIB3 = [FIB3_content true(1,8)];
                else
                    FIB3 = [FIB3_content true(1,8) false(1,240-(size(FIB3_content,2)+8))];
                end

                FIB3 = [FIB3 crcX25(FIB3)];

                clear FIB3_content FIG_type_1_ext_1 FIG_type_0_ext_1
            end
            
            
            
    %% Putting the three FIBs toghether
    FIBs2 = [FIB1; FIB2; FIB3];

    
end