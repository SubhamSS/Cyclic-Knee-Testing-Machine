clc; 
% Parameters
alpha=70*pi/180;
theta = 30*pi/180;
C = 6.4; D = 15;

%A = 0.5*(0.658*C-0.134*D); B = 0.5*(1.866*D-1.34*C); 
%A=2;B=8;
t = 0:0.05:10;

ang_speed = 2;
rota = ang_speed*t;

P1 = [0;0];
P4 = D*[1;0];

P2 = A*[cos(rota); sin(rota)]; 
E = sqrt(A^2 + D^2 - 2*A*D*cos(rota));
alfa = asin(A*sin(rota)./E);
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
   
%    axis(ani,'equal');
    set(gca,'XLim',[-10 20],'YLim',[-7 7]);
   daspect([1 1 1]);
   str1 = 'P3';
   str2 = ['Time elapsed: '  num2str(t(i)) ' s'];
   P3_text = text(P3(1,i),P3(2,i)+0.4,str1);
   Time = text(-2,6,str2);
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
    delete(Time);
    vel = subplot(2,1,2);
    plot(vel,t(1:i),180*P4_ac(1:i)/pi);
    
%     plot(vel,t(1:i),P2_ac(1:i));
    set(vel,'XLim',[0 10],'YLim',[-10 100]);
    xlabel(vel, 'Time (s)');
    ylabel(vel, 'P3_angle');
    title(vel,'Angle of P3');
    grid on;
   % daspect([1 1 1])
   end

end

