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


fun = @(P) sqrt((x-P(1)).^2 + (y-P(2)).^2 + (z-P(3)).^2) - t.*C;
P0 = [0; 0; 0];
P = lsqnonlin(fun, P0); 

r_p = sqrt(sum(P.^2));
disp(6378137-r_p);

theta_p = asin(P(3)/r_p);
phi_p = atan(P(2)/P(1));

theta_p = 180*theta_p/pi;
phi_p = 180*phi_p/pi;

disp(theta_p);
disp(phi_p);
