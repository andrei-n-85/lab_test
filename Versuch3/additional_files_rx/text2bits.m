function out  = text2bits(tx)

tx = [tx [repmat(' ',1,16-length(tx))] ];    % length 16;
tmp1 = unicode2native(tx);
tmp2 = dec2bin(tmp1,8);

tmp3 = tmp2';
out = str2num(tmp3(:))';