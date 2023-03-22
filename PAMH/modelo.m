%--------------------------------------------------
%-      SIMULACIONES PARA SEGUNDO SET DE DATOS    -
%--------------------------------------------------

% Cierra lo que se tiene abierto
close all

s = tf('s');

% Se leen los datos del archivo csv
matriz = csvread('PAMH_2set.csv',1,0);

% Se ordenan los datos para la estimación 
t = matriz(:,1);
t_c = matriz(78:2021,1);

theta = matriz(:,2);
theta_c = matriz(78:2021,2);

ref = matriz(:,3);
ref_c = matriz(78:2021,3);

% Funcion de transferencia obtenida usando
% systemIdentification('planta2.sid')

% Da fit de 85.19
funct1 = tf(5.363, [1 0.2289 15.55]);

% Se realiza plot para comparar a ojo el modelo obtenido vs los datos
% originales
plot(t_c, theta_c, 'color', 'g');
hold on;
step(funct1);
title('Datos reales vs Modelo empírico');
xlabel('Time');
ylabel('Ángulo (rad)');
xlim([0, 40])
ylim([0, 1.2])
grid on;

% Calculos para comparacion con modelo a partir de ecuaciones matematicas
gmax_i = max(theta_c);
gmax_i1 = 1.041;
delta = log(gmax_i/gmax_i1);

shi = delta/sqrt((2*pi)^2+delta^2);

te = 1.7;
w = 2*pi/te;
wn = w/sqrt(1-shi^2);

A = 1.7;
lim_datos = 0.574;

% Se determina el valor de la ganancia
K = gmax_i/A;
K = lim_datos/A;

figure();
grid on;
plot(t_c,theta_c);

% Función obtenida matematicamente
Gs = K*wn^2/(s^2+2*shi*wn*s+wn^2);

figure();
step(Gs);
hold on
step(funct1);
hold on
plot(t_c, theta_c, 'color', 'g');
xlabel('Time');
ylabel('Ángulo (rad)');
xlim([0, 40])
ylim([0, 1.4])
legend('Matemática', 'Modelo', 'Datos');
grid on;
