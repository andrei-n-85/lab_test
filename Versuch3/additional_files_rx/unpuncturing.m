function [motherCodeword] = unpuncturing(FIC)

part1 = single(zeros(1,21*128));
part2 = single(zeros(1,3*128));
part3 = single(zeros(1,24));


FIC = FIC*-2;
FIC  = FIC+1;

pPart1 = FIC(1:2016);
pPart2 = FIC(2017:2016+276);
pPart3 = FIC(2017+276:2016+276+12);

PI16 = logical([1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0]);
PI16 = [PI16 PI16 PI16 PI16];
PI16 = repmat(PI16,1,21);
part1(PI16) = pPart1;


PI15 = [1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 0 0];
PI15 = logical([PI15 PI15 PI15 PI15]);
PI15 = [PI15 PI15 PI15];
part2(PI15) = pPart2;


VT = logical([1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0]);
part3(VT) = pPart3;


motherCodeword = [part1 part2 part3];
motherCodeword = -motherCodeword; % -1:+1 => 0:2 Change sign to be consistent with used Viterbi-Decoder

test = zeros(1,3096);
ss = [find(PI16==1) 2688+find(PI15==1) 2688+384+find(VT==1)];
test(ss) = FIC;