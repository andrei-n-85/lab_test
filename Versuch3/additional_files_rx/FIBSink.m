%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Author: David May
%   Email: david.may@mytum.de
%   Date:   June 2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   FIB SINK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [chan_names FIBerrorRate] = FIBSink(FIBs)
CHconfig = struct;
%errorCalc.crcFICcorrect = 1;
num_errors = 0;
for fib = 1:size(FIBs,1)
    if crcX25_check(FIBs(fib,:))
        wFib = FIBs(fib,1:240);
        while ~isempty(wFib)
            type = bbi2dec((wFib(1:3)));
            length = bbi2dec((wFib(4:8)))*8;
            if (type==7 && length==248)
                break;
            end
            switch type
                case 0
                    %%CHconfig = type0(wFib(9:3+5+length),CHconfig);
                case 1
                    CHconfig = type1(wFib(9:3+5+length),CHconfig);
                case 2
                    disp(type)
                case 3
                    disp(type)
                case 4
                    disp(type)
                case 5
                    %%CHconfig = type5(wFib(9:3+5+length),CHconfig);
                case 6
                    disp(type)
                case 7
                    %disp(type)
                    %char(bin2decLib(wFib(9:3+5+length)))
                    
            end
            wFib(1:3+5+length) = [];
            
        end
    else
        %fprintf('FIB %d with errors\n',fib);
        num_errors = num_errors + 1;
        %errorCalc.crcFICcorrect = 0;
    end
end

FIBerrorRate = num_errors/size(FIBs,1);

disp('*************************************************************');
fprintf('%d CRC Errors (out of %d blocks)! Error Rate: %1.4f  \n',num_errors,size(FIBs,1),FIBerrorRate);
disp('*************************************************************');
disp('*************************************************************');
chan_names = displayFIC(CHconfig);
