function B = bbi2dec(A)

%B = sum(A.*2.^(0:numel(A)-1));
A  =single(A);
B = sum(A.*2.^(length(A)-1:-1:0));

