function comparestrat(filename)
    pkg load io;

    colors = {'r', 'g', 'b', 'm'};  % Une couleur par stratégie
    labels = {'Central Value', 'Mean Value', 'F1 max', 'Amp max'};

    [~, sheets] = xlsfinfo(filename);
    F1_refs = []; F2_refs = [];

    for i = 1:length(sheets)
        data = xlsread(filename, sheets{i});
        time = data(:, 1); amplitude = data(:, 2);
        F1 = data(:, 4); F2 = data(:, 5);

        valid = ~any(isnan([time, amplitude, F1, F2]), 2);
        time = time(valid); amplitude = amplitude(valid);
        F1 = F1(valid); F2 = F2(valid);

        n = length(time);
        idx_central = floor(n/2);
        F1_central = F1(idx_central);
        F2_central = F2(idx_central);

        F1_mean = mean(F1);
        F2_mean = mean(F2);

        [~, idx_maxF1] = max(F1);
        F1_max = F1(idx_maxF1);
        F2_at_F1max = F2(idx_maxF1);

        [~, idx_maxAmp] = max(amplitude);
        F1_at_Ampmax = F1(idx_maxAmp);
        F2_at_Ampmax = F2(idx_maxAmp);

        F1_refs = [F1_refs; F1_central, F1_mean, F1_max, F1_at_Ampmax];
        F2_refs = [F2_refs; F2_central, F2_mean, F2_at_F1max, F2_at_Ampmax];
    end

    figure; hold on;
    for j = 1:4
        scatter(F1_refs(:, j), F2_refs(:, j), 100, colors{j}, 'filled', ...
                'DisplayName', labels{j});
        % Ajouter texte au-dessus
        for k = 1:size(F1_refs, 1)
            text(F1_refs(k, j), F2_refs(k, j) + 11, ...
                 sheets{k}, 'HorizontalAlignment', 'center', ...
                 'FontSize', 6);
        end
    end

    xlabel('F1 (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('F2 (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
    title(['Strategy comparison F1vsF2 '], ...
          'FontSize', 14, 'FontWeight', 'bold');
    legend('Location', 'bestoutside');
    grid on; hold off;
endfunction

