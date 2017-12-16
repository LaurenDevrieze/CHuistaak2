% TWS: Homework 9
% Lauren Devrieze

% 4: There is no bug in the program

% 5: Self-time is time that is spent in the script itself while total
% time also includes other functions that are used in the script, for
% example mandelbrot_00 is executed

% 6: R_tilde(m,n) = r+1; is some code that is not used and can be removed.
% It is not used because R_tilde cannot be equal to 0 since R_tilde = r or
% maxiter, but only if r /= 0 since it is located in the else part of the
% conditional.

% 7: The execution time is practically the same so matlab has already
% solved this problem.

% 8: It doesn't really have much effect since the line that uses the
% complex i didn't really took much time to begin with.

% 9: For every r = 1:maxiter we know that we won't end up in the
% conditional so it's better to just place it outside the outer loop and
% change r = 0:maxiter to r = 1:maxiter. This also speeds up the code a lot
% since much time was spent checking if r was 0.

% 10: The time measurement for mandelbrot_04 is faster than mandelbrot_03
% so it does have an a effect, but it is not that big. Still it does have
% an effect so the matlab engine probably doesn't switch these internally
% and since matlab stores columwise it's better to change this.

% 11: The check is done 5760000 times and only 50991 it succeeds. That is
% only a 0.89 % succes rate. Using the alternate method almost reduces the
% execution time a lot.

% 12: This optimalisation enlongates the execution time a little bit, but
% the following optimalization will most likely solve this.

% 13 and 14: Because of earlier optimalisations there was no extra find 
% necessary to make the function work correctly. The execution time of this
% was reduced more than 2 times. This is because it changed a line of code 
% which was the bottleneck for the entire function.

% 15:
%   mandelbrot_08: make a matrix Z_temp so that the elements don't have to
%       be retrieved from the matrix 2 times for the multiplication
%   mandelbrot_09: removing the loops from the initialisation. This won't
%   have that much of an effect since it wasn't really a bottleneck.

% MANDELBROT_09
function R_tilde=mandelbrot_09(center,radius,steps,maxiter)

R_tilde = zeros(steps);
N = repmat(0:steps-1,steps,1);
M = repmat((0:steps-1).',1,steps);

C = real(center)-radius+2*N*radius/(steps-1) ...
   + 1i*(imag(center)-radius+2*M*radius/(steps-1));
Z = C;
R_tilde(:,:) = maxiter;
for r=1:maxiter
    [m,n] = find(abs(Z) <= 2);
    id = (n-1)*size(Z,1) + m;
    Z_temp = Z(id);
    Z(id) = Z_temp.*Z_temp + C(id);
    R_tilde(id) = r;
end
