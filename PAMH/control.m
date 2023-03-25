%--------------------------------------------------
%-             DISEÑO DE LOS CONTROLES            -
%--------------------------------------------------

% Cierra lo que se tiene abierto
close all

s = tf('s');

% Modelo a partir del system identification (Para set de datos 3)
tf3 = tf([5.3807], [1 0.1984 15.6570]);

num_tf3 = [5.3807];
den_tf3 = [1 0.1984 15.6570];

% Modelo a partir de las ecuaciones
tf_math = tf([5.176], [1 0.1241 15.05]);

%----------------------------------
%-      DISEÑO DEL PID - IMC      -
%----------------------------------

% Se usa sisotool para diseñar el control
%sisotool(tf3)

%tf_ctrl_imc = tf([0.7434 0.7434*0.1984 0.7434*15.66], [1 4 0]);

syms KP KI KD N S;

tf_ctrl_imc = tf([0.25723 0.25723*0.1984 0.25723*15.66], [1 2.353 0]);

[num, den]=tfdata(tf_ctrl_imc,'v');

PID=KP+KI/S+(KD*N*S)/(S+N);
collect(PID);
N=den(2);
KI=num(3)/N;
KP=(num(2)-KI)/N;
KD=(num(1)-KP)/N;
 
% Se grafica la respuesta del step con el control
figure();
step(feedback(tf_ctrl_imc*tf3,1));

%-------------------------------------------------------
%     DISEÑO DEL I_PD - ACKER (UBICACIÓN DE POLOS)     -
%-------------------------------------------------------

% Determina matriz de espacio de estados
[A,B,C,D] = tf2ss(num_tf3,den_tf3);

% Calcula la controlabilidad
Co = ctrb(A,B);
Co_inv = inv(Co);

A_bar = Co_inv*A*Co;
B_bar = Co_inv*B;
C_bar = C*Co;
D_bar = D;

% Polos deseados 
P_wish = [-1+3i -1-3i];
K = acker(A_bar,B_bar,P_wish);

K1 = K(1);
K2 = K(2);

%Simulacion en Simulink
warning off
%sim('Problm_1_simulink')

%Importar variables del simulink
t1      = out1.time;
out11   = out1.signals.values(:,1);
step11  = step1.signals.values(:,1);
t2      = step1.time;

%Graficar la respuesta
%figure();
%plot(t1, out11, t2, step11, 'Linewidth', 2)
%ylabel("Amplitud")
%grid on
%legend("Compesado", "Entrada", 'Location', 'SouthEast')
%title("Respuesta a un impulso, del REI")


 