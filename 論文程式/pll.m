function [x,y]=pll(x1,y1,x2,y2)

a1=y1(1)-y1(2);
b1=x1(2)-x1(1);
c1=y1(2)*x1(1)-y1(1)*x1(2);
a2=y2(1)-y2(2);
b2=x2(2)-x2(1);
c2=y2(2)*x2(1)-y2(1)*x2(2);
d=det([a1,b1;a2,b2]);
x=det([-c1 b1;-c2 b2])/d;
y=det([a1 -c1;a2,-c2])/d;

 