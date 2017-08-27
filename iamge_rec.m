function [ c_star,feature_point_value] = iamge_rec(img)
feature_point_num=[];
[x, y]=find(img==1);
points=[x,y];

if size(points,1)<600
    c_star_start=4;c_star_end=8;
else
    c_star_start=15;c_star_end=50;
end
for c_star=c_star_start:c_star_end
[ sort_cornerpoint,sort_point,iscircle ] = find_feature_point( points,c_star,0 );
    if iscircle
        feature_point_num=[feature_point_num 0];
    end
    feature_point_num=[feature_point_num size(sort_cornerpoint,1)];
end
[posi,num_length] = find_most_contin_region( feature_point_num );

c_star=round(c_star_start+posi+(num_length/2));

[ sort_cornerpoint,sort_point,~ ] = find_feature_point( points,c_star,1 );
feature_point_value=size(sort_cornerpoint,1);
sort_cornerpoint_posi_2=[];
for i=1:length(sort_cornerpoint)
       [~,cross_p]=min(pdist2(sort_cornerpoint(i,:),fliplr(sort_point)));
sort_cornerpoint_posi_2=[sort_cornerpoint_posi_2;cross_p];
end
for j=2:length(sort_cornerpoint)
    if sort_cornerpoint_posi_2(j)<sort_cornerpoint_posi_2(j-1)
        sort_cornerpoint_posi_2(j)=sort_cornerpoint_posi_2(j)+size(sort_point,1);
    end
end
i=length(sort_cornerpoint_posi_2);
cornpoint_num=i;
sort_cornerpoint_posi_2=[sort_cornerpoint_posi_2;sort_cornerpoint_posi_2+size(sort_point,1);sort_cornerpoint_posi_2+size(sort_point,1)*2];
%plot([sort_cornerpoint(:,1);sort_cornerpoint(1,1)],[sort_cornerpoint(:,2);sort_cornerpoint(1,2)],'r')
sort_point=fliplr(sort_point);
final_point=[];
sort_cornerpoint=[sort_cornerpoint;sort_cornerpoint;sort_cornerpoint];
sort_point=[sort_point;sort_point;sort_point];
straight_line=[];
arc=[];
rec_times=((length(sort_cornerpoint_posi_2))*2/3)+1;
if isempty(sort_cornerpoint_posi_2)
    return
