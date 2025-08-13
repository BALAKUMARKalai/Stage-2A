function F1max(filename) 
pkg load io;  
[~, sheets] = xlsfinfo(filename);  

F1_refs = [];
F2_refs = [];
labels = {};

for i = 1:length(sheets)
    sheet_name = sheets{i};
    data = xlsread(filename, sheet_name);
    
    time = data(:, 1);
    amplitude = data(:, 2);
    F0 = data(:, 3);
    F1 = data(:, 4);
    F2 = data(:, 5);
    
    valid = ~any(isnan([time, amplitude, F1, F2]), 2);
    time = time(valid);
    amplitude = amplitude(valid);
    F1 = F1(valid);
    F2 = F2(valid);

    [F1_max, idx_maxF1] = max(F1);
    F2_at_F1max = F2(idx_maxF1);
    time_at_F1max = time(idx_maxF1);
    amp_at_F1max = amplitude(idx_maxF1);

    distances = sqrt((F1 - F1_max).^2 + (F2 - F2_at_F1max).^2);
    MSE_dispersion = mean(distances.^2);
    total_dispersion_mean = mean(distances);

    fprintf('(FM) Dispersion (MSE) autour de F1max pour %s : %.2f\n', sheet_name, total_dispersion_mean);

    % === Stocker les points de référence F1 et F2 pour chaque contexte ===
    F1_refs(end+1) = F1_max;
    F2_refs(end+1) = F2_at_F1max;
    labels{end+1} = sheet_name;

    % === Création de la figure pour chaque contexte ===
    %figure('Name', sprintf('Context: %s', sheet_name));

    % --- Subplot 1 : Amplitude, F1, F2 vs temps ---
%    set(gca, 'FontSize', 14);
%    [ax, h1, h2] = plotyy(time, amplitude, time, F1);
%    set(h1, 'Color', 'r', 'LineWidth', 1.5);
%    set(h2, 'Color', 'g', 'LineWidth', 1.5);
%    ylabel(ax(1), 'Amplitude (dB)');
%    ylabel(ax(2), 'Fréquences (Hz)');
%    xlabel('Temps (ms)');
%
%    hold(ax(1), 'on');
%    plot(ax(1), time_at_F1max, amp_at_F1max, 'or', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
%    hold(ax(1), 'off');
%
%    hold(ax(2), 'on');
%    plot(ax(2), time, F2, 'b-', 'LineWidth', 1.5);
%    plot(ax(2), time_at_F1max, F1_max, 'og', 'MarkerFaceColor', 'g', 'MarkerSize', 8);
%    plot(ax(2), time_at_F1max, F2_at_F1max, 'ob', 'MarkerFaceColor', 'b', 'MarkerSize', 8);
%    hold(ax(2), 'off');
%
%    title(sprintf('Amplitude, F1, F2 vs Temps (%s)', sheet_name));
%    legend(ax(2), {'F1', 'F2', 'F1@F1Max', 'F2@F1Max', 'Amplitude'});
%    grid on;
end

figure('Name', 'Reference F1max points F1 vs F2 (all consonant contexts)');
hold on;

scatter(F1_refs, F2_refs, 100, 'r', 'filled');

for i = 1:length(F1_refs)
    text(F1_refs(i), F2_refs(i) + 10, labels{i}, 
        'FontSize', 10, 'Color', 'black', ...
        'HorizontalAlignment', 'center');
end

xlabel('F1 (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('F2 (Hz)', 'FontSize', 12, 'FontWeight', 'bold');


xlim([0, max(F1_refs) + 500]); 
ylim([0, max(F2_refs) + 500]);

e
title('Reference F1max points for F1 vs F2 (for each consonantal context)', 'FontSize', 14, 'FontWeight', 'bold');
legend('Reference F1max points', 'Location', 'northeast');

grid on;
hold off;
end