clc; clear; close all;

% Definir la función f(x)
f = @(x) 1 + 2*x - 3*x.^2 + 4*x.^3 - 5*x.^4 + 6*x.^5;

% Intervalo
a = 0;
b = 1;

% Valor exacto calculado con integración simbólica
syms x
f_sym = 1 + 2*x - 3*x^2 + 4*x^3 - 5*x^4 + 6*x^5;
valor_real = double(int(f_sym, a, b));

% Número de subintervalos para Simpson 3/8 múltiple (debe ser múltiplo de 3)
n = 6;
if mod(n, 3) ~= 0
    error('n debe ser múltiplo de 3 para Simpson 3/8 compuesto.');
end

h = (b - a)/n;
x_vals = a:h:b;
y_vals = f(x_vals);

% Simpson 1/3 compuesto (solo si n es par)
if mod(n,2) == 0
    I_simpson13 = (h/3)*(y_vals(1) + ...
        4*sum(y_vals(2:2:end-1)) + ...
        2*sum(y_vals(3:2:end-2)) + ...
        y_vals(end));
else
    I_simpson13 = NaN;
end

% Simpson 3/8 compuesto
I_simpson38 = 0;
for i = 1:3:n
    I_simpson38 = I_simpson38 + (3*h/8)*(y_vals(i) + 3*y_vals(i+1) + 3*y_vals(i+2) + y_vals(i+3));
end

% Integral total (usamos solo Simpson 3/8 en este caso)
I_total = I_simpson38;

% Cuarta derivada simbólica
f4_sym = diff(f_sym, x, 4);
f4_fun = matlabFunction(f4_sym);

% Valor medio de f⁽⁴⁾(x)
media_f4 = integral(f4_fun, a, b)/(b - a);

% Estimación del error de truncamiento (para Simpson 3/8 múltiple)
E_t = -((b - a) * h^4 / 80) * media_f4;

% Error relativo porcentual
error_porcentual = abs((valor_real - I_total) / valor_real) * 100;

% Resultados
fprintf('=== Estimación de la integral ===\n');
fprintf('Valor exacto de la integral     : %.6f\n', valor_real);
fprintf('Integral aprox. (Simpson 1/3)   : %.6f\n', I_simpson13);
fprintf('Integral aprox. (Simpson 3/8)   : %.6f\n', I_simpson38);
fprintf('Integral aprox. total           : %.6f\n', I_total);
fprintf('Valor medio de f''''(x)           : %.6f\n', media_f4);
fprintf('Error de truncamiento estimado  : %.6f\n', E_t);
fprintf('Error relativo porcentual       : %.4f%%\n', error_porcentual);
