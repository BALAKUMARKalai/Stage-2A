function spearmanseg(filename)
  pkg load io;

  [~, sheets] = xlsfinfo(filename);  
  all_F1_seg = [];
  all_F1_value = [];
  all_context = {};

  for i = 1:length(sheets)
    [~, ~, raw] = xlsread(filename, sheets{i});
    data = raw(2:end, :);  

    if size(data, 1) > 0 && size(data, 2) >= 8
      F1_seg = cell2mat(data(:, 5));       
      F1_value = cell2mat(data(:, 8));     
      context = data(:, 1);                

      if length(F1_seg) == length(F1_value)
        all_F1_seg = [all_F1_seg; F1_seg];
        all_F1_value = [all_F1_value; F1_value];
        all_context = [all_context; context];
      endif
    endif
  endfor

  r = corr(all_F1_seg, all_F1_value, 'type', 'Spearman');
  printf("Coefficient de corrélation de Spearman (toutes versions) : ? = %.3f\n", r);

  figure;
  scatter(all_F1_value, all_F1_seg, 'b', 'filled');
  hold on;

  % Ajouter les étiquettes de contexte
  for k = 1:length(all_context)
    text(all_F1_value(k) + 1, all_F1_seg(k) + 1, all_context{k}, 'FontSize', 10);
  endfor

  xlabel('F1max (Hz)');
  ylabel('F1max segment timing');
  title(sprintf("Spearman Correlation between F1max and its Timing (speaker: JP) : ? = %.2f", r), 'FontSize', 14);

  grid on;
  hold off;
endfunction
