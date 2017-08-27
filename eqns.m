function F = eqns( P,Q1,Q2,Q3,Q4,main_radius )
F=[abs(det([Q2-Q1,[P(1)-Q1(1);P(2)-Q1(2)]]))/norm(Q2-Q1)-main_radius;abs(det([Q4-Q3,[P(1)-Q3(1);P(2)-Q3(2)]]))/norm(Q4-Q3)-main_radius];
end

