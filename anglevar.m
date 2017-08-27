function [ angle_var,p ] = anglevar( sort_cornerpoint_posi_2,sort_point,i)
    angle_var=[];
    p=sort_cornerpoint_posi_2(i)+1:sort_cornerpoint_posi_2(i+1)-1;
    if length(p)<400
        L=7;
    else
    L=round(length(p)/30);
    end
    sample_sec=round(linspace(p(1),p(end),L));
    sample_vec=sort_point(sample_sec(1:end-1),:)-sort_point(sample_sec(2:end),:);
    v1=sample_vec(1,:);
    for g=2:length(sample_vec)
    v2=sample_vec(g,:);
    angle_var=[angle_var,acosd(dot(v1,v2)/norm(v1)/norm(v2))];
    end

end

