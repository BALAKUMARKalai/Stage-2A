function strategie_plot(filenames)
  pkg load io;
  pkg load statistics;

  strategies   = {'Central', 'Mean', 'F1max', 'Ampmax'};
  colors       = {'r', 'g', 'b', 'm'};
  markers      = {'o', 's', 'd', '^'};
  n_versions   = length(filenames);
  n_strategies = length(strategies);
  n_contexts   = 20;

  F1_values = zeros(n_contexts, n_strategies, n_versions);
  F2_values = zeros(n_contexts, n_strategies, n_versions);
  context_names = cell(n_contexts, 1);

  for f = 1:n_versions
    [~, sheets] = xlsfinfo(filenames{f});
    n_ctx = min(n_contexts, numel(sheets));  % sécurité

    for i = 1:n_ctx
      sheet_name = sheets{i};

      % Nom de contexte (une seule fois)
      clean_name = regexprep(sheet_name, '^\d+', '');
      if f == 1
        context_names{i} = clean_name;
      end

      data = xlsread(filenames{f}, sheet_name);
      if isempty(data) || size(data,2) < 5
        continue;
      end

      time      = data(:,1);
      amplitude = data(:,2);
      F1        = data(:,4);
      F2        = data(:,5);

      valid = ~any(isnan([time, amplitude, F1, F2]), 2);
      time      = time(valid);
      amplitude = amplitude(valid);
      F1        = F1(valid);
      F2        = F2(valid);

      if isempty(F1) || isempty(F2)
        continue;
      end

      n = length(F1);
      idx_central = floor(n/2);
      idx_maxF1   = find(F1 == max(F1), 1);
      idx_maxF2   = find(F2 == max(F2), 1);
      idx_maxAmp  = find(amplitude == max(amplitude), 1);

      F1_values(i,1,f) = F1(idx_central);   % Central
      F1_values(i,2,f) = mean(F1);          % Mean
      F1_values(i,3,f) = F1(idx_maxF1);     % F1max
      F1_values(i,4,f) = F1(idx_maxAmp);    % Ampmax

      F2_values(i,1,f) = F2(idx_central);   % Central
      F2_values(i,2,f) = mean(F2);          % Mean
      F2_values(i,3,f) = F2(idx_maxF2);     % F2max
      F2_values(i,4,f) = F2(idx_maxAmp);    % Ampmax
    end
  end

  
  F1_means = nanmean(F1_values, 3);
  F2_means = nanmean(F2_values, 3);

  
  out_file = 'strategies_F1_F2_summaryJe.xlsx';
  header   = [{'Context'}, strcat('F1_', strategies), strcat('F2_', strategies)];

  for f = 1:n_versions
    data_f1 = squeeze(F1_values(:,:,f));     
    data_f2 = squeeze(F2_values(:,:,f));     
    data_f  = [data_f1, data_f2];           

    cell_f = [header; [context_names num2cell(data_f)]];
    xlswrite(out_file, cell_f, sprintf('V%d', f));
  end

  data_mean = [F1_means, F2_means];          
  cell_mean = [header; [context_names num2cell(data_mean)]];
  xlswrite(out_file, cell_mean, 'Mean');
end
