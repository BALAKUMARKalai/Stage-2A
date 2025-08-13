function pearson(filename)
  pkg load io;

  [~, sheets] = xlsfinfo(filename);
  all_F1_timing = [];
  all_F1_maxval = [];
  all_context = {};

  for i = 1:length(sheets)
    disp(['Lecture de la feuille : ' sheets{i}]);

    [~, ~, raw] = xlsread(filename, sheets{i});
    data = raw(2:end, :);  % Enlever les en-t�tes

    if size(data, 1) > 0 && size(data, 2) >= 8
      try
        raw_timing = data(:, 4);  
        raw_f1max  = data(:, 8); 
        context = data(:, 1);     

        disp('? Premi�res valeurs F1 timing (%):'); disp(raw_timing(1:min(5, end)));
        disp('? Premi�res valeurs F1 max (Hz):'); disp(raw_f1max(1:min(5, end)));

        % Conversion s�curis�e
        F1_timing = str2double(cellfun(@num2str, raw_timing, 'UniformOutput', false));
        F1_maxval = str2double(cellfun(@num2str, raw_f1max, 'UniformOutput', false));

        valid = ~isnan(F1_timing) & ~isnan(F1_maxval);
        F1_timing = F1_timing(valid);
        F1_maxval = F1_maxval(valid);
        context = context(valid);

        all_F1_timing = [all_F1_timing; F1_timing];
        all_F1_maxval = [all_F1_maxval; F1_maxval];
        all_context = [all_context; context];


  % Corr�lation de Pearson
  r = corr(all_F1_maxval, all_F1_timing);
  printf("? Corr�lation Pearson (F1max vs timing %%): r = %.3f\n", r);

  % R�gression lin�aire
  coeffs = polyfit(all_F1_maxval, all_F1_timing, 1);
  yfit = polyval(coeffs, all_F1_maxval);

  % Trac� du graphique
  figure;
  scatter(all_F1_maxval, all_F1_timing, 50, 'b', 'filled'); hold on;
  plot(all_F1_maxval, yfit, 'r-', 'LineWidth', 2);
  xlabel('F1 max (Hz)', 'FontSize', 14);
  ylabel('F1 timing (% of vowel duration)', 'FontSize', 14);
  title(sprintf('F1 timing vs F1 max Pearson correlation (r = %.2f)', r), 'FontSize', 14);
  grid on;

  % �tiquettes de contexte
  for k = 1:length(all_context)
    text(all_F1_maxval(k)+3, all_F1_timing(k)+1, all_context{k}, 'FontSize', 9);
  endfor
endfunction
