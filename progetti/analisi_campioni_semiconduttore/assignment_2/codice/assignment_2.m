clc
clear
close all

format long e

%parametri silicio
N_C = 2.8e19; %cm-3
N_V = 1.04e19; %cm-3
E_g = 1.12; %eV
T = 300; %K
k_B = 1.38064880e-23;
q = 1.60217657e-19;
V_T = k_B*T/q; %V
n_i = sqrt(N_V*N_C)*exp(-E_g/(2*V_T)); %cm-3
eps_si = 11.7*8.5418782e-14; %F cm-1

%parametri candidato
n = 12;
c = 4;

%lunghezza campione
w_n = (n+c+1)*10; %mum
w_p = w_n; %mum

%drogaggio
N_A = sqrt(n*c)*10^(17); %cm-3
N_D = n*10^(17); %cm-3
N_eq = (N_A*N_D)/(N_A+N_D); %cm-3

%tensione built in
V_bi = V_T*log(N_A*N_D/(n_i^2)); %V

%tensione bias
V_bias = n/20; %V

%dati mobilità
mu_n_max = 1360; %cm2 V-1 s-1
mu_n_min = 92; %cm2 V-1 s-1
mu_p_max = 495; %cm2 V-1 s-1
mu_p_min = 47.7; %cm2 V-1 s-1

%modello di Caughey-Thomas
alfa_n = 0.91;
alfa_p = 0.76;

N_p_ref = 6.3e16; %cm-3
N_n_ref = 1.3e17; %cm-3

%mobilità
mu_p = mu_p_min+(mu_p_max-mu_p_min)/(1+(N_A/N_p_ref)^alfa_p); %cm2 V-1 s-1
mu_n = mu_n_min+(mu_n_max-mu_n_min)/(1+(N_D/N_n_ref)^alfa_n); %cm2 V-1 s-1


%% Es.1 mobilità (pt 1)
clc
close all

%Valori drogaggio fra 1e15 e 1e19
x = linspace(1e15,1e19,1e6);

%funzioni da plottare
mu_p_plot = mu_p_min + (mu_p_max - mu_p_min) ./ (1 + (x ./ N_p_ref).^alfa_p); 
mu_n_plot = mu_n_min + (mu_n_max - mu_n_min) ./ (1 + (x ./ N_n_ref).^alfa_n);

%plot
figure
hold on

% Plot delle curve principali
plot(x, mu_n_plot, 'b', 'LineWidth', 1)
plot(x, mu_p_plot, 'r', 'LineWidth', 1)


% Impostazioni assi
grid on
set(gca, 'Xscale', 'log')
set(gca, 'Fontname', 'Times New Roman')
xlabel('Concentrazione dei droganti, cm^{-3}', 'FontSize',15)
ylabel('Mobilità, cm^2V^{-1}s^{-1}', 'FontSize',15)
legend('Elettroni (\mu_n)', 'Lacune (\mu_p)','FontSize',12,'Location', 'best')

% drogaggio N_A e N_D
xline(N_A, '--r', 'HandleVisibility', 'off'); 
xline(N_D, '--b', 'HandleVisibility', 'off');

% punti di intersezione (pallini pieni)
plot(N_A, mu_p, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 4, 'HandleVisibility', 'off');
plot(N_D, mu_n, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 4, 'HandleVisibility', 'off');

% 3. Etichette di testo
exp_NA = floor(log10(N_A));
mant_NA = N_A / (10^exp_NA);

exp_ND = floor(log10(N_D));
mant_ND = N_D / (10^exp_ND);

% --- ETICHETTE OUTPUT (Mobilità) ---
% Fattore di spostamento verticale (15%) per evitare sovrapposizioni
offset = 0.05; 

% 1. Etichetta Lacune (ROSSA)
% Posizione: Sotto il pallino.
% Soluzione: Moltiplichiamo mu_p per (1 - offset) per abbassare il testo.
% Aggiungiamo ' \quad' alla fine della stringa per staccarlo a sinistra.
text(N_A, mu_p * (1 - offset), ...
    sprintf('$\\mu_p = %.1f \\; \\mathrm{cm}^2\\mathrm{V}^{-1}\\mathrm{s}^{-1} \\quad$', mu_p), ...
    'Interpreter', 'latex', ...
    'FontSize', 11, ...
    'Color', 'r', ...
    'HorizontalAlignment', 'right', ... % Allinea a destra (il testo finisce nel punto)
    'VerticalAlignment', 'top');        % Allinea in alto (il testo "pende" dal punto)

% 2. Etichetta Elettroni (BLU)
% Posizione: Sopra il pallino.
% Soluzione: Moltiplichiamo mu_n per (1 + offset) per alzare il testo.
% Aggiungiamo '\quad ' all'inizio della stringa per staccarlo a destra.
text(N_D, mu_n * (1 + offset), ...
    sprintf('$\\quad \\mu_n = %.1f \\; \\mathrm{cm}^2\\mathrm{V}^{-1}\\mathrm{s}^{-1}$', mu_n), ...
    'Interpreter', 'latex', ...
    'FontSize', 11, ...
    'Color', 'b', ...
    'HorizontalAlignment', 'left', ...  % Allinea a sinistra (il testo inizia dal punto)
    'VerticalAlignment', 'bottom');     % Allinea in basso (il testo sta sopra il punto)

yl = ylim; 
y_pos_text = yl(1) + (yl(2)-yl(1))*0.5; % Posizionato al 5% dell'altezza del grafico

% Etichetta N_A (Rosso, verticale)
text(N_A, y_pos_text, sprintf('$N_A = %.2f \\times 10^{%d} \\; \\mathrm{cm}^{-3}$', mant_NA, exp_NA), ...
    'Interpreter', 'latex', ...
    'Rotation', 90, ...
    'FontSize', 11, 'Color', 'r', ...
    'VerticalAlignment', 'bottom');

% Etichetta N_D formattata come A.AA x 10^BB
text(N_D, y_pos_text, sprintf('$N_D = %.2f \\times 10^{%d} \\; \\mathrm{cm}^{-3}$', mant_ND, exp_ND), ...
    'Interpreter', 'latex', ...
    'Rotation', 90, ...
    'FontSize', 11, 'Color', 'b', ...
    'VerticalAlignment', 'bottom');

grid on

set(gca, 'TickLabelInterpreter', 'latex'); % Fondamentale per renderizzare x_n/x_p
set(gca, 'TickDir', 'out') % Tacche esterne
set(gca, 'LineWidth', 1.2) % Chiude il grafico 
set(gca, 'GridLineStyle', '-') % Tacche esternein un riquadro (assi dx e alto)
set(gca, 'XMinorTick', 'on')

set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'FontSize', 15)
set(gca, 'FontName', 'Computer Modern')

hold off
%exportgraphics(gcf, 'mobilità.pdf', 'ContentType', 'vector');


%% Es.2 regione svuotata (pt 2)
clc
close all

%regione svuotata eq
x_n_0 = sqrt((2*eps_si*N_eq*V_bi)/(q*N_D^2))*1e4; %mum
x_p_0 = sqrt((2*eps_si*N_eq*V_bi)/(q*N_A^2))*1e4; %mum
x_d_0 = x_p_0 + x_n_0; %mum

x_n_bias = sqrt((2*eps_si*N_eq*(V_bi-V_bias))/(q*N_D^2))*1e4; %mum
x_p_bias = sqrt((2*eps_si*N_eq*(V_bi-V_bias))/(q*N_A^2))*1e4; %mum
x_d_bias = x_p_bias + x_n_bias;

V_a = linspace(-1,V_bi,1000); %V

x_n_plot = sqrt((2*eps_si*N_eq*(V_bi-V_a))/(q*N_D^2))*1e4; %mum
x_p_plot = sqrt((2*eps_si*N_eq*(V_bi-V_a))/(q*N_A^2))*1e4; %mum
x_d_plot = x_p_plot + x_n_plot;


