function spearman(filename)
  pkg load io;

  [~, sheets] = xlsfinfo(filename);
  all_F1_percent = [];
  all_F1_value = [];
  all_context = {};

  for i = 1:length(sheets)
    [~, ~, raw] = xlsread(filename, sheets{i});
    data = raw(2:end, :);

    if size(data, 1) > 0 && size(data, 2) >= 8
      F1_percent = cell2mat(data(:, 4));
      F1_value = cell2mat(data(:, 8));
      context = data(:, 1);

      if length(F1_percent) == length(F1_value)
        all_F1_percent = [all_F1_percent; F1_percent];
        all_F1_value = [all_F1_value; F1_value];
        all_context = [all_context; context];
      endif
    endif
  endfor

  % Corrélation de Spearman (rang)
  rx = rankvec(all_F1_value);
  ry = rankvec(all_F1_percent);
  rho = corr(rx, ry);  % Pearson sur les rangs

  printf("Spearman rho = %.3f\n", rho);
  
  %regression linéaire
  coeffs = polyfit(rx,ry,1);
  yfit = polyval(coeffs,rx);

  % Affichage du nuage de rangs
  figure;
  scatter(rx, ry, 'b', 'filled');
  hold on;
  plot(rx,yfit, 'r','LineWidth',2);
  for k = 1:length(all_context)
    text(rx(k) + 0.2, ry(k) + 0.2, all_context{k}, 'FontSize', 10);
  endfor

  xlabel('Rank F1max','FontSize', 14);
  ylabel('Rank of the Timing of F1max','FontSize', 14);
  title(sprintf("F1max and Timing Spearman correlation (JP) : (rho = %.2f)", rho), 'FontSize', 14);
  grid on;
  axis equal;
  
endfunction

% Fonction auxiliaire pour classer les valeurs
function r = rankvec(x)
  [sorted_x, idx] = sort(x);
  r = zeros(size(x));
  i = 1;
  while i <= length(x)
    j = i;
    % Trouver les ex-aequo
    while j < length(x) && sorted_x(j) == sorted_x(j+1)
      j = j + 1;
    endwhile
    % Attribuer le rang moyen
    avg_rank = mean(i:j);
    r(idx(i:j)) = avg_rank;
    i = j + 1;
  endwhile
  r = r(:);
endfunction

