function [ sort_cornerpoint ] = Intersection_point( sort_cornerpoint_pos,sort_point )
n=length(sort_cornerpoint_pos);
i=n+1;
sort_cornerpoint_pos=[sort_cornerpoint_pos;sort_cornerpoint_pos+size(sort_point,1);sort_cornerpoint_pos+size(sort_point,1)*2];
data_length=size(sort_point,1);
sort_point=[sort_point;sort_point;sort_point];
sort_cornerpoint=[];
while i<2*n+1
    if     abs(sort_cornerpoint_pos(i+1)-sort_cornerpoint_pos(i))<15
           lineData_1=sort_point(sort_cornerpoint_pos(i)-10:-1:sort_cornerpoint_pos(i-1)+10,:);
           lineData_2=sort_point(sort_cornerpoint_pos(i+1)+10:1:sort_cornerpoint_pos(i+2)-10,:);
           [ yy_1,xx_1,~ ] = line_fit( lineData_1 );
           [ yy_2,xx_2,~ ] = line_fit( lineData_2 );
           %plot(yy_1,xx_1,'LineWidth',1)
           %plot(yy_2,xx_2,'LineWidth',1)
           if acosd(dot((yy_2-yy_1),(xx_2-xx_1))/norm(yy_2-yy_1)/norm(xx_2-xx_1))==0 || acosd(dot((yy_2-yy_1),(xx_2-xx_1))/norm(yy_2-yy_1)/norm(xx_2-xx_1))==180
               c_xy=(sort_point(sort_cornerpoint_pos(i+1),:)+sort_point(sort_cornerpoint_pos(i),:))/2;
               c_x=c_xy(1);c_y=c_xy(2);
           else
           [c_x,c_y]=pll(yy_1,xx_1,yy_2,xx_2);
           end
           %plot(c_x,c_y,'y*')
           sort_cornerpoint=[sort_cornerpoint;c_x,c_y];
           i=i+1;
    elseif abs(sort_cornerpoint_pos(i-1)-sort_cornerpoint_pos(i))<30
    else
        sort_cornerpoint=[sort_cornerpoint;fliplr(sort_point(sort_cornerpoint_pos(i),:))];
           
    end
    i=i+1;
end
    %plot(sort_cornerpoint(:,1),sort_cornerpoint(:,2),'y*')

end

