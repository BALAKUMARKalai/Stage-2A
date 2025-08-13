function centralvalue(filename) 
pkg load io;  
[~, sheets] = xlsfinfo(filename);  


for i = 1:length(sheets)
    sheet_name = sheets{i};
    data = xlsread(filename, sheet_name);
    
    time = data(:, 1);
    amplitude = data(:, 2);
    F0 = data(:, 3);
    F1 = data(:, 4);
    F2 = data(:, 5);

    % Nettoyer NaNs
    valid = ~isnan(time) & ~isnan(F1) & ~isnan(F2) & ~isnan(amplitude);
    time = time(valid);
    amplitude = amplitude(valid);
    F1 = F1(valid);
    F2 = F2(valid);

    % Obtenir la valeur centrale
    n = length(time);
    idx_central = floor(n/2);
    time_central = time(idx_central);
    amp_central = amplitude(idx_central);
    F1_central = F1(idx_central);
    F2_central = F2(idx_central);

    [ax, h1, h2] = plotyy(time, amplitude, time, F1);

    set(gca, 'FontSize', 14);  
    set(h1, 'Color', 'r', 'LineWidth', 1.5);
    ylabel(ax(1), 'Amplitude (dB)');
    ylim(ax(1), [min(amplitude)-5, max(amplitude)+5]);
    hold(ax(1), 'on');
    plot(ax(1), time_central, amp_central, 'or', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
    hold(ax(1), 'off');

    set(gca, 'FontSize', 14); 
    hold(ax(2), 'on');
    set(h2, 'Color', 'g', 'LineWidth', 1.5);  % F1 en vert
    plot(ax(2), time, F2, 'b-', 'LineWidth', 1.5);  % F2 en bleu
    plot(ax(2), time_central, F1_central, 'og', 'MarkerFaceColor', 'g', 'MarkerSize', 8);
    plot(ax(2), time_central, F2_central, 'ob', 'MarkerFaceColor', 'b', 'MarkerSize', 8);
    hold(ax(2), 'off');
    ylabel(ax(2), 'Frequency (Hz)');
    ylim(ax(2), [min([F1; F2])-100, max([F1; F2])+100]);
    xlabel('Time (ms)');
    
    set(gca, 'FontSize', 14);  % Taille de la police pour les axes et labels
    title(sprintf('Amplitude, F1, F2 vs Time (%s)', sheet_name));
    legend(ax(2), {'F1', 'F2', 'Point central F1', 'Point central F2', 'Amplitude'});
    grid on;
end

F1_refs = [];
F2_refs = [];
labels = {};

for i = 1:length(sheets)
    sheet_name = sheets{i};
    data = xlsread(filename, sheet_name);
    
    time = data(:, 1);
    amplitude = data(:, 2);
    F1 = data(:, 4);
    F2 = data(:, 5);

    valid = ~any(isnan([time, amplitude, F1, F2]), 2);
    time = time(valid);
    amplitude = amplitude(valid);
    F1 = F1(valid);
    F2 = F2(valid);
    
    n = length(time);
    idx_central = floor(n/2);
    F1_central = F1(idx_central);
    F2_central = F2(idx_central);

    F1_refs(end+1) = F1_central;
    F2_refs(end+1) = F2_central;
    labels{end+1} = sheet_name;
end

figure('Name', 'Reference points F1 vs F2 (all consonant contexts)');
hold on;
scatter(F1_refs, F2_refs, 100, 'r', 'filled');

for i = 1:length(F1_refs)
    text(F1_refs(i), F2_refs(i) + 10, labels{i}, ... % décalage vertical de 50 Hz
        'FontSize', 10, 'Color', 'black', ...
        'HorizontalAlignment', 'center');
end

% Légendes des axes avec les axes qui commencent à 0
xlabel('F1 (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('F2 (Hz)', 'FontSize', 12, 'FontWeight', 'bold');

xlim([0, max(F1_refs) + 500]); 
ylim([0, max(F2_refs) + 500]); 


title('Reference points for F1 vs F2 (central value for each consonant context)', 'FontSize', 14, 'FontWeight', 'bold');
legend('Central reference points','Location','northeast');

grid on;
hold off;

end