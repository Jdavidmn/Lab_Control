syms KP KD KI N s S

matriz = csvread('PAMH_3Set.CSV', 1, 0);

tiempo = matriz(74:2022,1);
angulo = matriz(74:2022,2);
estimulo = matriz(74:2022,3);

tf3 = tf([5.3807], [1 0.1984 15.6570]);             % la que da el system identification
% plot(matriz(:,1), matriz(:,2));
% systemIdentification('modelo.sid');                % abre el system identification, da un porcentaje de 86%

gmax = 1.14;
gmax1 = 1.031;
T = 1.62;

delta = log(1.14/1.031);

xi = delta/(sqrt((2*pi)^2+delta^2));
k = gmax/1.7;

w = 2*pi/(T*sqrt(1-xi^2));

model = k*w^2/(s^2+2*xi*w*s+w^2);           % la que da el modelo a pata

% step(feedback(C*tf3,1));

% El control C hay que importarlo del archivo .mat (sisotool)

%------------------------------------------------------------------------

Ac = [0, 1; -tf3.denominator{1}(3), -tf3.denominator{1}(2)];

Bc = [0; tf3.numerator{1}(3)];

Cc = [1, 0];

[ Aa, Ba, Ca, Da] = tf2ss([5.3807], [1 0.1984 15.6570]);

sys = ss(Ac, Bc, Cc, 0);

As = [Ac [0; 0]; -Cc 0];

Bs = [Bc; 0];

Ms = [Bs As*Bs As^2*Bs];        % matriz de controlabilidad

rank(Ms);       % si da 3 es controlable

Ps = [-2+1.5i -2+1.5i -3];

Ks = acker(As, Bs, Ps);


% metodo de lqr

Q = [1 0 0; 0 1 0; 0 0 40];

R = 1;

Kss = lqr(As, Bs, Q, R)

% ubicacion de los polos por lqr

polos = eig(As - Bs*Kss);

Ki = -Kss(3);
Kd = Kss(2);
Kp = Kss(1);

% [Ac, Bc, Cc, Dc] = canon(A, B);


% sisotool('rlocus', tf3);

%Control PID por IMC
%[num, den]=tfdata(C,'v');
%PID=KP+KI/S+(KD*N*S)/(S+N);
%collect(PID);
%N=den(2);
%KI=num(3)/N;
%KP=(num(2)-KI)/N;
%KD=(num(1)-KP)/N;



%K = acker(Aa, Bb, [(-2 +1*i), (-2 -1*i)]);
