syms KP KD KI N s S

tf3 = tf([5.3807], [1 0.1984 15.6570]);             % la que da el system identification

Ac = [0, 1; -tf3.denominator{1}(3), -tf3.denominator{1}(2)];

Bc = [0; tf3.numerator{1}(3)];

Cc = [1, 0];

[ Aa, Ba, Ca, Da] = tf2ss([5.3807], [1 0.1984 15.6570]);

sys = ss(Ac, Bc, Cc, 0);

%-------------------------------
%-  REI - UBICACION DE POLOS   -
%-------------------------------

As = [Ac [0; 0]; -Cc 0];

Bs = [Bc; 0];

Ps = [-2+1.5i -2-1.5i -1];
%Ps = [-2+1.5i -2-1.5i -3];
%Ps = [-2+1.5i -2-1.5i -10];

Ks = acker(As, Bs, Ps);
K12 = Ks(1:2);
K3 = -Ks(3);

