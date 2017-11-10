function [x] = levinson(T,b)
%
%

% Beginvariabelen
gamma = T(1,1);
eta = -T(1,2)/T(1,1);
phi = -T(2,1)/T(1,1);
alpha = b(1)/T(1,1);

r = T(1,2:size(T,2)).';
s = T(2:size(T,1),1);

x = zeros(size(T,1),1);
y = zeros(size(T,1),1);
z = zeros(size(T,1),1);

y(1) = eta;
z(1) = phi;
x(1) = alpha;

for k = 2:size(T,1)-1
    J = rot90(eye(k-1));
    gamma = (1 - eta*phi)*gamma;
    alpha = (b(k) - s(1:k-1).'*J*x(1:k-1))/gamma;
    eta = (-r(k) - r(1:k-1).'*J*y(1:k-1))/gamma;
    phi = (-s(k) - s(1:k-1).'*J*z(1:k-1))/gamma;
    
    zprev = z(1:k-1);
    yprev = y(1:k-1);
    
    z(1:k) = [z(1:k-1);0] + [J*yprev ; 1]*phi;
    y(1:k) = [y(1:k-1);0] + [J*zprev ; 1]*eta;
    x(1:k) = x(1:k) + [J*yprev ; 1]*alpha; 
end

k = size(T,1);
J = rot90(eye(k-1));
gamma = (1 - eta*phi)*gamma;
alpha = (b(k) - s(1:k-1).'*J*x(1:k-1))/gamma;
x(1:k) = x(1:k) + [J*y(1:k-1) ; 1]*alpha;

end

