clear all
close all
filename='C:\Users\Wei\Desktop\�פ�N��\�פ�{��\�{���ι���\4.jpg';
A = imread(filename);
reso_ratio=sqrt(size(A,1)*size(A,2)/(600^2));
A = imresize(A, 1/round(reso_ratio,2));
%BW = edge(rgb2gray(A),'Sobel');
%A = imnoise(A,'salt & pepper');
%A = medfilt2(rgb2gray(A));
%A=imfilter(A,fspecial('average'));
%A = imrotate(A,180);
%imwrite(A,'C:\Users\Wei\Google ���ݵw��\�פ���\noiseimage\sample1_noise.jpg','jpg')
[ seg_R,mask_sample ]  = image_seg( A,filename ) ; 
str=[filename,' ���ص��G'];
figure('NumberTitle', 'off', 'Name', str),imshow(A);hold on
%imwrite(seg_R(:,:,2),'C:\Users\Wei\Google ���ݵw��\�פ���\�פ����\�Ϥ�2.jpg','jpg')
%figure,imshow(A);hold on
for i=1:size(seg_R,3)
[c_star,feature_point_value]=iamge_rec(seg_R(:,:,i));
end
%{
for h=15:50
    iamge_rec(seg_R(:,:,1),h)
end
  %}

   


