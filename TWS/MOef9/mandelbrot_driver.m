% MANDELBROT_DRIVER

% Lauren Devrieze

% Time spent: 4-5 Hours

% Disussion of the results:
%   To calculate the timings the function timeit was used since it calls
%   the function several times and takes the median of it to get more
%   accurate results.
%   For the steps in the graph different powers of 2 are used to show how
%   much the time increases when the steps are doubled. The trend of the
%   increasing values is mostly a straight line and if you check the values
%   and the axis it seems like the time quadruples when the steps double,
%   but not perfectly since the curve is lightly convex. The complexity
%   would then be around log(N)N^2 with N the number of steps.
clear variables;

%% Parameters for an interesting part of the complex space
center  = -0.7465 + 0.1240i;
radius  = 0.0037;
maxiter = 64;

%% Calculate for a range of revisions
it = 0;
for steps = [2^5,2^6,2^7,2^8,2^9]
    it = it+1;
    % ranges
    xr = real(center)+linspace(-radius,radius,steps);
    yr = imag(center)+linspace(-radius,radius,steps);
    revisions = [0:9, 99]; % Change this when you make a new revision.
    R_tilde_ref = mandelbrot_99(center,radius,steps,maxiter);
    for revisioni = 1:numel(revisions)
        % Select the revision and the corresponding function
        revision = revisions(revisioni);
        mandelbrot_fun = str2func(sprintf('mandelbrot_%02i',revision));
        fprintf('- Testing %s ... \n',func2str(mandelbrot_fun));

        % Run the function
        f = @() mandelbrot_fun(center,radius,steps,maxiter);
        time(revisioni,it) = timeit(f);
    end
end
steps = [2^5,2^6,2^7,2^8,2^9];
%% Create a figure with the timings
figure;
for revisioni = 1:numel(revisions)
    plot(log2(steps),log2(time(revisioni,:)))
    xt = get(gca, 'XTick');
    set (gca, 'XTickLabel', 2.^xt);
    yt = get(gca, 'YTick');
    set (gca, 'YTickLabel', 2.^yt);
    hold on
end
legend('00','01','02','03','04','05','06','07','08','09','99','location','northwest');
xlabel('Steps')
ylabel('time (s)')


