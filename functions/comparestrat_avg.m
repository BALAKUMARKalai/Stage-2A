function comparestrat_avg(filenames)
    pkg load io;

    colors = {'r', 'g', 'b', 'm'};
    labels = {'Central Value', 'Mean Value', 'F1 max', 'Amp max'};

   
    [~, all_sheets] = xlsfinfo(filenames{1});
    nbFeuilles = length(all_sheets);
    nbStrategies = 4;

    sheet_numbers = zeros(nbFeuilles, 1);
    for i = 1:nbFeuilles
        sheet_numbers(i) = str2double(regexp(all_sheets{i}, '^\d+', 'match'){1});
    end
    [~, idx_sort] = sort(sheet_numbers);
    sheets = all_sheets(idx_sort);  

    F1_moy = zeros(nbFeuilles, nbStrategies);
    F2_moy = zeros(nbFeuilles, nbStrategies);

    for f = 1:length(filenames)
        [~, sheets_check] = xlsfinfo(filenames{f});
        if length(sheets_check) != nbFeuilles
            error('Tous les classeurs doivent avoir le même nombre de feuilles !');
        end

        % Trier les feuilles du classeur courant
        current_sheets = sheets_check;
        sheet_numbers_check = zeros(nbFeuilles, 1);
        for i = 1:nbFeuilles
            sheet_numbers_check(i) = str2double(regexp(current_sheets{i}, '^\d+', 'match'){1});
        end
        [~, idx_sort_check] = sort(sheet_numbers_check);
        current_sheets = current_sheets(idx_sort_check);

        for i = 1:nbFeuilles
            data = xlsread(filenames{f}, current_sheets{i});
            time = data(:, 1); amplitude = data(:, 2);
            F1 = data(:, 4); F2 = data(:, 5);

            valid = ~any(isnan([time, amplitude, F1, F2]), 2);
            time = time(valid); amplitude = amplitude(valid);
            F1 = F1(valid); F2 = F2(valid);

            n = length(time);
            idx_central = floor(n / 2);
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

           
            F1_moy(i, :) += [F1_central, F1_mean, F1_max, F1_at_Ampmax];
            F2_moy(i, :) += [F2_central, F2_mean, F2_at_F1max, F2_at_Ampmax];
        end
    end

    % Moyenne finale
    F1_moy = F1_moy / length(filenames);
    F2_moy = F2_moy / length(filenames);

    % Tracé
    figure; hold on;
    for j = 1:nbStrategies
        scatter(F1_moy(:, j), F2_moy(:, j), 100, colors{j}, 'filled', ...
                'DisplayName', labels{j});
        for i = 1:nbFeuilles
            label_clean = regexprep(sheets{i}, '^\d+', '');
            text(F1_moy(i, j), F2_moy(i, j) + 10, label_clean, ...
     'FontSize', 10, 'HorizontalAlignment', 'center');
        end
    end

    xlabel('F1 (Hz)', 'FontSize', 14, 'FontWeight', 'bold');
    ylabel('F2 (Hz)', 'FontSize', 14, 'FontWeight', 'bold');
    title('Comparaison of strategies F1vsF2 (mean across all versions)', ...
          'FontSize', 14, 'FontWeight', 'bold');
    legend('Location', 'bestoutside');
    grid on; hold off;
endfunction