%plot
figure
hold on

% --- PLOT CURVE ---
plot(V_a, x_n_plot, 'b', 'LineWidth', 1)
plot(V_a, x_p_plot, 'r', 'LineWidth', 1)
plot(V_a, x_d_plot, 'k', 'LineWidth', 1)

xlim([-V_bi, V_bi])

% --- IMPOSTAZIONI ASSI ---
grid on
set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'FontSize', 15)
xlabel('Tensione di Bias, V', 'Interpreter', 'latex')
ylabel('Ampiezza della regione svuotata, $\mu \mathrm{m}$', 'Interpreter', 'latex')
legend('Regione $n$ ($x_p$)', 'Regione $p$ ($x_n$)', 'Ampiezza totale ($x_d$)', ...
    'FontSize',12,'Location', 'best', 'Interpreter', 'latex')

% --- RETTE E PUNTI (BIAS) ---
% Usa V_bias invece di 0 se hai calcolato un bias specifico
xline(0, '--k', 'HandleVisibility', 'off'); 
xline(V_bias, '--k', 'HandleVisibility', 'off'); 

%eq
plot(0, x_p_0, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 4, 'HandleVisibility', 'off');
plot(0, x_n_0, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 4, 'HandleVisibility', 'off');
plot(0, x_d_0, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4, 'HandleVisibility', 'off');

%bias
plot(V_bias, x_p_bias, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 4, 'HandleVisibility', 'off');
plot(V_bias, x_n_bias, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 4, 'HandleVisibility', 'off');
plot(V_bias, x_d_bias, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4, 'HandleVisibility', 'off');

% --- ETICHETTE DI TESTO ---
%eq
% x_p_0
exp_xp = floor(log10(x_p_0));
mant_xp = x_p_0 / (10^exp_xp);

% x_n_0
exp_xn = floor(log10(x_n_0));
mant_xn = x_n_0 / (10^exp_xn);

% x_d_0 (Totale)
exp_xd = floor(log10(x_d_0));
mant_xd = x_d_0 / (10^exp_xd);

%bias
% x_p_bias
exp_xp_b = floor(log10(x_p_bias));
mant_xp_b = x_p_bias / (10^exp_xp_b);

% x_n_bias
exp_xn_b = floor(log10(x_n_bias));
mant_xn_b = x_n_bias / (10^exp_xn_b);

% x_d_bias (Totale)
exp_xd_b = floor(log10(x_d_bias));
mant_xd_b = x_d_bias / (10^exp_xd_b);

% --- ETICHETTE DI TESTO CON NOTAZIONE SCIENTIFICA ---

% Etichetta x_p_0 (Rosso)
text(0, x_p_0, sprintf('$x_{p,0} = %.2f \\times 10^{%d} \\; \\mu \\mathrm{m}$', mant_xp, exp_xp), ...
    'Interpreter', 'latex', ...
    'FontSize', 11, 'Color', 'r', ...
    'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'top'); % Bottom sposta la scritta sopra il punto

% Etichetta x_n_0 (Blu)
text(0, x_n_0, sprintf('$x_{n,0} = %.2f \\times 10^{%d} \\; \\mu \\mathrm{m}$', mant_xn, exp_xn), ...
    'Interpreter', 'latex', ...
    'FontSize', 11, 'Color', 'b', ...
    'HorizontalAlignment', 'right', ... % Allineato a destra come richiesto
    'VerticalAlignment', 'top');    % Top sposta la scritta sotto il punto

% Etichetta x_d_0 (Nero - Totale)
text(0, x_d_0, sprintf('$x_{d,0} = %.2f \\times 10^{%d} \\; \\mu \\mathrm{m}$', mant_xd, exp_xd), ...
    'Interpreter', 'latex', ...
    'FontSize', 11, 'Color', 'k', ...
    'HorizontalAlignment', 'right', ... % Left per staccarlo dagli altri se x_d è più in alto
    'VerticalAlignment', 'top');

% Etichetta x_p_0 (Rosso)
text(V_bias, x_p_bias, sprintf('$x_{p,bias} = %.2f \\times 10^{%d} \\; \\mu \\mathrm{m}$', mant_xp_b, exp_xp_b), ...
    'Interpreter', 'latex', ...
    'FontSize', 11, 'Color', 'r', ...
    'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'top'); % Bottom sposta la scritta sopra il punto

% Etichetta x_n_0 (Blu)
text(V_bias, x_n_bias, sprintf('$x_{n,bias} = %.2f \\times 10^{%d} \\; \\mu \\mathrm{m}$', mant_xn_b, exp_xn_b), ...
    'Interpreter', 'latex', ...
    'FontSize', 11, 'Color', 'b', ...
    'HorizontalAlignment', 'right', ... % Allineato a destra come richiesto
    'VerticalAlignment', 'top');    % Top sposta la scritta sotto il punto

% Etichetta x_d_0 (Nero - Totale)
text(V_bias, x_d_bias, sprintf('$x_{d,bias} = %.2f \\times 10^{%d} \\; \\mu \\mathrm{m}$', mant_xd_b, exp_xd_b), ...
    'Interpreter', 'latex', ...
    'FontSize', 11, 'Color', 'k', ...
    'HorizontalAlignment', 'right', ... % Left per staccarlo dagli altri se x_d è più in alto
    'VerticalAlignment', 'top');

% --- ETICHETTA TENSIONE BIAS ---
yl = ylim; 
y_pos_text_eq = yl(1) + (yl(2)-yl(1))*0.8; 

text(0, y_pos_text_eq, sprintf('$V_{bias} = %.0f \\; V$', 0), ...
    'Interpreter', 'latex', ...
    'Rotation', 90, ...
    'FontSize', 11, 'Color', 'k', ...
    'VerticalAlignment', 'bottom');

yl = ylim; 
y_pos_text_bias = yl(1) + (yl(2)-yl(1))*0.6; 

text(V_bias, y_pos_text_bias, sprintf('$V_{bias} = %.2f \\; V$', V_bias), ...
    'Interpreter', 'latex', ...
    'Rotation', 90, ...
    'FontSize', 11, 'Color', 'k', ...
    'VerticalAlignment', 'bottom');

box off
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on')
set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'FontName', 'Times New Roman')
set(gca, 'LineWidth', 1)


hold off

%exportgraphics(gcf, 'ampiezza_regione_svuotamento.pdf', 'ContentType', 'vector');

%% Es. 1 Diagramma a bande, eq (pt 3)
clc
close all

Ec = pn_eq_band_diag('ConductionBandPotential.txt');
Ev = pn_eq_band_diag('ValenceBandPotential.txt');
EFn = pn_eq_band_diag('nQuasiFermiLevel.txt');
EFp = pn_eq_band_diag('pQuasiFermiLevel.txt');
Potential = pn_eq_band_diag('ElectrostaticPotential.txt');
EFi = -Potential;


%distanze energetiche

%lato n
EC_EF_n_th = V_T*log(N_C/N_D);
EF_EV_n_th = V_T*log(N_V*N_D/(n_i^2));

%lato p
EC_EF_p_th = V_T*log(N_C*N_A/(n_i^2));
EF_EV_p_th = V_T*log(N_V/N_A);



figure
hold on

xlim([-0.1, 0.1]); 

%energy bands
plot(Ec(:,1)-w_p, Ec(:,2), 'LineWidth',1)
plot(Ev(:,1)-w_p, Ev(:,2), 'LineWidth',1)
plot(EFn(:,1)-w_p, EFn(:,2),'b', 'LineWidth',1)
plot(EFp(:,1)-w_p, EFp(:,2),'r--','LineWidth',1)
plot(Potential(:,1)-w_p, EFi(:,2), 'LineWidth',1)

%delpleted region
xline(x_n_0, '--k', 'HandleVisibility', 'off'); 
xline(-x_p_0, '--k', 'HandleVisibility', 'off'); 
xline(0, '--k', 'HandleVisibility', 'off'); 

% quote
data_Ec_shifted = [Ec(:,1)-w_p, Ec(:,2)];
data_EFp_shifted = [EFp(:,1)-w_p, EFp(:,2)];
data_Ev_shifted = [Ev(:,1)-w_p, Ev(:,2)];

quota_esterna(-2.5*x_n_0, -0.005, data_Ec_shifted, data_EFp_shifted, 0.02,  '$E_{C,p} - E_{F} = 1.05\,\mathrm{eV}$');
quota_esterna(2.3*x_n_0, 0.012, data_Ec_shifted, data_EFp_shifted, 0.12, '$E_{C,n} - E_{F} = 81.4\,\mathrm{meV}$');

quota_esterna(-2.5*x_p_0, 0.005, data_EFp_shifted, data_Ev_shifted, -0.12, '$E_{F} - E_{V,p} = 70.0\,\mathrm{meV}$');
quota_esterna(2.2*x_n_0, 0.005, data_EFp_shifted, data_Ev_shifted, 0.09, '$E_{F} - E_{V,n} = 1.04\,\mathrm{eV}$');

%quote orizzontali
quota_orizzontale(-x_p_0, x_n_0, 0.3, 0.9, '$x_{d,0}$');


% --- RAPPRESENTAZIONE qV_bi (Extension Line + Quota) ---
xl = xlim;
total_width = xl(2) - xl(1);

% 2. Calcola un punto di partenza con un margine del 2% rispetto all'asse Y
margin = total_width * 0.05; 
x_start_safe = xl(1) + margin; % Parte un po' dopo il bordo sinistro

% 3. Identifica i livelli (come prima)
y_Ec_p_side = max(Ec(:,2)); 
y_Ec_n_side = min(Ec(:,2));

%pot built in
V_bi_padre = y_Ec_p_side-y_Ec_n_side;

x_arrow_pos = x_n_0 * 2.0;

% x_arrow_pos: dove metti la freccia
% min(xlim): da dove parte la linea tratteggiata (sinistra del grafico)
% y_Ec_p_side: valore alto (Ec regione p)
% y_Ec_n_side: valore basso (Ec regione n)
quota_potenziale_built_in(x_arrow_pos, x_start_safe, y_Ec_p_side, y_Ec_n_side, '$qV_{bi} = 0.97\,\mathrm{eV}$');




hold off
xlabel('Posizione-x, \mum') 
ylabel('Energia, eV')

xregion(-x_p_0, x_n_0, 'FaceColor', [0.9 0.9 0.9], 'FaceAlpha', 0.5);

legend('$E_c$','$E_v$','$E_{F_p}$','$E_{F_n}$','$E_{F_i}$','FontSize',12 ,'Interpreter', 'latex')
set(gca, 'Fontname', 'Times New Roman')

grid on
box off
set(gca, 'TickDir', 'out', 'TickLabelInterpreter', 'latex', 'FontSize', 15)

% --- PERSONALIZZAZIONE ASSE X (Solo x_p, 0, x_n) ---

% --- GESTIONE SMART DELLE TACCHE ASSE X ---

% 1. Forza l'aggiornamento del grafico per calcolare le tacche automatiche attuali
drawnow; 
current_ticks = xticks; 

% 2. Definisci le tue tacche speciali e le relative etichette
special_ticks = [-x_p_0, 0, x_n_0];
special_labels = {'$-x_{p,0}$', '0', '$x_{n,0}$'};

% 3. Unisci le tacche, rimuovendo quelle standard troppo vicine alle speciali
%    (Questo evita che un numero come 0.02 si sovrapponga a x_n se sono vicini)
range_x = max(current_ticks) - min(current_ticks);
tolerance = range_x * 0.05; % Tolleranza del 3% della larghezza totale

final_ticks = special_ticks;
final_labels = special_labels;

for i = 1:length(current_ticks)
    val = current_ticks(i);
    % Se la tacca corrente è "lontana" da tutte le tacche speciali, la teniamo
    if all(abs(val - special_ticks) > tolerance)
        final_ticks(end+1) = val;
        % Convertiamo il numero in stringa (stile 'general' rimuove zeri inutili)
        final_labels{end+1} = num2str(val, '%.2g'); 
    end
end

% 4. Ordina tacche ed etichette
[final_ticks, sort_idx] = sort(final_ticks);
final_labels = final_labels(sort_idx);

% 5. Applica al grafico
xticks(final_ticks);
xticklabels(final_labels);

% 6. Assicura che la griglia sia attiva e stilosa
grid on
set(gca, 'TickLabelInterpreter', 'latex'); % Fondamentale per renderizzare x_n/x_p


set(gca, 'GridLineStyle', '-', 'LineWidth',0.1)

set(gca, 'TickDir', 'out') % Tacche esterne
set(gca, 'LineWidth', 1.2) % Chiude il grafico in un riquadro (assi dx e alto)
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on')

% Impostazioni tipografiche
set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'FontSize', 15)
set(gca, 'FontName', 'Times New Roman')

