function [ sort_cornerpoint,sort_point,iscircle ] = find_feature_point( points,c_star,plot_cir )

sort_point=edgepointsort(points);
sort_point_he=[sort_point;sort_point(1,:)];
%[xi,yi]=get_samples_1(x,y,round(length(x)/5));plot(yi,xi,'g*')
n=size(sort_point,1);
u=circshift(sort_point_he(:,1),1)-sort_point_he(:,1);
v=circshift(sort_point_he(:,2),1)-sort_point_he(:,2);
%quiver(sort_point_he(:,2),sort_point_he(:,1),v,u,0.05)
v=[u,v];
cornerpoint = find_corner( v,sort_point_he,n,c_star);
if isempty(cornerpoint)
    angle_var=[];
    sample_sec=round(linspace(1,size(sort_point_he,1),12));
    sample_vec=sort_point_he(sample_sec(1:end-1),:)-sort_point_he(sample_sec(2:end),:);
    for g=1:length(sample_vec)-1
    v1=sample_vec(g,:);
    v2=sample_vec(g+1,:);
    angle_var=[angle_var,acosd(dot(v1,v2)/norm(v1)/norm(v2))];
    end
    arc_corr=corrcoef(angle_var,1:length(angle_var));
    radius_sample=[];point_center=[];
    p=1:n;
   if plot_cir==1
   for r=1:5 %圓重建
             iSet=randperm(length(p));iSet=iSet(1:3);%隨機取樣3點
            arc_p=sort_point(p(iSet),:);
            % plot(arc_p(:,2),arc_p(:,1),'c*')
            [ center_x, center_y, radius ]=three_point_circle_detect( arc_p(1,:),arc_p(2,:),arc_p(3,:) );
            radius_sample=[radius_sample;radius];
            point_center=[point_center;center_x, center_y];
   end

        main_radius=median(radius_sample);
        main_center=median(point_center);
        viscircles(double(fliplr(main_center)),double(main_radius),'LineWidth',2)

   end
   sort_cornerpoint=[];
   iscircle=1;
        return 
else
 
cornerpoint_sec = find_corner( flipud(v),flipud(sort_point_he),n,c_star);
cornerpoint=unique([cornerpoint;cornerpoint_sec],'rows');
sort_cornerpoint_pos=find(ismember(sort_point,cornerpoint,'rows'));

sort_cornerpoint = Intersection_point( sort_cornerpoint_pos,sort_point );

iscircle=0;
end
end

