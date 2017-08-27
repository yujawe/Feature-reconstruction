function cornerpoint = find_corner( v,sort_point,n,c_star)

samplength=round(n/c_star);
startpoint=0;
cornerpoint=[];
thrang=3;
v = [v;v];
sort_point=[sort_point;sort_point];
while startpoint<n+50
    v1=mean(v(startpoint+1:startpoint+(samplength/2),:));
    v2=mean(v(startpoint+(samplength/2)+1:startpoint+samplength,:));
    %plot(sort_point(startpoint+1,2),sort_point(startpoint+1,1),'g*')
    if acosd(dot(v1,v2)/norm(v1)/norm(v2))<thrang*1.1
        v3=mean(v(startpoint+samplength+1:startpoint+(samplength*(3/2)),:));
        v4=mean(v(startpoint+(samplength*(3/2))+1:startpoint+(samplength*2),:));
        if acosd(dot(v3,v4)/norm(v3)/norm(v4))<thrang*1.2 && acosd(dot(mean([v1;v2]),mean([v3;v4]))/norm(mean([v1;v2]))/norm(mean([v3;v4])))<thrang*1.5
            startpoint=startpoint+samplength;
        elseif acosd(dot(v3,v4)/norm(v3)/norm(v4))>thrang*2
           %plot(sort_point(startpoint+1,2),sort_point(startpoint+1,1),'y*')
           while acosd(dot(v3,v4)/norm(v3)/norm(v4))>thrang*1.4
           startpoint=startpoint+1;
           v3=mean(v(startpoint+samplength+1:startpoint+(samplength*(3/2)),:));
           v4=mean(v(startpoint+(samplength*(3/2))+1:startpoint+(samplength*2),:));   
           end
           cornerpoint = [cornerpoint;sort_point(startpoint+samplength,:)];
          % plot(cornerpoint(:,2),cornerpoint(:,1),'r*')
           startpoint=startpoint+samplength;
        else startpoint=startpoint+1;
        end
    else
        startpoint=startpoint+1;  
    end
end
%plot(cornerpoint(:,2),cornerpoint(:,1),'r*','LineWidth',0.5)

end

