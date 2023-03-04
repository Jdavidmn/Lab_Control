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

figure("name", "pitch escalon sin realimentar");
step(pitch);
title("Respuesta pitch ante un escalon sin realimentar");

figure("name", "pitch escalon con realimentación");
step(feedback(pitch,1));
title("Respuesta pitch ante un escalon con realimentación")

figure("name", "yaw escalon sin realimentar");
step(yaw);
title("Respuesta yaw ante un escalon sin realimentar");

figure("name", "yaw escalon con realimentación");
step(feedback(yaw,1));
title("Respuesta yaw ante un escalon con realimentación")


figure("name", "pitch impulso sin realimentación");
impulse(pitch);
title("Respuesta picth ante un impulso sin realimentación")

figure("name", "pitch impulso con realimentación");
impulse(feedback(pitch,1));
title("Respuesta picth ante un impulso con realimentación")

figure("name", "yaw sin realimentación impulso");
impulse(yaw);
title("Respuesta yaw ante un impulso sin realimentación")

figure("name", "yaw con realimentación impulso");
impulse(feedback(yaw,1));
title("Respuesta yaw ante un impulso con realimentación")