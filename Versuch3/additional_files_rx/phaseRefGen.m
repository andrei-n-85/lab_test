function zPRS  = phaseRefGen()

%global zPRS

h= [
	  0 2 0 0 0 0 1 1 2 0 0 0 2 2 1 1 0 2 0 0 0 0 1 1 2 0 0 0 2 2 1 1;
	  0 3 2 3 0 1 3 0 2 1 2 3 2 3 3 0 0 3 2 3 0 1 3 0 2 1 2 3 2 3 3 0;
	  0 0 0 2 0 2 1 3 2 2 0 2 2 0 1 3 0 0 0 2 0 2 1 3 2 2 0 2 2 0 1 3;
	  0 1 2 1 0 3 3 2 2 3 2 1 2 1 3 2 0 1 2 1 0 3 3 2 2 3 2 1 2 1 3 2
];

i = [ 0 1 2 3 0 1 2 3 0 1 2 3 0 1 2 3 0 1 2 3 0 1 2 3 0 3 2 1 0 3 2 1 0 3 2 1 ...
	    0 3 2 1 0 3 2 1 0 3 2 1 ];

n = [   1 2 0 1 3 2 2 3 2 1 2 3 ...
	    1 2 3 3 2 2 2 1 1 3 1 2 ...
	    3 1 1 1 2 2 1 0 2 2 3 3 ...
	    0 2 1 3 3 3 3 0 3 0 1 1 ];

    
kp = [-768 -736 -704 -672 -640 ...
-608 -576 -544 -512 -480 -448 ...
-416 -384 -352 -320 -288 -256 ...
-224 -192 -160 -128 -96  -64  -32 ...
 1 33 65 97 129 161 193 225 257 ...
289 321 353 385 417 449 481 513 ...
545 577 609 641 673 705 737];


    


ind  = 0;    
for k = -768:768
    if k<0
        kc = k;
    else
        kc = k-1;
    end
    if ~mod(kc,32)
        ind = ind+1;
    end
    ind2 = kp(ind);
    if k~=0
    phi(k+769,1) = pi/2*(h(i(ind)+1,k-ind2+1)+n(ind));
    end
end
    zPRS = exp(1i.*phi);
    zPRS(769) = [];
    
    
    %ift  = ifft((zPRS),2048);
    %ift = ifft([zeros(256,1); zPRS; zeros(256,1)]);
    %signals.ift  = [ift(end-503:end); ift];
