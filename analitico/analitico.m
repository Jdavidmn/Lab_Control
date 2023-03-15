close all;

miup = 0.01325;
miuy = 0.8513;
jy = 0.0084;
lcm = 0.186;
jp = 0.0178;
rp = 0.5;
ry = 0.4;
kp = 0.8722;
ky = 0.42;
Fg = 9.81;

pitch = tf([rp/jp*kp], [1 miup*rp/jp Fg*lcm/jp]);

yaw = tf([ry/jy*ky], [1 miuy*ry/jy 0]);

figure("name", "pitch");
step(feedback(pitch,1));

figure("name", "yaw");
step(feedback(yaw,1));