%exportgraphics(gcf, 'en_band_diag_eq.pdf', 'ContentType', 'vector');

%% %% Es. 1 Diagramma a bande con bias, eq (pt 4)
clc
close all
Ec_bias = pn_bias_band_diag('ConductionBandPotential_bias.txt');
Ev_bias = pn_bias_band_diag('ValenceBandPotential_bias.txt');
EFn_bias = pn_bias_band_diag('nQuasiFermiLevel_bias.txt');
EFp_bias = pn_bias_band_diag('pQuasiFermiLevel_bias.txt');
Potential_bias = pn_bias_band_diag('ElectrostaticPotential_bias.txt');
EFi_bias = -Potential_bias;


figure
hold on

%energy bands
plot(Ec_bias(:,1)-w_p, Ec_bias(:,2), 'LineWidth',1)
plot(Ev_bias(:,1)-w_p, Ev_bias(:,2), 'LineWidth',1)
plot(EFn_bias(:,1)-w_p, -EFn_bias(:,2),'b--', 'LineWidth',1)
plot(EFp_bias(:,1)-w_p, -EFp_bias(:,2),'r--','LineWidth',1)
plot(Potential_bias(:,1)-w_p, EFi_bias(:,2), 'LineWidth',1)

%delpleted region
xline(x_n_bias, '--k', 'HandleVisibility', 'off'); 
xline(-x_p_bias, '--k', 'HandleVisibility', 'off'); 
xline(0, '--k', 'HandleVisibility', 'off'); 

xlim([-0.1, 0.1]); 
ylim([-1.5,1.5]);

%distanze energetiche

%lato p
EFi_EFp_th_p = V_T*log(N_A/n_i);
n_p_xp = n_i^2/N_A*(exp(V_bias/V_T));
EFn_Efi_th_p = -V_T*log(n_p_xp/n_i);

EC_EFi_th = V_T*log(N_C/n_i);
EFi_EV_th = V_T*log(N_V/n_i);
EC_EFn_th_p = EC_EFi_th + EFn_Efi_th_p
EFp_EV_p_th = EFi_EV_th - EFi_EFp_th_p

%lato n
p_n_xn = n_i^2/N_D*(exp(V_bias/V_T));
EFi_EFp_th_n = -V_T*log(n_p_xp/n_i);
EFn_Efi_th_n = V_T*log(N_D/n_i);

EC_EFn_th_n = EC_EFi_th - EFn_Efi_th_n
EFp_EV_n_th = EFi_EV_th + EFi_EFp_th_n

% quote
data_Ec_shifted_bias = [Ec_bias(:,1)-w_p, Ec_bias(:,2)];
data_EFp_shifted_bias = [EFp_bias(:,1)-w_p, -EFp_bias(:,2)];
data_Ev_shifted_bias = [Ev_bias(:,1)-w_p, Ev_bias(:,2)];
data_EFn_shifted_bias = [EFn_bias(:,1)-w_p, -EFn_bias(:,2)];

