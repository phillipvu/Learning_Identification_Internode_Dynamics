k1 = 10;
theta1 = 5; 
x1 = 0:0.2:400;
y1 = gampdf(x1,k1,theta1);
k2 = 30;
theta2 = 6;
x2 = 0:0.2:400;
y2 = gampdf(x2,k2,theta2);
k3 = 50;
theta3 = 8;
x3 = 0:0.2:400;
y3 = gampdf(x3,k3,theta3);

figure(5)
subplot(3,1,1)
plot(x1,y1)
subplot(3,1,2)
plot(x2,y2)
subplot(3,1,3)
plot(x3,y3)