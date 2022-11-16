opt=1000000; %initial high value
opt_m= 1000000*ones(1,151);
index= zeros(1,151);
for H=300:1:450 %loop with changing the vertical distance betn frame connections of crank and rocker
for t=-60:1:60  %loop with changing the starting angle
    alpha=t*pi/180;
    Coeff =[sin(alpha) 0 1 0;0 cos(alpha+(30*pi/180)) -sin(70*pi/180) -1;...
        cos(alpha) 0 0 -1;0 sin(alpha+(30*pi/180)) cos(70*pi/180) 0];
    RHS = [H;0;0;H];
    Len=inv(Coeff)*RHS;
    L(t+61,1)=Len(1);%min position(connecting rod-crank)
    L(t+61,2)=Len(2);%max position(crank+connecting rod)
    L(t+61,3)=Len(3);%rocker
    L(t+61,4)=Len(4);%hor_distance betn frame connections of crank and rocker
    link(t+61,1)=0.5*(Len(2)-Len(1));%crank
    link(t+61,2)=0.5*(Len(2)+Len(1));%connecting rod
    link(t+61,3)=Len(3);%rocker
    link(t+61,4)=sqrt(H^2+Len(4)^2);%fixed support
    
    max_ver = max(H+link(t+61,1),link(t+61,3));%max ver
    max_hor = link(t+61,1)+L(t+61,4)+link(t+61,3)*sin(70*pi/180);%max hor. coverage
    rect_area = (max_ver*max_hor);
    
    Condn =[link(t+61,1)>150;link(t+61,2)>150;link(t+61,3)>150;...
        link(t+61,1)<500;link(t+61,1)<500;link(t+61,1)<500;...
        L(t+61,4)>150;link(t+61,1)<link(t+61,2);link(t+61,1)<link(t+61,3);...
        link(t+61,1)<link(t+61,4);2*(max(link(t+61,:))+min(link(t+61,:)))<sum(link(t+61,:))];%constraints matrix
    if Condn == [1;1;1;1;1;1;1;1;1;1;1] %boolean matrix to satisfy constraints
        if rect_area < opt %if a better solution is found, it is stored.
            opt = rect_area;
            opt_m(H-299)=opt;
            index(H-299) = t+61;
            Hor_size = max_hor;
            Ver_size = max_ver;
            Angle = alpha*180/pi;
            Height = H;
            Links = [link(t+61,1) link(t+61,2) link(t+61,3) link(t+61,4)];
        end
    end       
end
end
%%type 'Links' in command window to get the link lengths 
%%type 'Angle' and 'Height' to get the parameters 'alpha' and 'H' for these link lengths