quota_esterna(-6*x_n_bias, 0.005, data_Ec_shifted_bias, data_EFn_shifted_bias, 0,  '$E_{C,p} - E_{F_n} = 0.450\,\mathrm{eV}$');
quota_esterna(3.5*x_n_bias, 0.012, data_Ec_shifted_bias, data_EFn_shifted_bias, -0.1, '$E_{C,n} - E_{F_n} = 81.4\,\mathrm{meV}$');

quota_esterna(-3*x_n_bias, -0.012, data_EFp_shifted_bias, data_Ev_shifted_bias, -0.1,  '$E_{F_p} - E_{V,p} = 70.0\,\mathrm{meV}$');
quota_esterna(6*x_n_bias, -0.005, data_EFp_shifted_bias, data_Ev_shifted_bias, 0, '$E_{F_p} - E_{V,n} = 0.438\,\mathrm{eV}$');

quota_esterna(0.018, 0.005, data_EFn_shifted_bias, data_EFp_shifted_bias, 0, '$E_{F_n} - E_{F_p} = 0.60\,\mathrm{eV}$');

xregion(-x_p_bias, x_n_bias, 'FaceColor', [0.9 0.9 0.9], 'FaceAlpha', 0.5);

%quote orizzontali
quota_orizzontale(-x_p_bias, x_n_bias, 0.4, 0.2, '$x_{d,bias}$');

% --- RAPPRESENTAZIONE qV_bi (Extension Line + Quota) ---
xl = xlim;
total_width = xl(2) - xl(1);
% 
%2. Calcola un punto di partenza con un margine del 2% rispetto all'asse Y
margin = total_width * 0.05; 
x_start_safe = xl(1) + margin; % Parte un po' dopo il bordo sinistro
% 
% 3. Identifica i livelli (come prima)
y_Ec_p_side_bias = max(Ec_bias(:,2)); 
y_Ec_n_side_bias = min(Ec_bias(:,2));

%pot built in
V_bi_padre_bias = y_Ec_p_side_bias-y_Ec_n_side_bias;
% 
x_arrow_pos_bias = x_n_0 *1.5;
if x_arrow_pos_bias > xl(2), x_arrow_pos_bias = xl(2) * 0.9; end
% 
quota_potenziale_built_in(x_arrow_pos_bias, x_start_safe, y_Ec_p_side_bias, y_Ec_n_side_bias, '$q(V_{bi}-V_{bias}) = 0.37\,\mathrm{eV}$');

hold off
xlabel('Posizione-x, \mum') 
ylabel('Energia, eV')

legend('$E_C$','$E_V$','$E_{F_n}$','$E_{F_p}$','$E_{F_i}$','FontSize',12, 'Interpreter', 'latex')
set(gca, 'Fontname', 'Times New Roman')
set(gca, 'Fontsize', 15)
% 
grid on
box off
set(gca, 'TickDir', 'out', 'TickLabelInterpreter', 'latex', 'FontSize', 12)

% --- PERSONALIZZAZIONE ASSE X (Solo x_p, 0, x_n) ---

% --- GESTIONE SMART DELLE TACCHE ASSE X ---

% 1. Forza l'aggiornamento del grafico per calcolare le tacche automatiche attuali
drawnow; 
current_ticks = xticks; 

% 2. Definisci le tue tacche speciali e le relative etichette
special_ticks = [-x_p_bias, 0, x_n_bias];
special_labels = {'$-x_{p_{bias}}$', '0', '$x_{n_{bias}}$'};

% 3. Unisci le tacche, rimuovendo quelle standard troppo vicine alle speciali
%    (Questo evita che un numero come 0.02 si sovrapponga a x_n se sono vicini)
range_x = max(current_ticks) - min(current_ticks);
tolerance = range_x * 0.05; % Tolleranza del 3% della larghezza totale

final_ticks = special_ticks;
final_labels = special_labels;

for i = 1:length(current_ticks)
    val = current_ticks(i);
    % Se la tacca corrente è "lontana" da tutte le tacche speciali, la teniamo
    if all(abs(val - special_ticks) > tolerance)
        final_ticks(end+1) = val;
        % Convertiamo il numero in stringa (stile 'general' rimuove zeri inutili)
        final_labels{end+1} = num2str(val, '%.2g'); 
    end
end

% 4. Ordina tacche ed etichette
[final_ticks, sort_idx] = sort(final_ticks);
final_labels = final_labels(sort_idx);

% 5. Applica al grafico
xticks(final_ticks);
xticklabels(final_labels);

% 6. Assicura che la griglia sia attiva e stilosa
grid on
set(gca, 'TickLabelInterpreter', 'latex'); % Fondamentale per renderizzare x_n/x_p
set(gca, 'TickDir', 'out') % Tacche esterne
set(gca, 'LineWidth', 1.2) % Chiude il grafico in un riquadro (assi dx e alto)
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on')

set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'FontSize', 15)
set(gca, 'FontName', 'Times New Roman')

%exportgraphics(gcf, 'en_band_diag_bias.pdf', 'ContentType', 'vector');



%% Es.1 Potenziale eq (pt 5)
clc
close all

Potential = pn_eq_band_diag('ElectrostaticPotential.txt');

fattore_trasl = 1.368813372080000e-01;


x_depl_p = linspace(-x_p_0,0, 1000);
x_neu_p = linspace(-w_p,-x_p_0, 1000);
x_depl_n = linspace(0,x_n_0, 1000);
x_neu_n = linspace(x_n_0,w_n, 1000);

% 1. Pre-allocazione del vettore risultato (es. con NaN o zeri)
y_depl_p = zeros(size(x_depl_p)); 
y_depl_p = (q*N_A)/(2*eps_si)*(x_depl_p.*10^(-4)+(x_p_0*10^(-4))).^2 - (q*N_A)/(2*eps_si)*(x_p_0*10^(-4))^2;

y_neu_p = zeros(size(x_neu_p)); 
y_neu_p(1,:) = - (q*N_A)/(2*eps_si)*(x_p_0*10^(-4))^2;

y_depl_n = zeros(size(x_depl_p)); 
y_depl_n = -(q*N_D)/(2*eps_si)*(x_depl_n.*10^(-4)-(x_n_0*10^(-4))).^2 + (q*N_D)/(2*eps_si)*(x_n_0*10^(-4))^2;

y_neu_n = zeros(size(x_neu_p)); 
y_neu_n(1,:) = + (q*N_D)/(2*eps_si)*(x_n_0*10^(-4))^2;

figure
hold on
plot(Potential(:,1)-w_p, Potential(:,2) - fattore_trasl,'r', 'LineWidth',1.2)
plot(x_neu_p,y_neu_p,'b', 'LineWidth',1.2)
plot(x_depl_p,y_depl_p,'b', 'LineWidth',1.2)
plot(x_depl_n,y_depl_n,'b', 'LineWidth',1.2)
plot(x_neu_n,y_neu_n,'b', 'LineWidth',1.2)
xlim([-0.1, 0.1]); 
ylim([-0.8, 0.6]); 
hold off

xlabel('Posizione-x, \mum') 
ylabel('Potenziale elettrostatico, V')

legend('$\varphi_{0}$ Simulazione Padre','$\varphi_{0}$ Modello teorico','FontSize',12, 'Interpreter', 'latex')

xregion(-x_p_0, x_n_0, 'FaceColor', [0.9 0.9 0.9], ...
    'FaceAlpha', 0.5, 'HandleVisibility', 'off');
xline(x_n_0, '--k', 'HandleVisibility', 'off'); 
xline(-x_p_0, '--k', 'HandleVisibility', 'off'); 
xline(0, '--k', 'HandleVisibility', 'off'); 

% 1. Forza l'aggiornamento del grafico per calcolare le tacche automatiche attuali
drawnow; 
current_ticks = xticks; 

