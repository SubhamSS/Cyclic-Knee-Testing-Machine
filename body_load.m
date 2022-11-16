clc; clear all;
% Parameters
A = 17;B=35;C=33;D=35;

t = 0:0.0002:3;

ang_speed = 4*pi;
theta = ang_speed*t;
%% POSITIONS AND VELOCITIES
P1 = [0;0];
P4 = D*[-1;0];

P2 = A*[cos(theta); sin(theta)];
P2_x = P2(1,:);
P2_y = P2(2,:);

P2_vx = diff(P2_x)./diff(t);
P2_vy = diff(P2_y)./diff(t);

A_CG_x = P2(1,:)/2;
A_CG_y = P2(2,:)/2;
A_CG_vx = diff(A_CG_x)./diff(t);
A_CG_vy = diff(A_CG_y)./diff(t);

E = sqrt(A^2 + D^2 + 2*A*D*cos(theta));
alfa = asin(A*sin(theta)./E);
beta = acos((E.^2 + C^2 - B^2)./(2*E*C));
P3 = [-D + C*cos(alfa+beta); C*sin(alfa+beta)];

P3_x = P3(1,:);
P3_y = P3(2,:);

P3_vx = diff(P3_x)./diff(t);
P3_vy = diff(P3_y)./diff(t);

P3_v = sqrt(P3_vx.^2 + P3_vy.^2);

B_CG_x = (P2(1,:)+P3(1,:))/2;
B_CG_y = (P2(2,:)+P3(2,:))/2;
B_CG_vx = diff(B_CG_x)./diff(t);
B_CG_vy = diff(B_CG_y)./diff(t);

C_CG_x = (P3(1,:)-D)/2;
C_CG_y = P3(2,:)/2;
C_CG_vx = diff(C_CG_x)./diff(t);
C_CG_vy = diff(C_CG_y)./diff(t);

%% ACCELERATIONS
t = 0.0002:0.0002:3;
A_CG_ax = diff(A_CG_vx)./diff(t);
A_CG_ay = diff(A_CG_vy)./diff(t);
A_CG_a = sqrt(A_CG_ax.^2 + A_CG_ay.^2);
B_CG_ax = diff(B_CG_vx)./diff(t);
B_CG_ay = diff(B_CG_vy)./diff(t);
B_CG_a = sqrt(B_CG_ax.^2 + B_CG_ay.^2);
C_CG_ax = diff(C_CG_vx)./diff(t);
C_CG_ay = diff(C_CG_vy)./diff(t);
P2_ax = diff(P2_vx)./diff(t);
P2_ay = diff(P2_vy)./diff(t);
P3_ax = diff(P3_vx)./diff(t);
P3_ay = diff(P3_vy)./diff(t);

%% ANG. VELOCITIES
for i = 1:1:15000
omega_3(i) = (P3_vy(i) - P2_vy(i))./(P3_x(i+1)-P2_x(i+1));
omega_4(i) = (P3_vx(i))./(-P3_y(i+1));
end

%% ANG. ACCNS
alpha_3 = diff(omega_3)./diff(t);
alpha_4 = diff(omega_4)./diff(t);

%% FORCE ANALYSIS
%M_A = 0.49;M_B =0.42;M_C=0.74;
%I_A=22.6;I_B=60;I_C=100.6;

M_A = 1.447;M_B =1.251;M_C=2.108;
I_A=69.9;I_B=193;I_C=287.54;
Solution=[];
for i = 1:1:14999
R_mat = [1 0 1 0 0 0 0 0 0;...
    0 1 0 1 0 0 0 0 0;...
    A_CG_y(i+2) -A_CG_x(i+2) (A_CG_y(i+2)-P2_y(i+2)) (P2_x(i+2)-A_CG_x(i+2)) 0 0 0 0 1;...
    0 0 -1 0 1 0 0 0 0;...
    0 0 0 -1 0 1 0 0 0;...
    0 0 (P2_y(i+2)-B_CG_y(i+2)) (-P2_x(i+2)+B_CG_x(i+2)) (-P3_y(i+2)+B_CG_y(i+2)) (P3_x(i+2)-B_CG_x(i+2)) 0 0 0;...
    0 0 0 0 -1 0 1 0 0;...
    0 0 0 0 0 -1 0 1 0;...
    0 0 0 0 (P3_y(i+2)-C_CG_y(i+2)) (-P3_x(i+2)+C_CG_x(i+2)) (C_CG_y(i+2)) (-35-C_CG_x(i+2)) 0];

RHS = [M_A*A_CG_ax(i) - 1*M_A*980*cos(30*pi/180); M_A*A_CG_ay(i) - 1*M_A*980*sin(30*pi/180); 0;...
    M_B*B_CG_ax(i) - 1*M_B*980*cos(30*pi/180); M_B*B_CG_ay(i) - 1*M_B*980*sin(30*pi/180);I_B*alpha_3(i);...
    M_C*C_CG_ax(i) - 1*(M_C+1*7)*980*cos(30*pi/180) + 2*3.5*alpha_4(i)*sin(alfa(i)+beta(i)); M_C*C_CG_ay(i) - 1*(M_C+1*7)*980*cos(30*pi/180) - 7*3.5*alpha_4(i)*sin(alfa(i)+beta(i));...
    I_C*alpha_4(i)+7*3.5*3.5*alpha_4(i)+ 1*7*980*3.5*sin(alfa(i)+beta(i))];

%Sol(i) = [F12x(i); F12y(i); F32x(i); F32y(i); F43x(i); F43y(i); F14x(i); F14y(i); T(i)];
Sol = inv(R_mat)*RHS;
Solution = [Solution Sol];
end

%% PLOT
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
   axis(ani,'equal');
   set(gca,'XLim',[-50 50],'YLim',[-50 50]);
   
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
    plot(vel,t(1:i),(Solution(9,1:i)));
    %plot(vel,t(1:i),alpha_4(1:i));
    set(vel,'XLim',[0 3]);
    xlabel(vel, 'Time (s)');
    ylabel(vel, 'Torque(kg.cm2/s2)');
    title(vel,'Torque');
    grid on;
   end

   end 
%video = VideoWriter('Mechanism_rev.avi','Uncompressed AVI');
%open(video)
%writeVideo(video,F);
%close(video)

