function average(filename)
  pkg load io;
  [~, sheets] = xlsfinfo(filename);

  F1_means = [];
  F2_means = [];
  labels = {};

  for i = 1:length(sheets)
      sheet_name = sheets{i};
      data = xlsread(filename, sheet_name);

      time = data(:, 1);
      amplitude = data(:, 2);
      F0 = data(:, 3);
      F1 = data(:, 4);
      F2 = data(:, 5);

      % Nettoyer NaNs
      valid = ~any(isnan([time, amplitude, F1, F2]), 2);
      time = time(valid);
      amplitude = amplitude(valid);
      F1 = F1(valid);
      F2 = F2(valid);

      % Moyennes
      mean_amp = mean(amplitude);
      mean_F1 = mean(F1);
      mean_F2 = mean(F2);
      mean_time = mean(time);  % Pour placer le point sur l'axe du temps

      fprintf('Moyennes pour %s : Amplitude = %.2f | F1 = %.2f Hz | F2 = %.2f Hz\n', ...
              sheet_name, mean_amp, mean_F1, mean_F2);

      % Stockage pour le graphe final
      F1_means(end+1) = mean_F1;
      F2_means(end+1) = mean_F2;
      labels{end+1} = sheet_name;

      figure('Name', sprintf('Context: %s', sheet_name));
      set(gca, 'FontSize', 14);
      [ax, h1, h2] = plotyy(time, amplitude, time, F1);
      set(h1, 'Color', 'r', 'LineWidth', 1.5);
      set(h2, 'Color', 'g', 'LineWidth', 1.5);
      ylabel(ax(1), 'Amplitude (dB)');
      ylabel(ax(2), 'Fréquences (Hz)');
      xlabel('Temps (ms)');

      hold(ax(1), 'on');
      plot(ax(1), mean_time, mean_amp, 'or', 'MarkerFaceColor', 'r', 'MarkerSize', 8);  % point moyenne amplitude
      hold(ax(1), 'off');

      hold(ax(2), 'on');
      plot(ax(2), time, F2, 'b-', 'LineWidth', 1.5);
      plot(ax(2), mean_time, mean_F1, 'og', 'MarkerFaceColor', 'g', 'MarkerSize', 8);  % point moyenne F1
      plot(ax(2), mean_time, mean_F2, 'ob', 'MarkerFaceColor', 'b', 'MarkerSize', 8);  % point moyenne F2
      hold(ax(2), 'off');

      title(sprintf('Amplitude, F1, F2 vs Temps (%s)', sheet_name));
      legend(ax(2), {'F1', 'F2', 'F1@Moyenne', 'F2@Moyenne', 'Amplitude'}, 'Location', 'best');
      grid on;
  end


  figure('Name', 'Moyennes F1 vs F2 (tous les contextes)');
  hold on;
  scatter(F1_means, F2_means, 100, 'r', 'filled');

  for i = 1:length(F1_means)
      text(F1_means(i), F2_means(i) + 50, labels{i}, ...
          'FontSize', 10, 'Color', 'black', ...
          'HorizontalAlignment', 'center');
  end

  xlabel('F1 (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
  ylabel('F2 (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
  title('Mean F1 vs F2 for each consonantal context', 'FontSize', 14, 'FontWeight', 'bold');
  xlim([0, max(F1_means) + 500]);
  ylim([0, max(F2_means) + 500]);
  legend('F1/FF2 mean value', 'Location', 'northeast');
  grid on;
  hold off;
end

