clear variables;


%% generowanie danych
largedata = 0
if largedata == 0
	dim = 5;
	len = 20;

	r1 = randn(len/2, dim);
	r1(:,end) = abs(r1(:, end));
	y1 = ones(len/2, 1);
	r2 = randn(len/2, dim);
	r2(:,end) = -abs(r2(:, end));
	y2 = -ones(len/2, 1);

	setX = [r1; r2];
	setY = [y1; y2];
end

%% obrobka danych saheart
largedata = 1
if largedata == 1
	heartdata = [cell2mat(saheart(:, 1:4)), strcmp(saheart(:, 5), 'Present'), cell2mat(saheart(:, 6:end))];
	heartdata(:,end) = (heartdata(:, end)-0.5)*2;
	heartdata(:,5) = (heartdata(:, 5)-0.5)*2;

	dim = size(heartdata);
	len = dim(1);
	dim = dim(2)-1;

	setX = heartdata(:, 1:end-1);
	setY = heartdata(:, end);
end


%% zadnie prymalne
options = struct('MaxFunctionEvaluations', 10000);
fun = @(W) W(1:end-1)'*W(1:end-1);
A = [setX, -ones(len, 1)].*repmat(-setY, [1 dim+1]);
W = fmincon(fun, ones(dim+1, 1), A, -ones(len, 1), [], [], [], [], [], options);

class_prim = sign(setX*W(1:end-1) - W(end));


%% zadanie dualne
H = diag(setY)*setX;
H = H*H';

f = -ones(len, 1);
lb = zeros(len, 1);

Aeq = setY';
beq = 0;
[C, fval] = quadprog(H, f, [], [], Aeq, beq, lb);

Wd = zeros(1, dim);

for i = 1:len
	Wd = Wd + C(i) * setY(i) * setX(i, :);
end;

greatInx = find(C > 1e-5);

bd = Wd*setX(greatInx(1), :)' - setY(greatInx(1));
class_dual = sign(setX*Wd' - bd);

%% porownanie zbiorow

plot([1:len], [setY, class_prim, class_dual]', 'x');
legend('dane', 'problem prymalny', 'problem dualny');
title('Porownanie klasyfikatorow');
ylim([-1.5 1.5])
xlim([0, len+1])

