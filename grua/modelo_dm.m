s = tf("s");

matriz = csvread("Grua_Modelo4(55s).csv", 1, 0);

matriz_val = csvread("Grua_Modelo1(304s).csv", 1, 0);

tiempo = matriz(:, 1);
entrada = matriz(:, 2);
angulo = matriz(:, 3);
posicion = matriz(:, 4);

tiempo_val = matriz_val(:, 1);
entrada_val = matriz_val(:, 2);
angulo_val = matriz_val(:, 3);
posicion_val = matriz_val(:, 4);

% Se grafica los datos
figure('name', 'Datos de la planta para posicion')
plot(tiempo, posicion)

figure('name', 'Datos de la planta para angulo')
plot(tiempo, angulo)

figure('name', 'Datos de la planta para entrada')
plot(tiempo, entrada)

% systemIdentification()

% funcion de posicion
tf_22 = tf(0.024254/(s*(1 + 0.10333*s)));

% funcion de angulo
tf_300 = tf([-0.3573 -0.4939], [1 0.0154 35.32]);

% calculos de las matrices posicion

[num_p, den_p] = tfdata(tf_22, 'v');
Ap = [0 0 1 0; 0 0 0 0; 0 0 den_p(2) 0; 0 0 0 0];