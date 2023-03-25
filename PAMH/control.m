%--------------------------------------------------
%-             DISEÑO DE LOS CONTROLES            -
%--------------------------------------------------

% Cierra lo que se tiene abierto
close all

s = tf('s');

% Modelo a partir del system identification (Para set de datos 3)
tf3 = tf([5.3807], [1 0.1984 15.6570]);

% Modelo a partir de las ecuaciones
tf_math = tf([5.176], [1 0.1241 15.05]);

%----------------------------
%-      DISEÑO DEL IMC      -
%----------------------------

% Se usa sisotool para diseñar el control
%sisotool(tf3)

tf_ctrl_imc = tf([0.7434 0.7434*0.1984 0.7434*15.66], [1 4 0]);

syms KP KI KD N S;

[num, den]=tfdata(C,'v');
PID=KP+KI/S+(KD*N*S)/(S+N);
collect(PID);
N=den(2);
KI=num(3)/N;
KP=(num(2)-KI)/N;
KD=(num(1)-KP)/N;
 
% Se grafica la respuesta del step con el control
figure();
step(feedback(tf_ctrl_imc*tf3,1));


 