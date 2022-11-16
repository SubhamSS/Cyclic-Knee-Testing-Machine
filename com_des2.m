opt=1000000;
opt_m= 1000000*ones(1,51);
index= zeros(1,51);
Hor_size= zeros(1,51);
Ver_size= zeros(1,51);
for H=300:1:350
for t=-60:1:60
    alpha=t*pi/180;
    Coeff =[sin(alpha) 0 1 0;0 cos(alpha+(30*pi/180)) -sin(70*pi/180) -1;...
        cos(alpha) 0 0 -1;0 sin(alpha+(30*pi/180)) cos(70*pi/180) 0];
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
    
    max_ver = max(H+link(t+61,1),link(t+61,3));
    max_hor = link(t+61,1)+L(t+61,4)+link(t+61,3)*sin(70*pi/180);
    to_min = (max_ver*max_hor);
    
    Condn =[link(t+61,1)>150;link(t+61,2)>150;link(t+61,3)>150;...
        link(t+61,1)<500;link(t+61,1)<500;link(t+61,1)<500;...
        L(t+61,4)>150;link(t+61,1)<link(t+61,2);link(t+61,1)<link(t+61,3);...
        link(t+61,1)<link(t+61,4);2*(max(link(t+61,:))+min(link(t+61,:)))<sum(link(t+61,:));max_ver>450];
    if Condn == [1;1;1;1;1;1;1;1;1;1;1;1]
        if to_min < opt
            opt = to_min;
            opt_m(H-299)=opt;
            index(H-299) = t+61;
            Hor_size = max_hor;
            Ver_size = max_ver;
            Links = [link(t+61,1) link(t+61,2) link(t+61,3) link(t+61,4)];
        end
    end       
end
end
soln= min(opt_m);

