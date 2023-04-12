
close all
s = tf('s');
syms KP KI KD N S
matriz = csvread('PAMH_3Set.CSV', 1, 0);

tiempo = matriz(74:2022,1);
angulo = matriz(74:2022,2);
estimulo = matriz(74:2022,3);

tf3 = tf([5.3807], [1 0.1984 15.6570]);             % la que  da el system identification

%systemIdentification('modelo.sid');                % abre el system identification, da un porcentaje de 86%

gmax = 1.14;
gmax1 = 1.031;
T = 1.62;

delta = log(1.14/1.031);

xi = delta/(sqrt((2*pi)^2+delta^2));
k = 0.583/1.7;

w = 2*pi/(T*sqrt(1-xi^2));

model = k*w^2/(s^2+2*xi*w*s+w^2);           % la que da el modelo a pata

%Se grafica una sobre otra
figure(1)
step(tf3);
hold on
step(model, 'y');
hold on
legend('Modelo', 'Matemático')
xlabel('Time');
ylabel('Ángulo (rad)');
xlim([0, 40])
ylim([0, 1.4])
hold off


%Función del control PID por IMC
C= tf([0.25723 0.25723*0.1984 0.25723*15.66], [1 2.353 0]);  
%Control PID por IMC
[num, den]=tfdata(C,'v');
PID=KP+KI/S+(KD*N*S)/(S+N);
collect(PID);
N2=4;
N=den(2);
KI=num(3)/N;
KP=(num(2)-KI)/N;
KD=(num(1)-KP)/N;
PID_IMC=zpk(KP+KI/s+(KD*N2*s)/(N2+s));
%PID_IMC=zpk(KP+KI/s+(KD*N*s)/(N+s));
figure(2)
step(feedback(PID_IMC*tf3,1))


