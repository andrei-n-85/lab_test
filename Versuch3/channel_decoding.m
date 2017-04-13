% This function performs the channel decoding and energy dispersal
%
% Input 1: FIC_codebits - line-vector with 9216*n codebits of the fast information channel (FIC); 9216 codebits per DAB-Frame; n is the number of DAB-Frames
% Input 2: Constants
% Input 3: demapping method: 'hard' or 'soft'
% Output:  FIBs  - Matrix with 12*n rows and 256 columns; Each row contains one fast information block (FIB) with 256 information bits
%


function FIBs = channel_decoding(FIC_codebits,Constants,demapping_method)


if strcmp(demapping_method,'hard')
    
    n = length(FIC_codebits)/9216;  % --> Remove this line and implement here!
    FIBs = zeros(12*n,256);    % --> Remove this line and implement here!
    
    
elseif strcmp(demapping_method,'soft')

    n = length(FIC_codebits)/9216;  % --> Remove this line and implement here!
    FIBs = zeros(12*n,256);    % --> Remove this line and implement here!

else
    error('not valid demapping method!')
end