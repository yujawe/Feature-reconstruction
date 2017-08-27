function [ output_args ] = two_line_intersec( input_args )
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

end