end
while i<rec_times
    lineData_1=sort_point(sort_cornerpoint_posi_2(i):-1:sort_cornerpoint_posi_2(i)-10,:);
    lineData_2=sort_point(sort_cornerpoint_posi_2(i):1:sort_cornerpoint_posi_2(i)+10,:);
    lineData_3=sort_point(sort_cornerpoint_posi_2(i+1):-1:sort_cornerpoint_posi_2(i+1)-10,:);
    lineData_4=sort_point(sort_cornerpoint_posi_2(i+1):1:sort_cornerpoint_posi_2(i+1)+10,:);
    [ ~,~,dir_1 ] = line_fit( lineData_1 );
    [ ~,~,dir_2 ] = line_fit( lineData_2 );
    [ ~,~,dir_3 ] = line_fit( lineData_3 );
    [ ~,~,dir_4 ] = line_fit( lineData_4 );%判斷是否相切
    radius_sample=[];
    point_center=[];
    [ angle_var,p]=anglevar( sort_cornerpoint_posi_2,sort_point,i);
    arc_corr=corrcoef(angle_var,1:length(angle_var));
    if abs(arc_corr(2))>0.985 && abs(dot(dir_1,dir_2))>0.95 && abs(dot(dir_3,dir_4))>0.95 %圓角重建
        for r=1:5
        iSet=randperm(length(p));iSet=iSet(1:3);%隨機取樣3點
        arc_p=sort_point(p(iSet),:);
         %plot(arc_p(:,1),arc_p(:,2),'c*')
         [ center_x, center_y, radius ]=three_point_circle_detect( arc_p(1,:),arc_p(2,:),arc_p(3,:) );
         radius_sample=[radius_sample;radius];
         point_center=[point_center;center_x, center_y];
        end
        main_radius=median(radius_sample);
        main_center=median(point_center);
        lineData_1=sort_point(sort_cornerpoint_posi_2(i)-30:-1:sort_cornerpoint_posi_2(i-1),:);
        lineData_2=sort_point(sort_cornerpoint_posi_2(i+1)+30:1:sort_cornerpoint_posi_2(i+2),:);
        [ yy_1,xx_1 ] = line_fit( lineData_1 );
        [ yy_2,xx_2 ] = line_fit( lineData_2 );
        syms x y;
        P=[x;y];
        Q1=[ xx_1(1);yy_1(1)];
        Q2=[xx_1(end);yy_1(end)];
        Q3=[ xx_2(1);yy_2(1)];
        Q4=[xx_2(end);yy_2(end)];
        L1=Q2-Q1;L2=Q4-Q3;
        v1=double(main_center-sort_point(sort_cornerpoint_posi_2(i),:));
        v2=double(main_center-sort_point(sort_cornerpoint_posi_2(i+1),:));
        if acosd(dot(v1,v2)/norm(v1)/norm(v2))>150
            a=polyfit([xx_1(1),xx_1(end)],[yy_1(1),yy_1(end)],1);
            b=polyfit([xx_2(1),xx_2(end)],[yy_2(1),yy_2(end)],1);
            u_1=main_center(1)-a(1)*(a(1)*main_center(1)-1*main_center(2)+a(2))/a(1)^2+1;
            v_1=main_center(2)+(a(1)*main_center(1)-1*main_center(2)+a(2))/a(1)^2+1;
            u_2=main_center(1)-b(1)*(b(1)*main_center(1)-1*main_center(2)+b(2))/b(1)^2+1;
            v_2=main_center(2)+(b(1)*main_center(1)-1*main_center(2)+b(2))/b(1)^2+1;
            solx=(u_1+u_2)/2;
            soly=(v_1+v_2)/2;
        else
        eqns=[(det([Q2-Q1,P-Q1])/norm(Q2-Q1))^2-(main_radius)^2 == 0, (det([Q4-Q3,P-Q3])/norm(Q4-Q3))^2-(main_radius)^2 == 0];
        sol = vpasolve(eqns,[x,y]);
        d=pdist2(sort_point(round((sort_cornerpoint_posi_2(i)+sort_cornerpoint_posi_2(i+1))/2),:),[sol.x,sol.y]);
        minposition=find(d==min(d));
        solx=sol.x(minposition);soly=sol.y(minposition);
        direction_1=[-L1(2);L1(1)];
        direction_2=[-L2(2);L2(1)];
        t=-100:1:100;
        xx_1_n=solx+direction_1(1)*t;
        yy_1_n=soly+direction_1(2)*t;
        xx_2_n=solx+direction_2(1)*t;
        yy_2_n=soly+direction_2(2)*t;
        [u_1,v_1]=pll( xx_1,yy_1,xx_1_n,yy_1_n);
        [u_2,v_2]=pll( xx_2,yy_2,xx_2_n,yy_2_n);
        %plot(solx, soly,'g*')
        %plot(u_1,v_1,'g*')
        %plot(u_2,v_2,'g*')
        end
        crossang=(u_1-solx)*(v_2-soly)-(v_1-soly)*(u_2-solx);
        if  crossang<0
        plot_arc([solx,soly],[u_2,v_2],[u_1,v_1])
        else
        plot_arc([solx,soly],[u_1,v_1],[u_2,v_2])
        end
        arc=[arc;u_1,v_1;u_2,v_2];
        sort_cornerpoint(i,:)=[u_1,v_1];
        sort_cornerpoint(i+1,:)=[u_2,v_2];
        
    elseif var(angle_var)<30 %直線重建
        straight_line=[straight_line,i,i+1];
    else %曲線重建
        cond_curve=true;
        while cond_curve==true
            [ angle_var_curve,~ ]=anglevar( sort_cornerpoint_posi_2,sort_point,i+1);
                lineData_1=sort_point(sort_cornerpoint_posi_2(i+1):-1:sort_cornerpoint_posi_2(i+1)-10,:);
                lineData_2=sort_point(sort_cornerpoint_posi_2(i+1):1:sort_cornerpoint_posi_2(i+1)+10,:);
                [ ~,~,dir_1 ] = line_fit( lineData_1 );
                [ ~,~,dir_2 ] = line_fit( lineData_2 ); %判斷是否相切
            if var(angle_var_curve)>5 && abs(dot(dir_1,dir_2))>0.95
                sort_cornerpoint_posi_2(i+1)=[];
                sort_cornerpoint(i+1,:)=[];
                rec_times=rec_times-1;
                cornpoint_num=cornpoint_num-1;
            else
                cond_curve=false;
            end    
        end
               p=sort_cornerpoint_posi_2(i)+1:sort_cornerpoint_posi_2(i+1)-1;
               pp=sort_point(p(1):10:p(end),:);
               t = 1:size(pp,1);
               ts = 1:1/10:size(pp,1);
               x1=spline(t,pp(:,1),ts);
               y1=spline(t,pp(:,2),ts);
               plot(x1,y1,'r')
               %plot(pp(:,1),pp(:,2),'y*')
               %{
               x1=x1(1:20:end);y1=y1(1:20:end);
               angle_var=[];
               sample_vec=[x1(1:end-1)-x1(2:end);y1(1:end-1)-y1(2:end)]';
               for g=1:length(sample_vec)-1
               v1=sample_vec(g,:);
               v2=sample_vec(g+1,:);
               angle_var=[angle_var,abs(acosd(dot(v1,v2)/norm(v1)/norm(v2)))];
               end
               %}
        sort_cornerpoint(i,:)=pp(1,:);
        sort_cornerpoint(i+1,:)=pp(end,:);
    end
    i=i+1;
end
straight_line(1)=[];straight_line(2)=[];
straight_line=sort_cornerpoint(straight_line,:);
for i=1:2:size(straight_line,1)
    plot(straight_line(i:i+1,1),straight_line(i:i+1,2),'r')
    plot(straight_line(i:i+1,1),straight_line(i:i+1,2),'g*')
end

end




