function [pattern] = PuncPatGen

PI16 = logical([1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0]);
PI16 = [PI16 PI16 PI16 PI16];
PI16 = repmat(PI16,1,21);

PI15 = [1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 0 0];
PI15 = logical([PI15 PI15 PI15 PI15]);
PI15 = [PI15 PI15 PI15];

VT = logical([1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0]);

temp = [find(PI16==1) 2688+find(PI15==1) 2688+384+find(VT==1)];

pattern = zeros(1,3096);
pattern(temp) = 1;