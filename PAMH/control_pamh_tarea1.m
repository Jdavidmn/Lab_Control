# Tarea 1 Laboratorio de Control Automático
# Estudiante: David Monge Naranjo  2019158668
# Profesor: Anibal Ruiz Barquero
# Grupo 3, Equipo E

pkg load control;
pkg load symbolic;
warning off;
s = tf("s");
clear all;
close all;

#-----------------------Descripción inicial de la planta----------------------------------

# Función de transferencia de la planta PAMH obtenida anteriormente
num = 5.3807;
den = [1 0.1984 15.6570];
planta = tf(num, den);
disp("La funcion de transferencia estimada de la planta PAMH a utilizar es: ");
planta

# Retroalimentación unitaria de la planta
syst1 = append(planta);
q1 = [1 -1];
input1 = [1];
output1 = [1];
retroalimentado = connect(syst1, q1, input1, output1);
#retroalimentado1 = feedback(planta,1);

# Gráfica de la ubicación de los polos de la planta

figure(1, "name", "Ubicación de los polos")
pzmap(planta);
title("Ubicación de los polos");
xlabel("Eje real");
ylabel("Eje imaginario");
axis([-0.15, 0.05, -4.5, 4.5]);

# Gráfica del lugar de las raíces de la planta sin control

figure(2, "name", "Lugar de las raíces de la planta sin control");
hold on;

# Gráfica de los requerimientos del sistema

ts = 5;                       # Se ingresa el tiempo de estabilización deseado
Mp1 = 3;                      # Se ingresa la primera condición de sobreimpulso  
Mp2 = 0;                      # Se ingresa la segunda condición de sobreimpulso (de no tener, poner 0)  
delta = 2;                    # Se ingresa el porcentaje de estabilización alcanzado  
 
# Se calcula el factor de amortiguamiento

xi1 = -log(Mp1 / 100) / sqrt(pi^2+log(Mp1/100)^2);

# Se calcula la frecuencia natural del sistema

omegan1 = -log(delta/100) / (xi1 * ts);

# Se calcula el ángulo de salida

theta1 = atan(sqrt(1-xi1^2) / xi1);

plot([0 2*cos(pi - theta1)], [0 2*sin(pi - theta1)], "k", "linewidth", 2);
plot([0 2*cos(-(pi - theta1))], [0 2*sin(-(pi - theta1))], "k", "linewidth", 2);

plot([-xi1*omegan1 -xi1*omegan1], [-15 15], "k", "linewidth", 1);

#Se calcula el factor de amortiguamiento, ángulo de salida y factor de amortiguamiento
#en caso de tener una segunda condición de sobreimpulso

if Mp2 ~= 0
    xi2 = -log(Mp2 / 100) / sqrt(pi^2+log(Mp2/100)^2);
    theta2 = atan(sqrt(1-xi2^2) / xi2);
    omegan2 = -log(delta/100) / (xi2 * ts);
    
    plot([0 500*cos(pi - theta2)], [0 500*sin(pi - theta2)], "k", "linewidth", 2);
    plot([0 500*cos(-(pi - theta2))], [0 500*sin(-(pi - theta2))], "k", "linewidth", 2);
end

rlocus(planta);
axis([-1 1 -15 15]);
title("Lugar de las raíces de la planta");

# Gráfica de la respuesta ante un escalón de amplitud 0.6 de la planta en lazo cerrado

figure(3, "name", "Respuesta ante un escalón unitario de la planta retroalimentada");
step(retroalimentado);
title("Respuesta al escalón");
xlabel("Tiempo [s]");
ylabel("Ángulo [rad]");
legend("Retroalimentación unitaria");

#------------------------Cálculo del controlador-------------------------------------------

# Forma canónica observable

Obs_A = [0 -den(3); 1 -den(2)];
Obs_B = [1; 0];
Obs_C = [0 num];
Obs_D = 0;

# Forma canónica controlable

A_FCC = Obs_A';
B_FCC = Obs_C';
C_FCC = Obs_B';

# Matrices expandidas

As = [A_FCC [0; 0]; -C_FCC 0];
Bs = [B_FCC; 0];

# Verificación de las matrices obtenidas

espacio_estados = ss(A_FCC, B_FCC, C_FCC, 0);
disp("\nPara verificar que las matrices obtenidas son correctas, la función recalculada planta2 debe ser igual a planta, se confirma que así es.");
planta2 = tf(espacio_estados)

# Cálculo de control IPD usando ubicación de polos con ackerman

Ps = [-0.9+0.51*i -0.9-0.51*i -16];
Ks_UP = acker(As, Bs, Ps);
Ks = Ks_UP;

# Descomposición de los parámetros del control

#Kp = Ks(1);
#Kd = Ks(2);
#Ki = -Ks(3);
N = 4;
Kp = 1.8496;
Kd = 2.5494;
Ki = 2.6458;

# Definición de los bloques de la topología IPD

sysI = tf(Ki, [1 0]);
sysPD = Kp + Kd*tf([N 0], [1 N]);
sys1 = tf(1,1);
sys2 = sys1;

# Método para conectar todos los bloques

syst = append(sysI, sysPD, planta, sys1);
syst_c = append(sysI, sysPD, sys2, sys1);
q = [1 4 0; 2 3 0; 3 1 -2; 4 -3 0];
input = 4;
output = 3;

syslc = connect(syst, q, input, output);
syslc_c = connect(syst_c, q, input, output);

figure(4,"name", "Respuesta ante un escalón de amplitud 0.6 de la planta controlada");
[Y, T, X] = step(0.6*syslc,20);
step(0.6*syslc,20);
title("Respuesta al escalón");
xlabel("Tiempo [s]");
ylabel("Ángulo [rad]");
legend("Planta controlada");

disp("\n\nEl control propuesto para la planta es un IPD con las siguientes constantes:");
Kp
Ki
Kd
N
disp("\nIntegrando estos valores en una función de transferencia, el control IPD corresponde a:");
syslc_c

disp("\nMientras que el sistema completo, que incluye la planta y el control es:");
syslc

#--------------------Verificación de los requisitos-----------------------------------

disp("\n\nSe verifica que los requisitos iniciales se cumplen correctamente");

# Porcentaje de sobre impulso

disp("\nPorcentaje de sobreimpulso:");
sobreimpulso_p = (max(Y)-Y(end))/0.6*100

# Arreglo donde se cumple que la salida está dentro del +/- 2% del valor final
# Se toma como valor final 0.6, se conoce a priori la forma de la gráfica

Y_t = (Y>(0.6 - 0.6*delta/100)) .* (Y<(0.6 + 0.6*delta/100));

# Posiciones del arreglo donde se cumple condición

Y_p = find((Y_t) == 1);

# Tiempo de estabilización
# Primer tiempo donde se cumple condición
# Se asume que es el primero porque a priori se conoce la forma de la salida (no oscila)

disp("\nTiempo de estabilización:");
t_estabilizacion = T(Y_p(1))

# Error de estadi estacionario

disp("\nError de estaado estacionario");
e_ss = (Y(end) - 0.6)/0.6*100