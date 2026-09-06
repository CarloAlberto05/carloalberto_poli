clc
clear
close all

% Importo matrice di adiacenza
data = load('output/adjacency.mat');

A = data.A;
deg = data.degree;
nomi = data.stop_names;

% Parametri matrice di adiacenza
size_A = size(A);
rows = size_A(1);
cols = size_A(2);

k = 200;

%Decomposizione ai valori singolari
[U,S,V] = svds(A,k);

%Plot valori singolari
figure
plot(diag(S), '-', LineWidth = 1.5)
xlabel('Componente'); ylabel('Valore singolare');
title('Plot autovalori M – rete GTT Torino');
ylim([0 2000])
xlim([0 k+2])
grid on

[deg_sorted, idx] = sort(deg, 'descend');
fprintf('Top 10 hub per grado:\n');
for k = 1:10
   fprintf('  %d. %s (%.0f)\n', k, nomi{idx(k)}, deg_sorted(k));
end

exportgraphics(gcf, 'valori_singolari.pdf', 'ContentType', 'vector')


%% 1. CONNETTIVITÀ PONDERATA
U = double(full(sum(A,2)));          

%% 2. ENTROPIA NORMALIZZATA
H = zeros(rows,1);
for i = 1:rows
    neighbors = find(A(i,:));
    k_i = length(neighbors);
    if k_i > 1 && U(i) > 0
        probs = double(full(A(i,neighbors))) / U(i);
        H_raw = -sum(probs .* log(probs));
        H(i)  = H_raw / log(k_i);
    end
end
H = double(H);                      

%% 3. NORMALIZZAZIONE
U_norm = (U - min(U)) / (max(U) - min(U));
H_norm = (H - min(H)) / (max(H) - min(H) + 1e-12);  % ← evita /0

%% 4. INDICE
CC = sqrt(U_norm .* H_norm);

%% 5. RANKING FERMATE 
[CC_sorted, idx] = sort(CC,'descend');

fprintf('\n');
fprintf('============================================\n');
fprintf('TOP FERMATE AD ALTA COMPLESSITÀ COGNITIVA\n');
fprintf('============================================\n\n');

topN = 15;

for i = 1:topN

    fprintf('%2d. %-40s | CC = %.3f | U = %.1f | H = %.3f\n', ...
        i, ...
        nomi{idx(i)}, ...
        CC_sorted(i), ...
        U(idx(i)), ...
        H(idx(i)));
end

%% 6. SCATTER PLOT
figure

scatter(log(U+1), H, 20, CC, 'filled')

xlabel('log(Connettività ponderata + 1)')
ylabel('Entropia normalizzata')

title('Complessità cognitiva fermate GTT Torino')

grid on
colorbar

%% 7. EVIDENZIA TOP FERMATE
hold on

topLabel = 10;

for i = 1:topLabel

    x = log(U(idx(i))+1);
    y = H(idx(i));

    plot(x,y,'o', ...
     'MarkerSize',6, ...         
     'MarkerEdgeColor','k', ...
     'MarkerFaceColor','none', ...
     'LineWidth',2)               

end

%% 8. ISTOGRAMMA COMPLESSITA'
figure

histogram(CC,40)

xlabel('Indice complessità cognitiva')
ylabel('Numero fermate')

title('Distribuzione complessità cognitiva')

grid on

%% 9. TOP FERMATE PER ENTROPIA
[H_sorted, idxH] = sort(H,'descend');

fprintf('\n');
fprintf('============================================\n');
fprintf('TOP FERMATE PER ENTROPIA\n');
fprintf('============================================\n\n');

for i = 1:10

    fprintf('%2d. %-40s | H = %.3f | U = %.1f\n', ...
        i, ...
        nomi{idxH(i)}, ...
        H_sorted(i), ...
        U(idxH(i)));

end

%% 10. TOP FERMATE PER CONNETTIVITA'
[U_sorted, idxU] = sort(U,'descend');

fprintf('\n');
fprintf('============================================\n');
fprintf('TOP FERMATE PER CONNETTIVITÀ\n');
fprintf('============================================\n\n');

for i = 1:10

    fprintf('%2d. %-40s | U = %.1f | H = %.3f\n', ...
        i, ...
        nomi{idxU(i)}, ...
        U_sorted(i), ...
        H(idxU(i)));
end