% 2. Definisci le tue tacche speciali e le relative etichette
special_ticks = [-x_p_0, 0, x_n_0];
special_labels = {'$-x_{p,0}$', '0', '$x_{n,0}$'};

% 3. Unisci le tacche, rimuovendo quelle standard troppo vicine alle speciali
%    (Questo evita che un numero come 0.02 si sovrapponga a x_n se sono vicini)
range_x = max(current_ticks) - min(current_ticks);
tolerance = range_x * 0.05; % Tolleranza del 3% della larghezza totale

final_ticks = special_ticks;
final_labels = special_labels;

for i = 1:length(current_ticks)
    val = current_ticks(i);
    % Se la tacca corrente è "lontana" da tutte le tacche speciali, la teniamo
    if all(abs(val - special_ticks) > tolerance)
        final_ticks(end+1) = val;
        % Convertiamo il numero in stringa (stile 'general' rimuove zeri inutili)
        final_labels{end+1} = num2str(val, '%.2g'); 
    end
end

% 4. Ordina tacche ed etichette
[final_ticks, sort_idx] = sort(final_ticks);
final_labels = final_labels(sort_idx);

% 5. Applica al grafico
xticks(final_ticks);
xticklabels(final_labels);

% 6. Assicura che la griglia sia attiva e stilosa
grid on

set(gca, 'TickLabelInterpreter', 'latex'); % Fondamentale per renderizzare x_n/x_p
set(gca, 'TickDir', 'out') % Tacche esterne
set(gca, 'LineWidth', 1.2) % Chiude il grafico in un riquadro (assi dx e alto)
set(gca, 'XMinorTick', 'on')

set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'FontSize', 15)
set(gca, 'FontName', 'Times New Roman')

exportgraphics(gcf, 'potential_equilibrium.pdf', 'ContentType', 'vector');




%% %% Es.1 Potenziale con bias (pt 5)
clc
close all

Potential_bias = pn_bias_band_diag('ElectrostaticPotential_bias.txt');

fattore_trasl = 0.356445670776;


x_depl_p_bias = linspace(-x_p_bias,0, 1000);
x_neu_p_bias = linspace(-w_p,-x_p_bias, 1000);
x_depl_n_bias = linspace(0,x_n_bias, 1000);
x_neu_n_bias = linspace(x_n_bias,w_n, 1000);


y_depl_p_bias = zeros(size(x_depl_p_bias)); 
y_depl_p_bias = (q*N_A)/(2*eps_si)*(x_depl_p_bias.*10^(-4)+(x_p_bias*10^(-4))).^2 - (q*N_A)/(2*eps_si)*(x_p_bias*10^(-4))^2;

y_neu_p_bias = zeros(size(x_neu_p_bias)); 
y_neu_p_bias(1,:) = - (q*N_A)/(2*eps_si)*(x_p_bias*10^(-4))^2;

y_depl_n_bias = zeros(size(x_depl_p_bias)); 
y_depl_n_bias = -(q*N_D)/(2*eps_si)*(x_depl_n_bias.*10^(-4)-(x_n_bias*10^(-4))).^2 + (q*N_D)/(2*eps_si)*(x_n_bias*10^(-4))^2;

y_neu_n_bias = zeros(size(x_neu_p_bias)); 
y_neu_n_bias(1,:) = + (q*N_D)/(2*eps_si)*(x_n_bias*10^(-4))^2;

figure
hold on
plot(Potential_bias(:,1)-w_p, Potential_bias(:,2) - fattore_trasl,'r', 'LineWidth',1.2)
plot(x_neu_p_bias,y_neu_p_bias,'b', 'LineWidth',1.2)
plot(x_depl_p_bias,y_depl_p_bias,'b', 'LineWidth',1.2)
plot(x_depl_n_bias,y_depl_n_bias,'b', 'LineWidth',1.2)
plot(x_neu_n_bias,y_neu_n_bias,'b', 'LineWidth',1.2)
xlim([-0.1, 0.1]); 
hold off

xlabel('Posizione-x, \mum') 
ylabel('Potenziale elettrostatico, V')

legend('$\varphi_{bias}$ Simulazione Padre','$\varphi_{bias}$ Modello teorico','FontSize',12, 'Interpreter', 'latex')
ylim([-0.8,0.6])
xregion(-x_p_bias, x_n_bias, 'FaceColor', [0.9 0.9 0.9], ...
    'FaceAlpha', 0.5, 'HandleVisibility', 'off');
xline(x_n_bias, '--k', 'HandleVisibility', 'off'); 
xline(-x_p_bias, '--k', 'HandleVisibility', 'off'); 
xline(0, '--k', 'HandleVisibility', 'off'); 

% 1. Forza l'aggiornamento del grafico per calcolare le tacche automatiche attuali
drawnow; 
current_ticks = xticks; 

% 2. Definisci le tue tacche speciali e le relative etichette
special_ticks = [-x_p_bias, 0, x_n_bias];
special_labels = {'$-x_{p_{bias}}$', '0', '$x_{n_{bias}}$'};

% 3. Unisci le tacche, rimuovendo quelle standard troppo vicine alle speciali
%    (Questo evita che un numero come 0.02 si sovrapponga a x_n se sono vicini)
range_x = max(current_ticks) - min(current_ticks);
tolerance = range_x * 0.05; % Tolleranza del 3% della larghezza totale

final_ticks = special_ticks;
final_labels = special_labels;

for i = 1:length(current_ticks)
    val = current_ticks(i);
    % Se la tacca corrente è "lontana" da tutte le tacche speciali, la teniamo
    if all(abs(val - special_ticks) > tolerance)
        final_ticks(end+1) = val;
        % Convertiamo il numero in stringa (stile 'general' rimuove zeri inutili)
        final_labels{end+1} = num2str(val, '%.2g'); 
    end
end

% 4. Ordina tacche ed etichette
[final_ticks, sort_idx] = sort(final_ticks);
final_labels = final_labels(sort_idx);

% 5. Applica al grafico
xticks(final_ticks);
xticklabels(final_labels);

% 6. Assicura che la griglia sia attiva e stilosa

set(gca, 'TickLabelInterpreter', 'latex'); % Fondamentale per renderizzare x_n/x_p
set(gca, 'TickDir', 'out') % Tacche esterne
set(gca, 'LineWidth', 1.2) % Chiude il grafico in un riquadro (assi dx e alto)
set(gca, 'XMinorTick', 'on')

set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'FontSize', 15)
set(gca, 'FontName', 'Times New Roman')

grid on

exportgraphics(gcf, 'potential_bias.pdf', 'ContentType', 'vector');

%% %% Es.1 Campo Elettrostatico eq (pt 6)

campo_el_eq = pn_eq_band_diag('ElectricField.txt');

y_depl_p_E = zeros(size(x_depl_p)); 
y_depl_p_E = -(q*N_A)/eps_si*(x_depl_p.*10^(-4) + x_p_0*10^(-4));

y_neu_p_E = zeros(size(x_neu_p)); 
y_neu_p_E(1,:) = 0;

y_depl_n_E = zeros(size(x_depl_p)); 
y_depl_n_E = (q*N_D)/eps_si*(x_depl_n.*10^(-4) - x_n_0*10^(-4));

y_neu_n_E = zeros(size(x_neu_p)); 
y_neu_n_E(1,:) = 0;

figure 
hold on
plot(campo_el_eq(:,1)-w_p, campo_el_eq(:,2),'r', 'LineWidth',1.2)
plot(x_neu_p,y_neu_p_E,'b', 'LineWidth',1.2)
plot(x_depl_p,y_depl_p_E,'b', 'LineWidth',1.2)
plot(x_depl_n,y_depl_n_E,'b', 'LineWidth',1.2)
plot(x_neu_n,y_neu_n_E,'b', 'LineWidth',1.2)



xlim([-0.1, 0.1]); 
ylim([-4e5, 0.1e5]); 

