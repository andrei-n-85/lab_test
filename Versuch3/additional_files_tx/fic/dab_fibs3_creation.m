%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIC/dab_fibs3_creation.m                                                %
%                                                                         %
% Requires: - subch_vars (struct)                                         %
%           - FICinfo (struct)                                            %
%                                                                         %
% Returns:  - FIBs3 (matrix)                                              %
%           - FICinfo (struct)                                            %
%-------------------------------------------------------------------------%
% This function creates the first three FIBs for the FIC in Transmission  %
% Mode 1. The FIGs are allocated the following:                           %
%  - FIB1: Contains FIG11 for service 6 and always FIG00                  %
%  - FIB2: Contains FIG11 for service 7 and FIG01 for service 9           %
%  - FIB3: Contains FIG11 for service 8 and FIG01                         %
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


function [FIBs3 FICinfo] = dab_fibs3_creation(FICinfo, subch_vars)

        
    %% Creation of first FIB
        % Configuration FIG type 0 extension 0
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
    
        
        
        % For 6 or more services present
        % Creation of FIG type 1 extension 1 for service 6
        if (FICinfo.no_of_serv == 6)
             
            FIG11(1,1:4) = FICinfo.countryid;                                       % country ID 
            FIG11(1,5:16) = subch_vars(6).service_ref;                              % service reference
            FIG11(1,17:144) = subch_vars(6).service_label;                          % service label 
            FIG11(1,145:160) = subch_vars(6).serv_label_chars;                      % showed chars 

            % FIG header: FIG type = 001, length = 10101 (21 Byte)
            FIG_type_1_header = [false false true    true false true false true];    
            % FIG0-0: Header, charset = 0000 OE = 0, extension type = 001 and FIG1-0 information  
            FIG_type_1_ext_1 = [FIG_type_1_header   false false false false    false    false false true   FIG11];
            
        else 
            FIG_type_1_ext_1 = [];
            
        end 
    
        FIB1 = [FIG_type_0_ext_0 FIG_type_1_ext_1 true(1,8) false(1,240-(size(FIG_type_0_ext_0,2)+size(FIG_type_1_ext_1,2)+8))];
        FIB1 = [FIB1 crcX25(FIB1)];
        clear FIG_type_0_ext_0 FIG_type_0_header FIG_type_1_ext_1 FIG_type_1_header FIG00
    
  
        
    
    %% Creation of second FIB
        % For at least 7 services present
        if (FICinfo.no_of_serv >= 7)

            % For 9 services present
            % Configuration of FIG type 0 extension 1 for service 9
            if (FICinfo.no_of_serv == 9)
                FIG01 = false(1,24);                                         % Pre-allocation
                FIG01(1,1:6) = subch_vars(9).subchid;                        % identify sub-channel
                FIG01(1,7:16) = subch_vars(9).start_addr_cu;                 % start address
                FIG01(1,17) = false;                                         % short (as stream audio)
                FIG01(1,18) = false;                                         % table 7 is used
                FIG01(1,19:24) = subch_vars(9).table7;                       % table 7 value derived by the DAB-frame creation at uep.m

                % FIG header: FIG type = 000
                length_FIG01 = dec2bin( (24+8)/8,5 )=='1';
                FIG_type_0_header = [false false false    length_FIG01];
                % FIG0-0: Header, C/N = 0, OE = 0, P/D = 0, extension type = 00001 and FIG0-1 information 
                FIG_type_0_ext_1 = [FIG_type_0_header  false   false   false   false false false false true   FIG01 ];
                
            else
                % For less than 9 services present
                FIG_type_0_ext_1 = [];
            end

            % For at least 7 services present
            % Configuration of FIG type 1 extension 1 for service 7
            FIG11(1,1:4) = FICinfo.countryid;                                       % country ID 
            FIG11(1,5:16) = subch_vars(7).service_ref;                              % service reference
            FIG11(1,17:144) = subch_vars(7).service_label;                          % service label 
            FIG11(1,145:160) = subch_vars(7).serv_label_chars;                      % showed chars 

            % FIG header: FIG type = 001, length = 10101 (21 Byte)
            FIG_type_1_header = [false false true    true false true false true];    
            % FIG0-0: Header, charset = 0000 OE = 0, extension type = 001 and FIG1-0 information  
            FIG_type_1_ext_1 = [FIG_type_1_header   false false false false    false    false false true   FIG11];
            

            FIB2 = [FIG_type_0_ext_1 FIG_type_1_ext_1 true(1,8) false(1,240-(size(FIG_type_0_ext_1,2)+size(FIG_type_1_ext_1,2)+8))];
            FIB2 = [FIB2 crcX25(FIB2)];
            clear FIG01 FIG11 FIG_type_0_header FIG_type_1_header FIG_type_0_ext_1 FIG_type_1_ext_1 length_FIG01
        else
            
            % For less than 7 services present
            FIB2 = dab_emptyFIB_creation;

        end
    
    
    %% Creation of third FIB
        % For at least 8 services present
        % Configuration of FIG type 1 extension 1 for service 8
        if (FICinfo.no_of_serv >= 8)

            FIG11(1,1:4) = FICinfo.countryid;                                       % country ID 
            FIG11(1,5:16) = subch_vars(8).service_ref;                              % service reference
            FIG11(1,17:144) = subch_vars(8).service_label;                          % service label 
            FIG11(1,145:160) = subch_vars(8).serv_label_chars;                      % showed chars 

            % FIG header: FIG type = 001, length = 10101 (21 Byte)
            FIG_type_1_header = [false false true    true false true false true];    
            % FIG0-0: Header, charset = 0000 OE = 0, extension type = 001 and FIG1-0 information  
            FIG_type_1_ext_1 = [FIG_type_1_header   false false false false    false    false false true   FIG11];

            FIB3 = [FIG_type_1_ext_1 true(1,8) false(1,240-(size(FIG_type_1_ext_1,2)+8))];
            FIB3 = [FIB3 crcX25(FIB3_content)];

        else

            FIB3 = dab_emptyFIB_creation;

        end
    
    
       
   %% Putting the three FIBs toghether
   FIBs3 = [FIB1; FIB2; FIB3];
   
   
end