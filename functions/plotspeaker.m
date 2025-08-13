function plotspeaker(filenames)
    pkg load io;
    colors = {'r', 'g', 'b', 'm'};  % Couleurs pour chaque stratégie

    F1_vals = {};
    F2_vals = {};
    labels = {};

    for f = 1:length(filenames)
        filename = filenames{f};
        [~, sheets] = xlsfinfo(filename);

        F1_refs = [];
        F2_refs = [];
        F1_ref_means = [];
        F2_ref_means = [];
        F1_refs_mean_central = {};
        F1_refs_mean_mean = {};
        F1_refs_mean_F1max = {};
        F1_refs_mean_Ampmax = {};

        F2_refs_mean_central = {};
        F2_refs_mean_mean = {};
        F2_refs_mean_F1max = {};
        F2_refs_mean_Ampmax = {};

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

        F1_refs_mean_central{end+1} = mean(F1_refs(:,1));
        F1_refs_mean_mean{end+1}    = mean(F1_refs(:,2));
        F1_refs_mean_F1max{end+1}   = mean(F1_refs(:,3));
        F1_refs_mean_Ampmax{end+1}  = mean(F1_refs(:,4));

        F2_refs_mean_central{end+1} = mean(F2_refs(:,1));
        F2_refs_mean_mean{end+1}    = mean(F2_refs(:,2));
        F2_refs_mean_F1max{end+1}   = mean(F2_refs(:,3));
        F2_refs_mean_Ampmax{end+1}  = mean(F2_refs(:,4));

        F1_vals{end+1} = F1_refs;
        F2_vals{end+1} = F2_refs;
        labels{end+1} = filename;
    end

    confidence_levels = [0.95,0.975, 0.99];
    chi2_values = [5.991, 7.38, 9.21];

    for c = 1:length(confidence_levels)
        figure('Name', sprintf('F1 vs F2 - %.1f%% Confidence Ellipse', confidence_levels(c)*100));
        hold on;

        all_labels = {'Central Value', 'Mean Value', 'F1 max', 'Amp max'};
        h_legend = [];

        for j = 1:4  % pour chaque type de point
            all_points = [];

            if j == 3
                total_bleus = 0;
            end

            for i = 1:length(F1_vals)
                F1 = F1_vals{i}(:, j);
                F2 = F2_vals{i}(:, j);
                scatter(F1, F2, 100, colors{j}, 'filled');
                all_points = [all_points; F1, F2];

                if j == 3
                    total_bleus = total_bleus + length(F1);
                end
            end

            if j == 3
                fprintf('Nombre total de points bleus (F1max) : %d\n', total_bleus);
            end

            draw_ellipse(all_points, chi2_values(c), colors{j});

            switch j
                case 1
                    F1_mean_pts = cell2mat(F1_refs_mean_central');
                    F2_mean_pts = cell2mat(F2_refs_mean_central');
                case 2
                    F1_mean_pts = cell2mat(F1_refs_mean_mean');
                    F2_mean_pts = cell2mat(F2_refs_mean_mean');
                case 3
                    F1_mean_pts = cell2mat(F1_refs_mean_F1max');
                    F2_mean_pts = cell2mat(F2_refs_mean_F1max');
                case 4
                    F1_mean_pts = cell2mat(F1_refs_mean_Ampmax');
                    F2_mean_pts = cell2mat(F2_refs_mean_Ampmax');
            end

            % Et ensuite, calcule la moyenne des moyennes :
           % Utilise la moyenne des points utilisés pour tracer l'ellipse
            mu = mean(all_points);
          scatter(mu(1), mu(2), 160, colors{j}, 'd', 'filled', ...
        'MarkerEdgeColor', 'k', 'LineWidth', 1.5);


            h_legend(j) = plot(NaN, NaN, ['o' colors{j}], ...
                'MarkerFaceColor', colors{j}, 'MarkerSize', 10);
        end

        legend(h_legend, all_labels, 'Location', 'northeast', 'Box', 'on', ...
            'EdgeColor', 'k', 'FontSize', 12, 'FontWeight', 'bold');

        xlabel('F1 (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
        ylabel('F2 (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
        title(sprintf('F1 vs F2 (%.1f%% Ellipse)', confidence_levels(c)*100), ...
            'FontSize', 14, 'FontWeight', 'bold');

        maxF1 = max(cellfun(@(x) max(x(:)), F1_vals));
        maxF2 = max(cellfun(@(x) max(x(:)), F2_vals));
        xlim([0, maxF1 + 500]);
        ylim([0, maxF2 + 500]);

        set(gcf, 'Position', [100 + 100*c, 100 + 100*c, 1200, 800]);
        grid on;
        hold off;
    end
end

% === Fonction auxiliaire : trace une ellipse de confiance à partir des données ===
function draw_ellipse(X, chi2_val, color)
    mu = mean(X);
    Sigma = cov(X);
    [V, D] = eig(Sigma);
    

    % Rayon des axes de l'ellipse
    a = sqrt(chi2_val * D(1,1));
    b = sqrt(chi2_val * D(2,2));

    % Angle d'inclinaison
    theta = atan2(V(2,1), V(1,1));

    t = linspace(0, 2*pi, 100);
    ellipse_x = a * cos(t);
    ellipse_y = b * sin(t);

    % Rotation + translation
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    ellipse = R * [ellipse_x; ellipse_y];
    plot(mu(1) + ellipse(1,:), mu(2) + ellipse(2,:), 'Color', color, 'LineWidth', 2);
    
    
end