xlabel('Posizione-x, \mum') 
ylabel('Campo elettrostatico, Vcm^{-1}')

legend('$\mathcal{E}_{eq}$ Simulaziome Padre','$\mathcal{E}_{eq}$ Modello teorico','FontSize',12, 'Interpreter', 'latex','Location', 'best')

xregion(-x_p_0, x_n_0, 'FaceColor', [0.9 0.9 0.9], ...
    'FaceAlpha', 0.5, 'HandleVisibility', 'off');
xline(x_n_0, '--k', 'HandleVisibility', 'off'); 
xline(-x_p_0, '--k', 'HandleVisibility', 'off'); 
xline(0, '--k', 'HandleVisibility', 'off'); 

% 1. Forza l'aggiornamento del grafico per calcolare le tacche automatiche attuali
drawnow; 
current_ticks = xticks; 

% 2. Definisci le tue tacche speciali e le relative etichette
special_ticks = [-x_p_0, 0, x_n_0];
special_labels = {'$-x_{p,0}$', '0', '$x_{n,0}$'};

% 3. Unisci le tacche, rimuovendo quelle standard troppo vicine alle speciali
%    (Questo evita che un numero come 0.02 si sovrapponga a x_n se sono vicini)
range_x = max(current_ticks) - min(current_ticks);
tolerance = range_x * 0.05; % Tolleranza del 3% della larghezza totale

final_ticks = special_ticks;
final_labels = special_labels;

for i = 1:length(current_ticks)
    val = current_ticks(i);
    % Se la tacca corrente è "lontana" da tutte le tacche speciali, la teniamo
    if all(abs(val - special_ticks) > tolerance)
        final_ticks(end+1) = val;
        % Convertiamo il numero in stringa (stile 'general' rimuove zeri inutili)
        final_labels{end+1} = num2str(val, '%.2g'); 
    end
end

% 4. Ordina tacche ed etichette
[final_ticks, sort_idx] = sort(final_ticks);
final_labels = final_labels(sort_idx);

% 5. Applica al grafico
xticks(final_ticks);
xticklabels(final_labels);

% 6. Assicura che la griglia sia attiva e stilosa
grid on

set(gca, 'TickLabelInterpreter', 'latex'); % Fondamentale per renderizzare x_n/x_p
set(gca, 'TickDir', 'out') % Tacche esterne
set(gca, 'LineWidth', 1.2) % Chiude il grafico in un riquadro (assi dx e alto)
set(gca, 'XMinorTick', 'on')

set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'FontSize', 15)
set(gca, 'FontName', 'Times New Roman')

hold off

exportgraphics(gcf, 'campo_el_eq.pdf', 'ContentType', 'vector');

%% %% Es.1 Campo Elettrostatico bias (pt 6)

campo_el_bias = pn_bias_band_diag('ElectricField_bias.txt');

y_depl_p_E_bias = zeros(size(x_depl_p_bias)); 
y_depl_p_E_bias = -(q*N_A)/eps_si*(x_depl_p_bias.*10^(-4) + x_p_bias*10^(-4))

y_neu_p_E_bias = zeros(size(x_neu_p_bias)); 
y_neu_p_E_bias(1,:) = 0;

y_depl_n_E_bias = zeros(size(x_depl_p_bias)); 
y_depl_n_E_bias = (q*N_D)/eps_si*(x_depl_n_bias.*10^(-4) - x_n_bias*10^(-4));

y_neu_n_E_bias = zeros(size(x_neu_p_bias)); 
y_neu_n_E_bias(1,:) = 0;

figure 
hold on
plot(campo_el_bias(:,1)-w_p, campo_el_bias(:,2),'r', 'LineWidth',1.2)
plot(x_neu_p_bias,y_neu_p_E_bias,'b', 'LineWidth',1.2)
plot(x_depl_p_bias,y_depl_p_E_bias,'b', 'LineWidth',1.2)
plot(x_depl_n_bias,y_depl_n_E_bias,'b', 'LineWidth',1.2)
plot(x_neu_n_bias,y_neu_n_E_bias,'b', 'LineWidth',1.2)



xlim([-0.1, 0.1]); 
ylim([-2.5e5, 0.1e5]); 

xlabel('Posizione-x, \mum') 
ylabel('Campo elettrostatico, Vcm^{-1}')

legend('$\mathcal{E}_{bias}$ Simulazione Padre','$\mathcal{E}_{bias}$ Modello teorico', 'FontSize',12, 'Interpreter', 'latex','Location', 'best')

xregion(-x_p_bias, x_n_bias, 'FaceColor', [0.9 0.9 0.9], ...
    'FaceAlpha', 0.5, 'HandleVisibility', 'off');
xline(x_n_bias, '--k', 'HandleVisibility', 'off'); 
xline(-x_p_bias, '--k', 'HandleVisibility', 'off'); 
xline(0, '--k', 'HandleVisibility', 'off'); 

% 1. Forza l'aggiornamento del grafico per calcolare le tacche automatiche attuali
drawnow; 
current_ticks = xticks; 

% 2. Definisci le tue tacche speciali e le relative etichette
special_ticks = [-x_p_bias, 0, x_n_bias];
special_labels = {'$-x_{p_{bias}}$', '0', '$x_{n_{bias}}$'};

% 3. Unisci le tacche, rimuovendo quelle standard troppo vicine alle speciali
%    (Questo evita che un numero come 0.02 si sovrapponga a x_n se sono vicini)
range_x = max(current_ticks) - min(current_ticks);
tolerance = range_x * 0.05; % Tolleranza del 3% della larghezza totale

final_ticks = special_ticks;
final_labels = special_labels;

for i = 1:length(current_ticks)
    val = current_ticks(i);
    % Se la tacca corrente è "lontana" da tutte le tacche speciali, la teniamo
    if all(abs(val - special_ticks) > tolerance)
        final_ticks(end+1) = val;
        % Convertiamo il numero in stringa (stile 'general' rimuove zeri inutili)
        final_labels{end+1} = num2str(val, '%.2g'); 
    end
end

% 4. Ordina tacche ed etichette
[final_ticks, sort_idx] = sort(final_ticks);
final_labels = final_labels(sort_idx);

% 5. Applica al grafico
xticks(final_ticks);
xticklabels(final_labels);

% 6. Assicura che la griglia sia attiva e stilosa
grid on

set(gca, 'TickLabelInterpreter', 'latex'); % Fondamentale per renderizzare x_n/x_p
set(gca, 'TickDir', 'out') % Tacche esterne
set(gca, 'LineWidth', 1.2) % Chiude il grafico in un riquadro (assi dx e alto)
set(gca, 'XMinorTick', 'on')

set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'FontSize', 15)
set(gca, 'FontName', 'Times New Roman')

hold off

E_num = min(campo_el_bias(:,2))
E_th = -q*N_A*x_p_bias*10^(-4)/eps_si

err = abs(E_num-E_th)/E_th

exportgraphics(gcf, 'campo_el_bias.pdf', 'ContentType', 'vector');

%% Es.1 Densità di carica eq (pt 7)

rho_eq = pn_eq_band_diag('NetChargeConcentration.txt');

y_depl_p_rho = zeros(size(x_depl_p)); 
y_depl_p_rho(1,:) = -(q*N_A);

y_neu_p_rho = zeros(size(x_neu_p)); 
y_neu_p_rho(1,:) = 0;

y_depl_n_rho = zeros(size(x_depl_p)); 
y_depl_n_rho(1,:) = (q*N_D);

y_neu_n_rho = zeros(size(x_neu_p)); 
y_neu_n_rho(1,:) = 0;

y_p_rho = linspace(0,-q*N_A, 1000);
x_p_rho = zeros(size(y_p_rho));
x_p_rho(1,:) = -x_p_0;

y_0_rho = linspace(-q*N_A,q*N_D, 1000);
x_0_rho = zeros(size(y_0_rho));
x_0_rho(1,:) = 0;

