%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIC / dab_fibs4_creation.m                                              %
%                                                                         %
% Requires: - subch_vars (struct)                                         %
%           - FICinfo (struct)                                            %
%                                                                         %
% Returns:  - FIBs1 (matrix)                                              %
%           - FICinfo (struct)                                            %
%-------------------------------------------------------------------------%
% This function creates the first three FIBs for the FIC in Transmission  %
% Mode 1. The FIGs are allocated the following:                           %
%  - FIB1: Contains FIG11 for service 9 and always FIG00                  %
%  - FIB2: Contains FIG02 for service 1 2, 3, 4 and 5                     %
%  - FIB3: Contains FIG02 for service 6, 7, 8 and 9                       %
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


function [FIBs4 FICinfo] = dab_fibs4_creation(FICinfo, subch_vars)

    
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
    
        
        
        % For 9 services present
        % Creation of FIG type 1 extension 1 for service 9
        if (FICinfo.no_of_serv == 9)
             
            FIG11(1,1:4) = FICinfo.countryid;                                       % country ID 
            FIG11(1,5:16) = subch_vars(9).service_ref;                              % service reference
            FIG11(1,17:144) = subch_vars(9).service_label;                          % service label 
            FIG11(1,145:160) = subch_vars(9).serv_label_chars;                      % showed chars 

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
        % For up to 5 services present
        % Creation of FIG type 0 extension 2 for service 1 to max. service 5
        if (FICinfo.no_of_serv > 5)
            border = 5;
        else 
            border = FICinfo.no_of_serv;
        end

        FIG02 = false(1,border*40);
        for i = 1 : border
            FIG02(1+(i-1)*40:4+(i-1)*40) = FICinfo.countryid;                                   % country ID 
            FIG02(5+(i-1)*40:16+(i-1)*40) = subch_vars(i).service_ref;                          % service reference
            FIG02(17+(i-1)*40) = false;                                                         % available over partial ensemble
            FIG02(18+(i-1)*40:20+(i-1)*40) = false(1,3);                                        % no CA used
            FIG02(21+(i-1)*40:24+(i-1)*40) = [false false false true];                          % Number of SC in S
            FIG02(25+(i-1)*40:26+(i-1)*40) = false(1,2);                                        % 00 for MSC stream audio
            FIG02(27+(i-1)*40:32+(i-1)*40) = false(1,6);                                        % foreground sound
            FIG02(33+(i-1)*40:38+(i-1)*40) = subch_vars(i).subchid;                             % identify sub-channel
            FIG02(39+(i-1)*40) = true;                                                          % service component is primary (audio)
            FIG02(40+(i-1)*40) = false;  
        end

            length_FIG02 = dec2bin( (border*40+8) / 8,5 )=='1';
            FIG_type_0_header = [false false false     length_FIG02];

            % FIG0-0: Header, C/N = 0, OE = 0, P/D = 0, extension type = 00010 and FIG0-2 information 
            FIG_type_0_ext_2 = [FIG_type_0_header  false   false   false     false false false true false    FIG02];
            FIB2 = [FIG_type_0_ext_2 true(1,8) false(1,240-(8+size(FIG_type_0_ext_2,2)))];
            FIB2 = [FIB2 crcX25(FIB2)];
            clear FIG_type_0_ext_2 FIG02 FIG_type_0_header length_FIG02
        
        
   %% Creation of third FIB
        % For more than 5 services present
        % Creation of FIG type 0 extension 2 for service 5 to max. service 9
        
       if (FICinfo.no_of_serv > 5)
           FIG03 = false(1,(FICinfo.no_of_serv-5)*40);

            for i = 1 : FICinfo.no_of_serv-5
                FIG03(1+(i-1)*40:4+(i-1)*40) = FICinfo.countryid;                                   % country ID 
                FIG03(5+(i-1)*40:16+(i-1)*40) = subch_vars(i).service_ref;                          % service reference
                FIG03(17+(i-1)*40) = false;                                                         % available over partial ensemble
                FIG03(18+(i-1)*40:20+(i-1)*40) = false(1,3);                                        % no CA used
                FIG03(21+(i-1)*40:24+(i-1)*40) = [false false false true];                          % Number of SC in S
                FIG03(25+(i-1)*40:26+(i-1)*40) = false(1,2);                                        % 00 for MSC stream audio
                FIG03(27+(i-1)*40:32+(i-1)*40) = false(1,6);                                        % foreground sound
                FIG03(33+(i-1)*40:38+(i-1)*40) = subch_vars(i).subchid;                             % identify sub-channel
                FIG03(39+(i-1)*40) = true;                                                          % service component is primary (audio)
                FIG03(40+(i-1)*40) = false;  
            end

            length_FIG03 = dec2bin( ((FICinfo.no_of_serv-5)*40+8) / 8,5 )=='1';
            FIG_type_0_header = [false false false     length_FIG03];

            % FIG0-0: Header, C/N = 0, OE = 0, P/D = 0, extension type = 00010 and FIG0-2 information 
            FIB3 = [FIG_type_0_header  false   false   false     false false false true false    FIG03];
            FIB3 = [FIB3 true(1,8) false(1,240-8-size(FIB3,2))];
            FIB3 = [FIB3 crcX25(FIB3)];

       else
           FIB3 = dab_emptyFIB_creation;
       end

%% Putting the three FIBs toghether
   FIBs4 = [FIB1; FIB2; FIB3];