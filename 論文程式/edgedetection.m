
img=imread('8989.jpg');
img=rgb2gray(img);
L = medfilt2(img,[3 3]);
[A,H,V,D]=dwt2(L,'sym2');
A1=zeros(size(A));
k=0.3;
Q1 = idwt2(A1,k*H,k*V,k*D,'sym2');

wname = 'bior3.9';
level = 5;
[C,S] = wavedec2(Q1,level,wname);
thr = wthrmngr('dw2ddenoLVL','penalhi',C,S,3);
sorh = 's';
[XDEN,cfsDEN,dimCFS] = wdencmp('lvd',C,S,wname,level,thr,sorh);
figure;
subplot(1,2,1);img
imshow(Q1); colormap gray; axis off;
title('Noisy Image');
subplot(1,2,2);
imshow(XDEN); colormap gray; axis off;
title('Denoised Image');
level = graythresh(XDEN);
BW = imbinarize(XDEN,level);
