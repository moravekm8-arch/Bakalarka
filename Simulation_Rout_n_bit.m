clear;
clc;
close all;

%% Parametry obvodu

I0 = 10e-3;       % Proud zdroje [A]
Ro = 10e4;         % Vystupni odpor [Ohm]
C = 47e-9;       % Kapacita [F]

n_bit = 8;       % Pocet bitu ADC


%rozsahy napětí
Vmin =-5;         
Vmax = 5;


%% ADC

pocet_kodu = 2^n_bit;                            %počet vzorku na výstupu           



%% čas simulace

t_start = 0;
t_end = Ro*C*log((I0*Ro - Vmin)/(I0*Ro - Vmax)); %t_end se upravuje podle parametrů

vzorku_na_kod = 1000;                       % Pocet vzorku na jeden ADC kod

pocet_vzorku = vzorku_na_kod * pocet_kodu;      % Celkovy pocet vzorku

% Casove okamziky vzorkovani
tv = linspace(t_start, t_end, pocet_vzorku).';  % Casove okamziky vzorkovani

%% Vystupni vodivost zdroje

Go = 1/Ro;

%% Reseni diferencialni rovnice

dudt = @(t,u) (I0 - Go*u)/C;

% Pocatecni podminka
u0 = Vmin; ;


[t,u] = ode45(dudt, tv, u0);

% U_vzor jsou nase vzorky pro ADC
U_vzor = u;

%% Idealni charakteristika proudoveho zdroje

uideal = Vmin + (I0/C)*t;      

%% Graf napeti

figure;

plot(t, u, 'g', 'LineWidth', 2);
hold on;

plot(t, uideal, 'r--', 'LineWidth', 2);

grid on;

xlabel('Cas t [s]');
ylabel('Napeti u(t) [V]');

title('Vystupni napeti proudoveho zdroje');

legend('Realny zdroj', 'Idealni zdroj');

ylim([Vmin Vmax])



chyba = uideal - U_vzor ;      % [V]

figure;
plot(tv, chyba, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Cas t [s]');
ylabel('Chyba napeti [V]');
title('Odchylka ideálu od vypočteného průběhu');



%% Volání funkcí DNL ADC
dnl = Function_DNL(U_vzor, Vmin, Vmax, n_bit);
INL = Function_INL(dnl);
%% Výpočet frekvence a výpisy

T_oscilatoru = 2*C*(Vmax - Vmin)/I0;          % perioda 
f_oscilatoru = 1/T_oscilatoru;                %frekvence
LSB_t   = (T_oscilatoru/2) / pocet_kodu;      % LSB v časové oblasti 

fprintf('T_oscilatoru = %.5g s\nf_oscilatoru = %.5g Hz\n', T_oscilatoru, f_oscilatoru);
fprintf('max|DNL| = %.4f LSB = %.3e s\n', max(abs(dnl),[],'omitnan'), max(abs(dnl),[],'omitnan')*LSB_t);
fprintf('max|INL| = %.4f LSB = %.3e s\n', max(abs(INL),[],'omitnan'), max(abs(INL),[],'omitnan')*LSB_t);
fprintf('Pocet bitu = %d\n', n_bit);
fprintf('Vystupni odpor = %.3g Ohm\n', Ro);
fprintf('Casove rozliseni  = %.4g s\n', LSB_t);
