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
