function comparestrat_subplots(filenames) 
    pkg load io;

    colors = {'r', 'g', 'b', 'm'};
    labels = {'Central Value', 'Mean Value', 'F1 max', 'Amplitude max'};
    marker_moy_list = {'rx', 'go', 'b+', 'm*'};
    nbPerPage = 5;

    [~, all_sheets] = xlsfinfo(filenames{1});
    nbFeuilles = length(all_sheets);
    nbStrategies = 4;
    nbFichiers = length(filenames);
    nbPages = ceil(nbFeuilles / nbPerPage);

    
    sheet_numbers = zeros(nbFeuilles, 1);
    for i = 1:nbFeuilles
        sheet_numbers(i) = str2double(regexp(all_sheets{i}, '^\d+', 'match'){1});
    end
    [~, idx_sort] = sort(sheet_numbers);
    sheets = all_sheets(idx_sort);

    F1_all = zeros(nbFeuilles, nbStrategies, nbFichiers);
    F2_all = zeros(nbFeuilles, nbStrategies, nbFichiers);

    for f = 1:nbFichiers
        [~, current_sheets] = xlsfinfo(filenames{f});
        sheet_nums = zeros(nbFeuilles, 1);
        for i = 1:nbFeuilles
            sheet_nums(i) = str2double(regexp(current_sheets{i}, '^\d+', 'match'){1});
        end
        [~, idxs] = sort(sheet_nums);
        current_sheets = current_sheets(idxs);

        for i = 1:nbFeuilles
            data = xlsread(filenames{f}, current_sheets{i});
            time = data(:, 1); amp = data(:, 2);
            F1 = data(:, 4); F2 = data(:, 5);

            valid = ~any(isnan([time, amp, F1, F2]), 2);
            time = time(valid); amp = amp(valid);
            F1 = F1(valid); F2 = F2(valid);

            n = length(time);
            idx_central = floor(n / 2);
            F1_central = F1(idx_central);
            F2_central = F2(idx_central);

            F1_mean = mean(F1); F2_mean = mean(F2);
            [~, idx_maxF1] = max(F1);
            F1_max = F1(idx_maxF1); F2_maxF1 = F2(idx_maxF1);
            [~, idx_maxAmp] = max(amp);
            F1_amp = F1(idx_maxAmp); F2_amp = F2(idx_maxAmp);

            F1_all(i,:,f) = [F1_central, F1_mean, F1_max, F1_amp];
            F2_all(i,:,f) = [F2_central, F2_mean, F2_maxF1, F2_amp];
        end
    end

    for p = 1:nbPages
        figure('Position', [100, 100, 1400, 900]);

        startIdx = (p - 1) * nbPerPage + 1;
        endIdx = min(p * nbPerPage, nbFeuilles);
        count = 1;

        for i = startIdx:endIdx
            subplot(3, 2, count); hold on;

            for j = 1:nbStrategies
                for f = 1:nbFichiers
                    scatter(F1_all(i,j,f), F2_all(i,j,f), 40, colors{j}, 'filled');
                end
                F1_moy = mean(F1_all(i,j,:));
                F2_moy = mean(F2_all(i,j,:));
                plot(F1_moy, F2_moy, marker_moy_list{j}, 'MarkerSize', 10, 'LineWidth', 2);
            end

            label_clean = regexprep(sheets{i}, '^\d+', '');
            title(label_clean, 'FontSize', 15);
            F1_vals = F1_all(i,:,:)(:); F2_vals = F2_all(i,:,:)(:);
            xlim([min(F1_vals)-30, max(F1_vals)+30]);
            ylim([min(F2_vals)-30, max(F2_vals)+30]);
            xlabel('F1 (Hz)', 'FontSize', 12);
            ylabel('F2 (Hz)', 'FontSize', 12);
            set(gca, 'FontSize', 11);

            count += 1;
        end

        % Légende en bas à droite
        axes('Position', [0.75, 0.05, 0.22, 0.30]); hold on; axis off;
        for j = 1:nbStrategies
            scatter(1, j, 70, colors{j}, 'filled');
            text(1.3, j, labels{j}, 'FontSize', 13, 'VerticalAlignment', 'middle');
            plot(2.5, j, marker_moy_list{j}, 'MarkerSize', 11, 'LineWidth', 1.7);
            text(2.8, j, ['Mean of ' labels{j}], 'FontSize', 13, 'VerticalAlignment', 'middle');
        end
        xlim([0.5, 4]); ylim([0.5, nbStrategies+0.5]);

        annotation('textbox', [0, 0.94, 1, 0.05], ...
                   'String', sprintf('Comparison F1/F2 per context - Page %d', p), ...
                   'HorizontalAlignment', 'center', ...
                   'FontSize', 12, 'FontWeight', 'bold', 'EdgeColor', 'none');

        drawnow();
        saveas(gcf, sprintf('page_%d.png', p));
    end
endfunction
