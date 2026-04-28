%% PROBLEM 9.14:
% cos(x) can be approximated by Maclaurin series:
% cos(x) = sum from k=1 to inf of (-1)^(k-1) * x^((k-1)*2) / ((k-1)*2)!
% Use a midpoint break loop to find how many terms needed
% to approximate cos(2) within 1e-4 error.
% Limit iterations to maximum of 10.

x         = 2;
true_val  = cos(x);
tolerance = 1e-4;
max_iter  = 10;
approx    = 0;
k         = 1;

while k <= max_iter
    term   = (-1)^(k-1) * x^((k-1)*2) / factorial((k-1)*2);
    approx = approx + term;
    err    = abs(true_val - approx);
    fprintf('k=%d | approx=%.6f | error=%.2e\n', k, approx, err);

    if err < tolerance      % midpoint break
        break;
    end
    k = k + 1;
end

fprintf('\nTerms needed: %d\n', k);
fprintf('Approximation: %.6f\n', approx);
fprintf('True cos(2):   %.6f\n', true_val);
