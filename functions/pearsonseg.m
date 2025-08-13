function pearsonseg(filename)
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

  r = corr(all_F1_seg, all_F1_value);
  printf("Coefficient de correlation Pearson (all versions) : r = %.3f\n", r);

  % Régression linéaire
  coeffs = polyfit(all_F1_value,all_F1_seg, 1);
  yfit = polyval(coeffs, all_F1_value);

  % Affichage
  figure;
  scatter(all_F1_value,all_F1_seg, 'b', 'filled');
  hold on;
  plot(all_F1_value, yfit, 'r-', 'LineWidth', 2);


  for k = 1:length(all_context)
    text(all_F1_value(k) + 1, all_F1_seg(k) + 1, all_context{k}, 'FontSize', 10);
  endfor

  xlabel('F1max (kHz)','FontSize',14);
  ylabel('F1max seg timing','FontSize',14);
title(sprintf("F1max and Timing segment Pearson Correlation (speaker: KS) : r = %.2f", ...
      corr(all_F1_value, all_F1_seg)), 'FontSize', 14);


  grid on;
  hold off;
endfunction