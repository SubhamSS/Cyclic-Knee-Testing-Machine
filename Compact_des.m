H =250;
for t=-60:1:120
    alpha=t*pi/180;
    Coeff =[sin(alpha+(30*pi/180)) 0 1 0;0 cos(alpha) -sin(70*pi/180) -1;...
        cos(alpha+(30*pi/180)) 0 0 -1;0 sin(alpha) cos(70*pi/180) 0];
    RHS = [H;0;0;H];
    Len=inv(Coeff)*RHS;
    L(t+61,1)=Len(1);
    L(t+61,2)=Len(2);
    L(t+61,3)=Len(3);
    L(t+61,4)=Len(4);
    link(t+61,1)=0.5*(Len(2)-Len(1));
    link(t+61,2)=0.5*(Len(2)+Len(1));
    link(t+61,3)=Len(3);
    link(t+61,4)=sqrt(H^2+Len(4)^2);
end