y_n_rho = linspace(0,q*N_D, 1000);
x_n_rho = zeros(size(y_n_rho));
x_n_rho(1,:) = x_n_0;

figure
hold on

plot(rho_eq(:,1)-w_p+0.0003,rho_eq(:,2), 'r','LineWidth',1.2)

plot(x_p_rho,y_p_rho,'b', 'LineWidth',1.2)
plot(x_0_rho,y_0_rho,'b', 'LineWidth',1.2)
plot(x_n_rho,y_n_rho,'b', 'LineWidth',1.2)
plot(x_neu_p,y_neu_p_rho,'b', 'LineWidth',1.2)
plot(x_depl_p,y_depl_p_rho,'b', 'LineWidth',1.2)
plot(x_depl_n,y_depl_n_rho,'b', 'LineWidth',1.2)
plot(x_neu_n,y_neu_n_rho,'b', 'LineWidth',1.2)

xlim([-0.1,0.1])
ylim([-0.12,0.2])

xlabel('Posizione-x, \mum') 
ylabel('Densità di carica netta, Ccm^{-3}')

legend('$\rho_{eq}$ Simulazione Padre','$\rho_{eq}$ Modello teorico','FontSize',12, 'Interpreter', 'latex')

xregion(-x_p_0, x_n_0, 'FaceColor', [0.9 0.9 0.9], ...
    'FaceAlpha', 0.5, 'HandleVisibility', 'off');
xline(x_n_0, '--k', 'HandleVisibility', 'off'); 
xline(-x_p_0, '--k', 'HandleVisibility', 'off'); 
xline(0, '--k', 'HandleVisibility', 'off'); 

% 1. Forza l'aggiornamento del grafico per calcolare le tacche automatiche attuali
drawnow; 
current_ticks = xticks; 

% 2. Definisci le tue tacche speciali e le relative etichette
special_ticks = [-x_p_0, 0, x_n_0];
special_labels = {'$-x_{p_0}$', '0', '$x_{n_0}$'};

% 3. Unisci le tacche, rimuovendo quelle standard troppo vicine alle speciali
%    (Questo evita che un numero come 0.02 si sovrapponga a x_n se sono vicini)
range_x = max(current_ticks) - min(current_ticks);
tolerance = range_x * 0.05; % Tolleranza del 3% della larghezza totale

final_ticks = special_ticks;
final_labels = special_labels;

for i = 1:length(current_ticks)
    val = current_ticks(i);
    % Se la tacca corrente è "lontana" da tutte le tacche speciali, la teniamo
    if all(abs(val - special_ticks) > tolerance)
        final_ticks(end+1) = val;
        % Convertiamo il numero in stringa (stile 'general' rimuove zeri inutili)
        final_labels{end+1} = num2str(val, '%.2g'); 
    end
end

% 4. Ordina tacche ed etichette
[final_ticks, sort_idx] = sort(final_ticks);
final_labels = final_labels(sort_idx);

% 5. Applica al grafico
xticks(final_ticks);
xticklabels(final_labels);

% 6. Assicura che la griglia sia attiva e stilosa
grid on

set(gca, 'TickLabelInterpreter', 'latex'); % Fondamentale per renderizzare x_n/x_p
set(gca, 'TickDir', 'out') % Tacche esterne
set(gca, 'LineWidth', 1.2) % Chiude il grafico in un riquadro (assi dx e alto)
set(gca, 'XMinorTick', 'on')

set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'FontSize', 15)
set(gca, 'FontName', 'Times New Roman')


hold off


exportgraphics(gcf, 'charge_density.pdf', 'ContentType', 'vector');

%% Es.1 Densità di carica bias (pt 7)

rho_bias = pn_bias_band_diag('NetChargeConcentration_bias.txt');

y_depl_p_rho_bias = zeros(size(x_depl_p_bias)); 
y_depl_p_rho_bias(1,:) = -(q*N_A);

y_neu_p_rho_bias = zeros(size(x_neu_p_bias)); 
y_neu_p_rho_bias(1,:) = 0;

y_depl_n_rho_bias = zeros(size(x_depl_p_bias)); 
y_depl_n_rho_bias(1,:) = (q*N_D);

y_neu_n_rho_bias = zeros(size(x_neu_p_bias)); 
y_neu_n_rho_bias(1,:) = 0;

y_p_rho_bias = linspace(0,-q*N_A, 1000);
x_p_rho_bias = zeros(size(y_p_rho_bias));
x_p_rho_bias(1,:) = -x_p_bias;

y_0_rho_bias = linspace(-q*N_A,q*N_D, 1000);
x_0_rho_bias = zeros(size(y_0_rho_bias));
x_0_rho_bias(1,:) = 0;

y_n_rho_bias = linspace(0,q*N_D, 1000);
x_n_rho_bias = zeros(size(y_n_rho_bias));
x_n_rho_bias(1,:) = x_n_bias;

figure
hold on

plot(rho_bias(:,1)-w_p+0.0003,rho_bias(:,2), 'r','LineWidth',1.2)

plot(x_p_rho_bias,y_p_rho_bias,'b', 'LineWidth',1.2)
plot(x_0_rho_bias,y_0_rho_bias,'b', 'LineWidth',1.2)
plot(x_n_rho_bias,y_n_rho_bias,'b', 'LineWidth',1.2)
plot(x_neu_p_bias,y_neu_p_rho_bias,'b', 'LineWidth',1.2)
plot(x_depl_p_bias,y_depl_p_rho_bias,'b', 'LineWidth',1.2)
plot(x_depl_n_bias,y_depl_n_rho_bias,'b', 'LineWidth',1.2)
plot(x_neu_n_bias,y_neu_n_rho_bias,'b', 'LineWidth',1.2)

xlim([-0.1,0.1])
ylim([-0.12,0.2])

xlabel('Posizione-x, \mum') 
ylabel('Densità di carica netta, Ccm^{-3}')

legend('$\rho_{bias}$ Simulazione Padre','$\rho_{bias}$ Modello teorico', 'Interpreter', 'latex')

xregion(-x_p_bias, x_n_bias, 'FaceColor', [0.9 0.9 0.9], ...
    'FaceAlpha', 0.5, 'HandleVisibility', 'off');
xline(x_n_bias, '--k', 'HandleVisibility', 'off'); 
xline(-x_p_bias, '--k', 'HandleVisibility', 'off'); 
xline(0, '--k', 'HandleVisibility', 'off'); 

% 1. Forza l'aggiornamento del grafico per calcolare le tacche automatiche attuali
drawnow; 
current_ticks = xticks; 

% 2. Definisci le tue tacche speciali e le relative etichette
special_ticks = [-x_p_bias, 0, x_n_bias];
special_labels = {'$-x_{p_{bias}}$', '0', '$x_{n_{bias}}$'};

% 3. Unisci le tacche, rimuovendo quelle standard troppo vicine alle speciali
%    (Questo evita che un numero come 0.02 si sovrapponga a x_n se sono vicini)
range_x = max(current_ticks) - min(current_ticks);
tolerance = range_x * 0.05; % Tolleranza del 3% della larghezza totale

final_ticks = special_ticks;
final_labels = special_labels;

for i = 1:length(current_ticks)
    val = current_ticks(i);
    % Se la tacca corrente è "lontana" da tutte le tacche speciali, la teniamo
    if all(abs(val - special_ticks) > tolerance)
        final_ticks(end+1) = val;
        % Convertiamo il numero in stringa (stile 'general' rimuove zeri inutili)
        final_labels{end+1} = num2str(val, '%.2g'); 
    end
end

% 4. Ordina tacche ed etichette
[final_ticks, sort_idx] = sort(final_ticks);
final_labels = final_labels(sort_idx);

% 5. Applica al grafico
xticks(final_ticks);
xticklabels(final_labels);

% 6. Assicura che la griglia sia attiva e stilosa
grid on

