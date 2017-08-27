function plot_arc(O,FIRST,ENDST)

if nargin<3
    error('Not enough input arguments.');
end
if length(O)~=length(FIRST) || length(FIRST)~=length(ENDST)
    error('Center, FIRST and ENDST points dimensions must agree. ');
end
O=reshape(O,length(O),1);
FIRST=reshape(FIRST,length(FIRST),1);
ENDST=reshape(ENDST,length(ENDST),1);
theta=acos(dot(FIRST-O,ENDST-O)/(norm(FIRST-O)*norm(ENDST-O)));

R1=FIRST-O;
R2=ENDST-O;
r=norm(R1);
X=[FIRST];
R=R1;
OFE=[O,FIRST,ENDST];
%立体空?
if length(O)==3
    th=linspace(0,theta,100);
    W=cross(R1,R2);
    dt=(th(2)-th(1))/norm(W);
    for m=1:length(th)
        Rota=R(:,end)+cross(W,R(:,end))*dt;
        R=[R,Rota];
        X=[X,O+Rota];
    end
    X=[X,ENDST];
    plot3(X(1,:),X(2,:),X(3,:),'r-');
    hold on
    plot3(OFE(1,:),OFE(2,:),OFE(3,:),'r.');
end
%xoy平面空?
if length(O)==2
    for th=linspace(0,theta,100)
        Rota=[cos(th) -sin(th);sin(th) cos(th)];
        X=[X,O+Rota*R1];
    end
    X=[X,ENDST];
    plot(X(1,:),X(2,:),'r-');
    hold on
    plot(OFE(1,:),OFE(2,:),'r.');
end