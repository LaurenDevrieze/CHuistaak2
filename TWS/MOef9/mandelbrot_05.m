% MANDELBROT_05
function R_tilde=mandelbrot_05(center,radius,steps,maxiter)

Z = zeros(steps);
C = zeros(steps);
R_tilde = zeros(steps);

for n=1:steps
    for m=1:steps
        C(m,n) = real(center)-radius+2*(n-1)*radius/(steps-1) ...
           + 1i*(imag(center)-radius+2*(m-1)*radius/(steps-1));
        Z(m,n) = C(m,n);
        R_tilde(m,n) = maxiter;
    end
end
for r=1:maxiter
    [m,n] = find(abs(Z) <= 2);
    for j = 1:size(m,1)
        Z(m(j),n(j)) = Z(m(j),n(j))*Z(m(j),n(j)) + C(m(j),n(j));
        R_tilde(m(j),n(j)) = r;
    end
end
