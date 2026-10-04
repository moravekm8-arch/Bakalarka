clear;
clc;
close all;

%% Parametry obvodu

I0 = 10e-3;       % Proud zdroje [A]
Ro = 1e3;         % Vystupni odpor [Ohm]
C = 100e-6;       % Kapacita [F]

n_bit = 8;       % Pocet bitu ADC

Uref = 3.3;       %referenční napětí 
Vmin = 0;         %rozsahy ADC převodu
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
INL = Function_INL(dnl)