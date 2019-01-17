%% generowanie zbioru

a1 = 10;
b1 = 1;
a2 = -10;
b2 = 1;

lambda = 1;

r1 = a1 + (b1-a1)*rand(10, 2);
y1 = ones(10, 1);
r2 = a2 + (b2-a2)*rand(10, 2);
y2 = -ones(10, 1);
 
setX = [r1; r2];
setY = [y1; y2];

fun = @(W) W(1:2)'*W(1:2);
A = [setX, -ones(20, 1)].*repmat(-setY, [1 3]);
W = fmincon(fun, ones(3, 1), A, -ones(20, 1));

Class = setX*W(1:2) - W(3) 



clf;
hold on;
plot(r1(:,1), r1(:, 2), 'x')
plot(r2(:,1), r2(:, 2), 'x')
hold off;



%% zadanie dualne

H = diag(setY)*setX;
H = H*H';

f = -ones(20, 1);
lambda = 0.1;

lb = zeros(20, 1);
ub = ones(20, 1) /(2*20*lambda);

Aeq = setY';
beq = 0;
[C, fval] = quadprog(H, f, [], [], Aeq, beq, lb);

Wd = zeros(1, 2);

for i = 1:20
	Wd = Wd + C(i) * setY(i) * setX(i, :);
end;

greatInx = find(C > 1e-5);

bd = Wd*setX(greatInx(1), :)' - setY(greatInx(1));