function [ center_x, center_y, radius ] = three_point_circle_detect( a,b,c )
d=[a;b;c];
A=[a-b,1;b-c,1;c-a,1];
if det(A)==0
    radius=inf;
    center_x=inf;
    center_y=inf;
else
syms x y;
z=[x,y];
eq1=(z-(a+b)/2)*((b-a)');
eq2=(z-(a+c)/2)*((c-a)');
[center_x,center_y]=solve(eq1,eq2);
radius=pdist2([center_x,center_y],a);
end
end

