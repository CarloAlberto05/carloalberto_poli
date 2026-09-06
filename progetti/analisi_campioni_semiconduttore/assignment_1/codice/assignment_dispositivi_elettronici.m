%% Domanda 1 (diagramma a bande) es1
clc
clear
close all

Ec = importfile_equilibrium('ConductionBandPotential.txt');
Phi = importfile_equilibrium('ElectrostaticPotential-2');
EFp = importfile_equilibrium('pQuasiFermiLevel-2');
EFn = importfile_equilibrium('nQuasiFermiLevel-2');
Ev = importfile_equilibrium('ValenceBandPotential-2.txt');

%Distanza bande

Ec_EF = abs(mean(Ec(:,2)-EFp(:,2)));
EF_EFi = abs(mean(EFn(:,2)+Phi(:,2)));
EFi_Ev = abs(mean(Ev(:,2)+Phi(:,2)));
EFi = [Phi(:,1),-Phi(:,2)];

figure
hold on
plot(Ec(:,1), Ec(:,2), 'LineWidth',2)
plot(Ev(:,1), Ev(:,2), 'LineWidth',2)
plot(EFn(:,1), EFn(:,2),'b', 'LineWidth',2)
plot(EFp(:,1), EFp(:,2),'r--','LineWidth',2)
plot(EFi(:,1), EFi(:,2), 'LineWidth',2)
quota_esterna(50, 5, Ec, EFp, '$E_C - E_F = 0.14\,\mathrm{eV}$');
quota_esterna(130, 5, EFn, EFi, '$E_F - E_{Fi} = 0.43\,\mathrm{eV}$');
quota_esterna(210, 5, EFi, Ev, '$E_{Fi} - E_V = 0.55\,\mathrm{eV}$');
hold off
xlabel('x-Position, \mum') 
ylabel('Energy, eV')
legend('$E_c$','$E_v$','$E_{F_p}$','$E_{F_n}$','$E_{F_i}$', 'Interpreter', 'latex')
set(gca, 'Fontname', 'Times New Roman')
set(gca, 'Fontsize', 15)
exportgraphics(gcf, 'diagramma_a_bande.pdf', 'ContentType', 'vector');

%Dati utili
kB = 1.38064880e-23;       
q = 1.602176634e-19; 
kB_eV = kB/q;
T = 300;
N_c = 2.8e19;
N_v = 1.04e19;
E_g = 1.12;
n_i_sq = N_c*N_v*exp(-E_g*q/(kB*T));
n_0_th = 1.08e17;
p_0_th = n_i_sq/n_0_th;

Ec_EF_th = kB_eV*T*log(N_c/n_0_th);
eps_1 = 100*abs(Ec_EF_th - Ec_EF)/Ec_EF_th;

EF_EFi_th = kB_eV*T*log(n_0_th/sqrt(n_i_sq));
eps_2 = 100*abs(EF_EFi_th - EF_EFi)/EF_EFi_th;

EFi_Ev_th = kB_eV*T*log(N_v/p_0_th)-EF_EFi_th;
eps_3 = 100*abs(EFi_Ev_th - EFi_Ev)/EFi_Ev_th;


%% Domanda 2 (concentrazione di portatori) es1
clc
clear
close all

n_0 = importfile_equilibrium('ElectronConcentration.txt');
p_0 = importfile_equilibrium('HoleChargeConcentration.txt');

figure
hold on
plot(n_0(:,1), n_0(:,2), 'LineWidth', 2)
plot(p_0(:,1), p_0(:,2), 'LineWidth', 2)
hold off

xlabel('x-Position, \mum') 
ylabel('Concentration, cm^{-3}')
set(gca,'Yscale','log')
set(gca, 'Fontname', 'Times New Roman')
set(gca, 'Fontsize', 15)

% Nel codice MATLAB:
legend({'$n_0  = 1.08 \times 10^{17} \,\mathrm{cm}^{-3}$', '$p_0 = 4.12 \times 10^{2} \,\mathrm{cm}^{-3}$'}, 'Interpreter', 'latex', 'location','best')

