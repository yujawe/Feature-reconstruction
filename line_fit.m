function [ yy,xx,direction ] = line_fit( lineData )
           xy=mean(lineData,1);
           centeredLine=bsxfun(@minus,lineData,xy);
           [U,S,V]=svd(centeredLine);
           direction=V(:,1);
           t=-500:1:500;
           xx=xy(1)+direction(1)*t;
           yy=xy(2)+direction(2)*t;
end

