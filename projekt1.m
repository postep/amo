global x y z t C;
theta = [52.885907, 50.312052, 47.796902, 50.619584, 55.488272]';
phi = [13.395837, 12.373351, 19.381854, 26.244260, 28.787526]';
r = ones(5, 1)*(20000000+6378137);
t = [6.682429390839004e-02, 6.685478411281451e-02, 6.677408432931993e-02, 6.675473676173512e-02, 6.686718394900611e-02]';
C = 299792458;
theta = pi*theta/180;
phi = pi*phi/180;

x = r.*cos(theta).*cos(phi);
y = r.*cos(theta).*sin(phi);
z = r.*sin(theta);

P0 = [0; 0; 0];
options = optimoptions('lsqnonlin','Display','iter');
options.Algorithm = 'levenberg-marquardt';
options.SpecifyObjectiveGradient = true;
%options.FunctionTolerance = 1e-80;
[P,resnorm,residual,exitflag,output] = lsqnonlin(@fun, P0, [], [], options)

r_p = sqrt(sum(P.^2));

theta_p = asin(P(3)/r_p);
phi_p = atan(P(2)/P(1));

theta_p = 180*theta_p/pi;
phi_p = 180*phi_p/pi;

disp(r_p-6378137);
theta_p
phi_p

function [F,J] = fun(P)
    global x y z t C;
    s = @(P) sqrt((x-P(1)).^2 + (y-P(2)).^2 + (z-P(3)).^2) - t.*C;
    F = s(P);
    if nargout > 1
        J1fun = @(P) (P(1)-x)./sqrt((x-P(1)).^2 + (y-P(2)).^2 + (z-P(3)).^2);
        J2fun = @(P) (P(2)-y)./sqrt((x-P(1)).^2 + (y-P(2)).^2 + (z-P(3)).^2);
        J3fun = @(P) (P(3)-z)./sqrt((x-P(1)).^2 + (y-P(2)).^2 + (z-P(3)).^2);
        J = [J1fun(P), J2fun(P), J3fun(P)];
    end
end

