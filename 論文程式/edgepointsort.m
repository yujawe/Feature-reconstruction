function sort_points=edgepointsort(orin_points)
k=size(orin_points,1);
for i=1:k-2
    %plot(points(i,2),points(i,1),'g*')
            point_dist=pdist2(orin_points(i,:),orin_points(i+1:end,:));
            minpoint_index=find(abs(point_dist)==min(abs(point_dist)));
            if length(minpoint_index)>1
                 minpoint_index= minpoint_index(1);
            end
            temp=orin_points(i+1,:);
            orin_points(i+1,:)=orin_points(i+minpoint_index,:);
            orin_points(i+minpoint_index,:)=temp;
            
end
sort_points=orin_points;
end
