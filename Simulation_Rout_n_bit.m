clear;
clc;
close all;

%% Parametry obvodu

I0 = 10e-3;       % Proud zdroje [A]
Ro = 50e5;         % Vystupni odpor [Ohm]
C = 100e-6;       % Kapacita [F]

n_bit = 8;       % Pocet bitu ADC

Uref = 3.3;       %referenční napětí 
Vmin =0;         %rozsahy ADC převodu
Vmax = 3.3;

%% ADC

pocet_kodu = 2^n_bit;                            %počet vzorku na výstupu           

LSB_ideal = (Vmax - Vmin) / pocet_kodu;          %výpočet ideálního LSB

%% čas simulace

t_start = 0;
t_end = 1;

vzorku_na_kod = 1000;                       % Pocet vzorku na jeden ADC kod

pocet_vzorku = vzorku_na_kod * pocet_kodu;      % Celkovy pocet vzorku

% Casove okamziky vzorkovani
tv = linspace(t_start, t_end, pocet_vzorku).';  % Casove okamziky vzorkovani

%% Vystupni vodivost zdroje

Go = 1/Ro;

%% Reseni diferencialni rovnice

dudt = @(t,u) (I0 - Go*u)/C;

% Pocatecni podminka
u0 = 0;


[t,u] = ode45(dudt, tv, u0);

% U_vzor jsou nase vzorky pro ADC
U_vzor = u;

%% Idealni charakteristika proudoveho zdroje

uideal = (I0/C) * t;

%% Graf napeti

figure;

plot(t, u, 'G', 'LineWidth', 2);
hold on;

plot(t, uideal, 'r--', 'LineWidth', 2);

grid on;

xlabel('Cas t [s]');
ylabel('Napeti u(t) [V]');

title('Vystupni napeti proudoveho zdroje');

legend('Realny zdroj', 'Idealni zdroj');

ylim([0 5]);



%% Volání funkcí DNL ADC
dnl = Function_DNL(U_vzor, Vmin, Vmax, n_bit);
INL = Function_INL(dnl);
%% Výpočet frekvence a výpisy

Uinf = I0*Ro;
T_real  = 2*(Ro*C*log((Uinf - Vmin)/(Uinf - Vmax)));
f_real  = 1/T_real;
fprintf('T_oscilatoru = %.4f ms\nf_oscilatoru = %.3f Hz\n', T_real*1e3, f_real);

fprintf('max|DNL| = %.4f LSB = %.3e s\n', max(abs(dnl),[],'omitnan'), max(abs(dnl),[],'omitnan')*LSB_ideal);
fprintf('max|INL| = %.4f LSB = %.3e s\n', max(abs(INL),[],'omitnan'), max(abs(INL),[],'omitnan')*LSB_ideal);
fprintf('Pocet bitu = %d\n', n_bit);
fprintf('Výstupní odpor = %d Ω', Ro);
