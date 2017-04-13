function PRSN  = PrsnFicGenerator()  

    PRSN = zeros(1,768);
    sh = ones(1,9);
    for i = 1:768
        PRSN(i) = xor(sh(5),sh(9));
        sh = circshift(sh,[0 1]);
        sh(1) = PRSN(i);
    end