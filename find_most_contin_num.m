function [ table ] = find_most_contin_region( a )
da=diff(a);
c=a(da==0);
d=unique(c); 
table=zeros(2,size(d,2)); 
for m = 1:size(d,2)
    table(1,m)=d(m); 
    table(2,m)=size(c(c==d(m)),2)+1; 
end 

end