exportgraphics(gcf, 'concentrazione_portatori.pdf', 'ContentType', 'vector');

%Errori relativi percentuali

%Dati utili
kB = 1.38064880e-23;       
q = 1.602176634e-19; 
kB_eV = kB/q;
T = 300;
N_c = 2.8e19;
N_v = 1.04e19;
E_g = 1.12;
n_i_sq = N_c*N_v*exp(-E_g*q/(kB*T));
n_0_th = 1.08e17;
p_0_th = n_i_sq/n_0_th;

num_p = max(p_0(:,2) - p_0_th);
eps_p = 100*abs(num_p)/p_0_th;

num_n = max(n_0(:,2) - n_0_th);
eps_n = 100*abs(num_n)/n_0_th;


%% Domanda 3 (Campo elettrico con V_bias) es1
clc
clear
close all

V_bias = 3;
L_x = 260;

Phi_out_eq = importfile_Phi_out_eq('ElectrostaticPotential');
coeff = polyfit(Phi_out_eq(:,1), Phi_out_eq(:,2), 1);

Electric_Field = -coeff(1,1);
Electric_Field_th = V_bias/L_x;

eps_E = abs(Electric_Field-Electric_Field_th)/Electric_Field_th;

%% Domanda 4 (caratteristica corrente-tensione) es1
clc
clear
close all

IV = importfile_V_vs_I('ivI1.txt');
V = IV(:,1);
I = IV(:,2);
coeff = polyfit(V,I,1);
G = coeff(1,1);
R = 1/G;
v_for_interpolation = linspace(0,3,100);

figure
hold on
plot(v_for_interpolation, polyval(coeff,v_for_interpolation),'-k','LineWidth',2)
plot(V,I,'o','LineWidth',2)
xlabel('V_{bias}, V')
ylabel('I, A')
legend(['linear interpolation: R_{num} = ', num2str(R), ' \Omega'], 'Padre output data', 'Location','best')
set(gca, 'Fontsize', 15)
set(gca, 'Fontname', 'Times New Roman')
exportgraphics(gcf, 'caratteristica_IV.pdf', 'ContentType', 'vector');

cond = 1.08e17*722*1.602176634e-19;
R_th = (260e-4)/((1e-1)*(200e-4)*cond);

eps_R = abs(R-R_th)/R_th;

%% Domanda 1 (Portatori in eccesso) es2
clc
clear
close all

n_light_ok = import_n_light('ElectronConcentration_ok.txt');
p_light_ok = importfile_ok('HoleChargeConcentration_ok.txt');
n_0 = importfile_equilibrium('ElectronConcentration.txt');
p_0 = importfile_equilibrium('HoleChargeConcentration.txt');

n_prime_ = (n_light_ok(:,2)-n_0(1,2));
p_prime_ = (p_light_ok(:,2)-p_0(1,2));

n_prime_norm = n_prime_/max(p_prime_);
p_prime_norm = p_prime_/max(p_prime_);

figure 
hold on
plot(n_light_ok(:,1),n_prime_norm,'b', 'LineWidth', 2)
plot(p_light_ok(:,1),p_prime_norm,'--r', 'LineWidth', 2)
hold off
xlabel('x-Position, \mum')
ylabel('Excess carrier density normalized')
legend("\delta_n", "\delta_p")
set(gca, 'Fontsize', 15)
set(gca, 'Fontname', 'Times New Roman')
exportgraphics(gcf, 'confronto_eccessi.pdf', 'ContentType', 'vector');

%% Domanda 1bis (confronto con la teoria) es2
clc
clear
close all

V_T = 25.85e-3;
mu_p = 210;
tau_p = 1e-6;

p_light = import_p_light('HoleChargeConcentration_ok');
p_0 = importfile_equilibrium('HoleChargeConcentration.txt');

p_prime = (p_light(:,2)-p_0(1,2));
p_prime0 = max(p_prime);
p_prime_norm = p_prime/p_prime0;


L_p = sqrt(V_T*mu_p*tau_p);
L_p_um = L_p * 1e4;

