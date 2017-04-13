function out = LLR_quantizer(input,bits)
number_of_levels = 2^bits;

out = floor(number_of_levels/2*tanh(-input/2))+number_of_levels/2;

out(out>=number_of_levels) = number_of_levels - 1;
out(out<0) = 0;