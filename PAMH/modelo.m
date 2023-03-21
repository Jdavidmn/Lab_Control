s = tf('s');

matriz = csvread('PAMH_3Set.CSV', 1, 0);

tiempo = matriz(74:2022,1);
angulo = matriz(74:2022,2);
estimulo = matriz(74:2022,3);

tf3 = tf([5.3807], [1 0.1984 15.6570]);             % la que da el system identification

%systemIdentification('modelo.sid');                % abre el system identification, da un porcentaje de 86%

gmax = 1.14;
gmax1 = 1.031;
T = 1.62;

delta = log(1.14/1.031);

xi = delta/(sqrt((2*pi)^2+delta^2));
k = gmax/1.7;

w = 2*pi/(T*sqrt(1-xi^2));

model = k*w^2/(s^2+2*xi*w*s+w^2);           % la que da el modelo a pata