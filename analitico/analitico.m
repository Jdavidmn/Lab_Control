close all;

miup = 0.01325;
miuy = 0.8513;
jy = 0.0023255;
lcm = 0.045;
jp = 0.0023255;
rp = 0.335;
ry = 0.24;
kp = 0.00038;
ky = 0.00038;
Fg = 9.81;

pitch = tf([rp/jp*kp], [1 miup*rp/jp Fg*lcm/jp]);

yaw = tf([ry/jy*ky], [1 miuy*ry/jy 0]);

figure("name", "pitch");
step(pitch);
ylabel('Ángulo (grados)');

figure("name", "yaw");
step(yaw);
ylabel('Ángulo (grados)');

figure("name", "pitch");
impulse(pitch);
ylabel('Ángulo (grados)');

figure("name", "yaw");
impulse(yaw);
ylabel('Ángulo (grados)');

