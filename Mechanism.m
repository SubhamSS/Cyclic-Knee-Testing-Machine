clc; 
% Parameters
alpha=80*pi/180;
theta = 30*pi/180;
C = 9*5; D = 10.882*5;
%A = 0.5*((1+cos(alpha))*C+((cos(theta)-1)*D)); B = 0.5*((cos(theta)+1)*D+(-1+cos(alpha))*C);
%A = 0.5*(0.658*C-0.134*D); B = 0.5*(1.866*D-1.34*C); 
%A=2;B=8;
B = 0.05*(128.26+191.65)*5;
A = 0.05*(-128.26+191.65)*5;

t = 0:pi/200:pi;

ang_speed = 2;
theta = ang_speed*t;

P1 = [0;0];
P4 = D*[1;0];
%P4=[53.54/5;-9.7/5];
P2 = A*[cos(theta); sin(theta)]; 
E = sqrt(A^2 + D^2 - 2*A*D*cos(theta));
alfa = asin(A*sin(theta)./E);
beta = acos((E.^2 + C^2 - B^2)./(2*E*C));
P3 = [D - C*cos(alfa+beta); C*sin(alfa+beta)];

P3_x = P3(1,:);
P3_y = P3(2,:);

P2_x = P2(1,:);
P2_y = P2(2,:);

P3_vx = diff(P3_x)./diff(t);
P3_vy = diff(P3_y)./diff(t);

P3_v = sqrt(P3_vx.^2 + P3_vy.^2);

for i=1:1:201
slopeB(i) = (P3_y(i)-P2_y(i))/(P3_x(i)-P2_x(i));
slopeC(i) = (P4(2,:)-P3_y(i))/(P4(1,:)-P3_x(i));
slopeA(i) = (P1(2,:)-P2_y(i))/(P1(1,:)-P2_x(i));
slopeD(i) = 0;
P3_angle(i) = atan((slopeC(i)-slopeB(i))/(1+slopeC(i)*slopeB(i)));
P4_angle(i) = atan((slopeD(i)-slopeC(i))/(1+slopeD(i)*slopeC(i)));
if P3_angle(i)>=0
    P3_ac(i) = P3_angle(i);
else
    P3_ac(i) = P3_angle(i)+pi;
end
if P4_angle(i)>=0
    P4_ac(i) = P4_angle(i);
else
    P4_ac(i) = P4_angle(i)+pi;
end
end

for i=1:length(t)

   ani = subplot(2,1,1);

   P1_circle = viscircles(P1',0.05);
   P2_circle = viscircles(P2(:,i)',0.05);
   P3_circle = viscircles(P3(:,i)',0.05);
   P4_circle = viscircles(P4',0.05); 
   
   A_bar = line([P1(1) P2(1,i)],[P1(2) P2(2,i)]);
   B_bar = line([P2(1,i) P3(1,i)],[P2(2,i) P3(2,i)]);
   C_bar = line([P3(1,i) P4(1)],[P3(2,i) P4(2)]);
   %F(i)=getframe(gcf);
%    axis(ani,'equal');
    set(gca,'XLim',[-50 100],'YLim',[-35 70]);
    %grid on;
   daspect([1 1 1]);
   str1 = 'P3';
   %str2 = ['Time elapsed: '  num2str(t(i)) ' s'];
   P3_text = text(P3(1,i),P3(2,i)+0.4,str1);
   %Time = text(-2,6,str2);
   pause(0.005);
   if i<length(t)
    delete(P1_circle);
    delete(P2_circle);
    delete(P3_circle);
    delete(P4_circle);
    delete(A_bar);
    delete(B_bar);
    delete(C_bar);
    delete(P3_text);
    %delete(Time);
    vel = subplot(2,1,2);
    plot(vel,theta(1:i),P3_v(1:i));
    
%     plot(vel,t(1:i),P2_ac(1:i));
    set(vel,'XLim',[0 2*pi],'YLim',[-5 95]);
    xlabel(vel, 'Crank angle');
    ylabel(vel, 'Rocker end velocity');
    title(vel,'Rocker velocity');
    grid on;
   % daspect([1 1 1])
   end

end
%video = VideoWriter('Mechanism2.avi','Uncompressed AVI');
%open(video)
%writeVideo(video,F);
%close(video)