set(gca, 'TickLabelInterpreter', 'latex'); % Fondamentale per renderizzare x_n/x_p
set(gca, 'TickDir', 'out') % Tacche esterne
set(gca, 'LineWidth', 1.2) % Chiude il grafico in un riquadro (assi dx e alto)
set(gca, 'XMinorTick', 'on')

set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'FontSize', 15)
set(gca, 'FontName', 'Times New Roman')



hold off

exportgraphics(gcf, 'charge_density_bias.pdf', 'ContentType', 'vector');

%% Es. 1 Correnti (pt 8)

I_n = pn_bias_band_diag('ElectronCurrent_bias.txt');
I_p = pn_bias_band_diag('HoleCurrent_bias.txt');
I_total = pn_bias_band_diag('TotalCurrent_bias.txt');

figure
hold on

plot(I_n(:,1)-w_p,I_n(:,2),'b','LineWidth', 1.2)
plot(I_p(:,1)-w_p,I_p(:,2),'r','LineWidth', 1.2)
plot(I_total(:,1)-w_p,I_total(:,2),'--k','LineWidth', 1.2)

xlim([-170,170])

xlabel('Posizione-x, \mum') 
ylabel('Corrente , A')

legend('$I_n$','$I_p$','$I_{tot}$','FontSize',12, 'Interpreter', 'latex', 'Location', 'best')



% 6. Assicura che la griglia sia attiva e stilosa
grid on

set(gca, 'TickLabelInterpreter', 'latex'); % Fondamentale per renderizzare x_n/x_p
set(gca, 'TickDir', 'out') % Tacche esterne
set(gca, 'LineWidth', 1.2) % Chiude il grafico in un riquadro (assi dx e alto)
set(gca, 'XMinorTick', 'on')

set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'FontSize', 15)
set(gca, 'FontName', 'Times New Roman')

hold off

exportgraphics(gcf, 'current.pdf', 'ContentType', 'vector');

%% Es. 1 Carattristica IV (pt 9)

IV = caratteristica_iv('ivI1.txt');

figure 
hold on

plot(IV(:,1), IV(:,2), 'k', 'LineWidth', 1.2)
xline(0, '--k', 'HandleVisibility', 'off');

xregion(-0.4, 0, 'FaceColor', [0.7 0.9 0.9], ...
    'FaceAlpha', 0.5);

xregion(0, 1.2, 'FaceColor', [0.7 0.7 0.9], ...
    'FaceAlpha', 0.5);

xlabel('Tensione di bias, V') 
ylabel('Corrente , A')

legend('Caratteristica $I-V$','Polarizzazione inversa','Polarizzazione diretta','FontSize',12, 'Interpreter', 'latex', 'Location', 'best')


% 6. Assicura che la griglia sia attiva e stilosa
grid on

set(gca, 'TickLabelInterpreter', 'latex'); % Fondamentale per renderizzare x_n/x_p
set(gca, 'TickDir', 'out') % Tacche esterne
set(gca, 'LineWidth', 1.2) % Chiude il grafico in un riquadro (assi dx e alto)
set(gca, 'XMinorTick', 'on')

set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'FontSize', 15)
set(gca, 'FontName', 'Computer Modern')


hold off

exportgraphics(gcf, 'IV_car.pdf', 'ContentType', 'vector');

%% Esperimento di Heynes Shockley

clc
close all

% Importazione dati
p_14ps = import_HS('HoleChargeConcentration14_HS.txt');
p_7ps = import_HS('HoleChargeConcentration7_HS.txt');
p_8ps = import_HS('HoleChargeConcentration8_HS.txt');
p_6bps = import_HS('HoleChargeConcentration1.86_HS.txt');
p_6ps = import_HS('HoleChargeConcentration6_HS.txt');


% Centratura dei dati
x_14ps = p_14ps(:,1)-170;
p_14ps_val = p_14ps(:,2);

x_7ps = p_7ps(:,1)-170;
p_7ps_val = p_7ps(:,2);

x_8ps = p_8ps(:,1)-170;
p_8ps_val = p_8ps(:,2);

x_6bps = p_6bps(:,1)-170;
p_6bps_val = p_6bps(:,2);

x_6ps = p_6ps(:,1)-170;
p_6ps_val = p_6ps(:,2);

figure
hold on 

% Plot delle curve
plot(x_14ps, p_14ps_val, 'LineWidth', 1.5)
plot(x_8ps, p_8ps_val, 'LineWidth', 1.5)
plot(x_7ps, p_7ps_val, 'LineWidth', 1.5)
plot(x_6ps, p_6bps_val, 'LineWidth', 1.5)
plot(x_6ps, p_6ps_val, 'LineWidth', 1.5)

% Trova posizione del massimo per ogni curva
[~, idx_14ps] = max(p_14ps_val);
[~, idx_8ps] = max(p_8ps_val);
[~, idx_7ps] = max(p_7ps_val);
[~, idx_6ps] = max(p_6ps_val);
[~, idx_6bps] = max(p_6bps_val);

peak_14ps_x = x_14ps(idx_14ps);
peak_8ps_x = x_8ps(idx_8ps);
peak_7ps_x = x_7ps(idx_7ps);
peak_6ps_x = x_6ps(idx_6ps);
peak_6bps_x = x_6bps(idx_6bps);

plot(peak_14ps_x, max(p_14ps_val), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4, 'HandleVisibility', 'off');
plot(peak_6ps_x, max(p_6ps_val), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4, 'HandleVisibility', 'off');
plot(peak_7ps_x, max(p_7ps_val), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4, 'HandleVisibility', 'off');
plot(peak_6bps_x, max(p_6bps_val), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4, 'HandleVisibility', 'off');
plot(peak_8ps_x, max(p_8ps_val), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4, 'HandleVisibility', 'off');


% Formattazione grafico
set(gca, 'Yscale', 'log')
legend('1.0\times10^{-14} s', '1.0\times10^{-8} s', '1.0\times10^{-7} s', '1.0\times10^{-6} s','2.0\times10^{-6} s','FontSize', 12,'Location', 'best')

xlabel('Posizione-x, \mum')
ylabel('Concentrazione di eccesso di lacune, cm^{-3}')
set(gca, 'FontSize', 15, 'FontName', 'Times New Roman')

grid on

set(gca, 'TickLabelInterpreter', 'latex'); % Fondamentale per renderizzare x_n/x_p
set(gca, 'TickDir', 'out') % Tacche esterne
set(gca, 'LineWidth', 1.2) % Chiude il grafico in un riquadro (assi dx e alto)
set(gca, 'XMinorTick', 'on')

set(gca, 'TickLabelInterpreter', 'latex')
set(gca, 'FontSize', 15)
set(gca, 'FontName', 'Computer Modern')

xlim([-170,170])

exportgraphics(gcf, 'Heynes_Shockley.pdf', 'ContentType', 'vector');

hold off

%% calcoli HS
 
% Tempi in secondi
t = [1e-14, 1e-8, 1e-7, 1e-6, 2e-6];

x_cm = [peak_14ps_x, peak_8ps_x, peak_7ps_x, peak_6ps_x, peak_6bps_x] * 1e-4;
x_HS = linspace(1e-14,2e-6,1000);

% Calcola velocità di deriva (regressione lineare semplice)
coefficients = polyfit(t, x_cm, 1);
v_drift = coefficients(1); % cm/s

figure
hold on
plot (t, x_cm, 'o', 'LineWidth',1.2)
plot(x_HS, v_drift*x_HS)
set(gca, 'xscale', 'log')

fprintf('Velocità di deriva: %.2f cm/s\n', v_drift);

% Campo elettrico (dato)
E = 0.6/(340*10^(-4)); % V/cm (valore assoluto)
fprintf('Campo elettrico: %.2f V/cm\n', E);

% Mobilità
mobility = abs(v_drift) / E;
fprintf('Mobilità delle lacune: %.2f cm²/V·s\n', mobility);