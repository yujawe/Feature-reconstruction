function waveletdec( c,s )
[H1,V1,D1] = detcoef2('all',c,s,1);
A1 = appcoef2(c,s,'haar',1);
V1img = wcodemat(V1,255,'mat',1);
H1img = wcodemat(H1,255,'mat',1);
D1img = wcodemat(D1,255,'mat',1);
A1img = wcodemat(A1,255,'mat',1);

subplot(2,2,1);
imagesc(A1img/256);
colormap pink(255);
title('Approximation Coef. of Level 1');

subplot(2,2,2);
imagesc(H1img/256);
title('Horizontal detail Coef. of Level 1');

subplot(2,2,3);
imagesc(V1img/256);
title('Vertical detail Coef. of Level 1');

subplot(2,2,4);
imagesc(D1img/256);
title('Diagonal detail Coef. of Level 1');

end

