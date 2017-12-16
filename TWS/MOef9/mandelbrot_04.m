% MANDELBROT_04
function R_tilde=mandelbrot_04(center,radius,steps,maxiter)

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
    for n=1:steps
        for m=1:steps
            if R_tilde(m,n) <= maxiter
                Z(m,n) = Z(m,n)*Z(m,n) + C(m,n);
                if abs(Z(m,n)) > 2 && (R_tilde(m,n))==maxiter
                    R_tilde(m,n) = r;
                end
            end
        end
    end
end
