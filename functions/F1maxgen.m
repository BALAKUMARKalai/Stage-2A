function F1maxgen(filenames)
    pkg load io;
    colors = {'r', 'g', 'b', 'm'};  

    F1_refs = [];
    F2_refs = [];
    labels = {};

    for f = 1:length(filenames)
        filename = filenames{f};
        [~, sheets] = xlsfinfo(filename);

        for i = 1:length(sheets)
            sheet_name = sheets{i};
            data = xlsread(filename, sheet_name);

            time = data(:, 1);
            amplitude = data(:, 2);
            F1 = data(:, 4);
            F2 = data(:, 5);

            valid = ~any(isnan([F1, F2]), 2);
            F1 = F1(valid);
            F2 = F2(valid);

            if isempty(F1) || isempty(F2)
                continue;
            end

            [~, idx_maxF1] = max(F1);
            F1_max = F1(idx_maxF1);
            F2_at_F1max = F2(idx_maxF1);

            F1_refs(end+1) = F1_max;
            F2_refs(end+1) = F2_at_F1max;
            labels{end+1} = sheet_name;
        end
    end

   
    figure('Name', 'Reference F1max points F1 vs F2 (all consonant contexts)');
    hold on;

    scatter(F1_refs, F2_refs, 100, 'r', 'filled');

    for i = 1:length(F1_refs)
        text(F1_refs(i), F2_refs(i) + 10, labels{i}, ...
            'FontSize', 10, 'Color', 'black', ...
            'HorizontalAlignment', 'center');
    end

    xlabel('F1 (kHz)', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('F2 (k  Hz)', 'FontSize', 12, 'FontWeight', 'bold');
    xlim([0, max(F1_refs) + 500]);
    ylim([0, max(F2_refs) + 500]);
    title('Reference F1max points for F1 vs F2 (for each consonantal context)', ...
          'FontSize', 14, 'FontWeight', 'bold');
    legend('Reference F1max points', 'Location', 'northeast');

    grid on;
    hold off;
end
