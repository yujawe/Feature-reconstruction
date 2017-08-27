function [ seg_R,mask_sample ] = image_seg( A,filename )
wname = 'haar';
level = 5;
[C,S] = wavedec2(A,level,wname);
thr = wthrmngr('dw2ddenoLVL','penalhi',C,S,8);
sorh = 's';
[A,~,~] = wdencmp('lvd',C,S,wname,level,thr,sorh);

A=A/256;
Alab=(rgb2lab(A)/256);
%imwrite(A,'C:\Users\Wei\Google 雲端硬碟\論文文件\noiseimage\sample1db4.jpg','jpg')

%{
corners = detectMinEigenFeatures(rgb2gray(A));
B=corners.selectStrongest(50);

plot(B.Location(:,1),B.Location(:,2),'mx','LineWidth',2);
f = getframe(gcf);  
imwrite(f.cdata,'MinEigen原解析.jpg')
%}
[L,N] = superpixels(Alab,2000,'Method','slic0');
BW = boundarymask(L);
str=[filename,' SLIC超像素分割'];
figure('NumberTitle', 'off', 'Name', str),imshow(imoverlay(A,BW,'cyan'))
pixelIdxList = label2idx(L);
meanColor = zeros(N,3);
[m,n] = size(L);
for  i = 1:N
	   meanColor(i,1) = mean(Alab(pixelIdxList{i}));
    meanColor(i,2) = mean(Alab(pixelIdxList{i}+m*n));
    meanColor(i,3) = mean(Alab(pixelIdxList{i}+2*m*n));
end
numColors = 2;
[idx,cmap] = kmeans(meanColor,numColors,'replicates',10);
cmap = lab2rgb(cmap);
Lout = zeros(size(A,1),size(A,2));
for i = 1:N
    Lout(pixelIdxList{i}) = idx(i);
end
Lout=Lout-1;
[L,~] = bwlabel(Lout,4);
B = unique(L);
for i=0:B(end)
    if length(L(L==i))<300
        L(L==i)=0;
    end
end
seg_A = label2rgb(L,'spring','b','shuffle');
str=[filename,' k-means聚類'];
figure('NumberTitle', 'off', 'Name', str),imshow(seg_A)
seg_R=zeros(size(L,1),size(L,2),length(B)-1);
F=double(rgb2gray(A));
for i=1:length(B)-1
    copy_L=L;
    copy_L(copy_L~=B(i+1))=0;
    %copy_L=~copy_L;
    copy_L=imdilate(copy_L,strel('disk',60));
    copy_L=logical(copy_L);
    seg_R(:,:,i)=copy_L.*F;
%figure,imshow(seg_R(:,:,i))
se = strel('square',5);
level = graythresh(seg_R(:,:,i));
seg_R(:,:,i) = imbinarize(seg_R(:,:,i),level);
seg_R(:,:,i)=edge(seg_R(:,:,i),'Sobel');
seg_R(:,:,i) = bwmorph(seg_R(:,:,i),'clean');
mask_1=imerode(copy_L,strel('disk',30));
seg_R(:,:,i)=seg_R(:,:,i).*mask_1;
seg_R(:,:,i) = bwmorph(seg_R(:,:,i),'bridge',4);
seg_R(:,:,i)=imfill(seg_R(:,:,i),'holes');
seg_R(:,:,i)=imopen(seg_R(:,:,i),se);
mask_sample=seg_R(:,:,i);
seg_R(:,:,i)=bwmorph(seg_R(:,:,i),'remove');
end
end