x = linspace(0,260, 100);

p_prime_th_norm = exp(-p_light(:,1)/L_p_um);

figure
hold on
plot(p_light(:,1),p_prime_norm,'b', 'LineWidth', 2)
plot(p_light(:,1),p_prime_th_norm,'--r', 'LineWidth', 2)
hold off
xlabel('x-Position, \mum')
ylabel('Hole density excess normalized')
legend("PADRE data, \delta_p", "Theorical calculations, \delta_p^{th}")
set(gca, 'Fontsize', 15)
set(gca, 'Fontname', 'Times New Roman')
exportgraphics(gcf, 'confronto_eccessi_teoria.pdf', 'ContentType', 'vector');

%% Domanda 2a (corto) es2
clc
clear
close all

n_light = import_light_corto('ElectronConcentration_corto_ok');
p_light = import_light_corto('HoleChargeConcentration_corto_ok');
n_0 = importfile_equilibrium('ElectronConcentration.txt');
p_0 = importfile_equilibrium('HoleChargeConcentration.txt');

p_prime = (p_light(:,2)-p_0(1,2));
n_prime = (n_light(:,2)-n_0(1,2));
n_prime_norm = n_prime / max(p_prime);
p_prime_norm = p_prime / max(p_prime);

figure 
hold on
plot(n_light(:,1),n_prime_norm,'b', 'LineWidth', 2)
plot(p_light(:,1),p_prime_norm,'--r', 'LineWidth', 2)
hold off
xlabel('x-Position, \mum')
ylabel('Excess carrier density normalized')
legend("\delta_n", "\delta_p")
set(gca, 'Fontsize', 15)
set(gca, 'Fontname', 'Times New Roman')
exportgraphics(gcf, 'confronto_eccessi_corto.pdf', 'ContentType', 'vector');

%% Domanda 2b (medio) es2
clc
clear
close all

n_light = import_light_corto('ElectronConcentration_medio_ok');
p_light = import_light_corto('HoleChargeConcentration_medio_ok');
n_0 = importfile_equilibrium('ElectronConcentration.txt');
p_0 = importfile_equilibrium('HoleChargeConcentration.txt');

n_prime = (n_light(:,2)-n_0(1,2));
p_prime = (p_light(:,2)-p_0(1,2));
n_prime_norm = n_prime / max(p_prime);
p_prime_norm = p_prime / max(p_prime);

figure 
hold on
plot(n_light(:,1),n_prime_norm,'b', 'LineWidth', 2)
plot(p_light(:,1),p_prime_norm,'--r', 'LineWidth', 2)
hold off
xlabel('x-Position, \mum')
ylabel('Excess carrier density normalized')
legend("\delta_n", "\delta_p")
set(gca, 'Fontsize', 15)
set(gca, 'Fontname', 'Times New Roman')
exportgraphics(gcf, 'confronto_eccessi_medio.pdf', 'ContentType', 'vector');

%% Domanda 2b (lungo) es2
clc
clear
close all

n_light = importfile_lungo_ok('ElectronConcentration_lungo_ok');
p_light = importfile_lungo_ok('HoleChargeConcentration_lungo_ok');
n_0 = importfile_equilibrium('ElectronConcentration.txt');
p_0 = importfile_equilibrium('HoleChargeConcentration.txt');

n_prime = (n_light(:,2)-n_0(1,2));
p_prime = (p_light(:,2)-p_0(1,2));
n_prime_norm = n_prime / max(p_prime);
p_prime_norm = p_prime / max(p_prime);

figure 
hold on
plot(n_light(:,1),n_prime_norm,'b', 'LineWidth', 2)
plot(p_light(:,1),p_prime_norm,'--r', 'LineWidth', 2)
hold off
xlabel('x-Position, \mum')
ylabel('Excess carrier density normalized')
legend("\delta_n", "\delta_p")
set(gca, 'Fontsize', 15)
set(gca, 'Fontname', 'Times New Roman')
exportgraphics(gcf, 'confronto_eccessi_lungo.pdf', 'ContentType', 'vector');