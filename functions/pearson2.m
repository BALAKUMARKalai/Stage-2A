function pearson2(filename)
  pkg load io;

  [~, sheets] = xlsfinfo(filename);
  all_F1_timing = [];
  all_F1_maxval = [];
  all_context = {};
  group_colors = [];  

  couleurs = {'b', 'r', 'g', 'm', 'c', 'k'};  
  nb_couleurs = length(couleurs);

  feuille_count = 0;

  for i = 1:length(sheets)
    feuille_count += 1;
    group_index = ceil(feuille_count / 3);  

    [~, ~, raw] = xlsread(filename, sheets{i});
    data = raw(2:end, :); 

    if size(data, 1) > 0 && size(data, 2) >= 8
      try
        raw_timing = data(:, 4);  
        raw_f1max  = data(:, 8);  
        context = data(:, 1);     

        F1_timing = str2double(cellfun(@num2str, raw_timing, 'UniformOutput', false));
        F1_maxval = str2double(cellfun(@num2str, raw_f1max, 'UniformOutput', false));

        valid = ~isnan(F1_timing) & ~isnan(F1_maxval);
        F1_timing = F1_timing(valid);
        F1_maxval = F1_maxval(valid);
        context = context(valid);

        all_F1_timing = [all_F1_timing; F1_timing];
        all_F1_maxval = [all_F1_maxval; F1_maxval];
        all_context = [all_context; context];
        group_colors = [group_colors; repmat(group_index, length(F1_timing), 1)];

      catch
        disp(['Erreur dans la feuille : ' sheets{i}]);
      end
    else
      disp(['Feuille ignorée (données incomplètes) : ' sheets{i}]);
    end
  endfor

  if isempty(all_F1_timing)
    warning("Aucune donnée exploitable extraite.");
    return;
  endif

  % Corrélation de Pearson
  r = corr(all_F1_maxval, all_F1_timing);
  printf("Corrélation Pearson : r = %.3f\n", r);

  % Régression linéaire
  coeffs = polyfit(all_F1_maxval, all_F1_timing, 1);
  yfit = polyval(coeffs, all_F1_maxval);

  % Tracé
  figure;
  hold on;

  % Affichage par groupes de couleurs
  unique_groups = unique(group_colors);
  for g = 1:length(unique_groups)
    idx = group_colors == unique_groups(g);
    col = couleurs{mod(g-1, nb_couleurs) + 1};  % cyclique si >6 groupes
    scatter(all_F1_maxval(idx), all_F1_timing(idx), 50, col, 'filled');
  end

  plot(all_F1_maxval, yfit, 'k--', 'LineWidth', 2);
  xlabel('F1 max (Hz)', 'FontSize', 14);
  ylabel('F1 timing (% of vowel duration)', 'FontSize', 14);
  title(sprintf('F1 timing vs F1 max (r = %.2f)', r), 'FontSize', 15);
  grid on;

  % Étiquettes contexte
  for k = 1:length(all_context)
    text(all_F1_maxval(k) + 3, all_F1_timing(k) + 1, all_context{k}, 'FontSize', 9);
  endfor
endfunction
