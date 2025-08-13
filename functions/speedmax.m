function speedmax (filenames)
  pkg load io;


  palette = {'b','r','g','m','c','k'};
  ncol    = numel(palette);

  F1_max_vals = [];
  speeds      = [];
  labels      = {};
  point_colors = {};   
  total_points = 0;

  for f = 1:length(filenames)
    filename = filenames{f};
    [~, sheets] = xlsfinfo(filename);

    
    group  = ceil(f / 3);                      
    col_id = mod(group-1, ncol) + 1;           
    file_color = palette{col_id};

    for s = 1:length(sheets)
      sheetname = sheets{s};
      [num, ~, raw] = xlsread(filename, sheetname);
      if columns(num) < 4, continue; end

      time = num(:,1);  F1 = num(:,4);
      valid = ~isnan(time) & ~isnan(F1);
      time  = time(valid);  F1 = F1(valid);
      if isempty(time), continue; end

      t_onset  = time(1);  F1_onset = F1(1);
      [F1_max, idx] = max(F1);  t_F1max = time(idx);
      if t_F1max == t_onset, continue; end   

      speed = (F1_max - F1_onset) / (t_F1max - t_onset);

     
      F1_max_vals(end+1,1) = F1_max;
      speeds(end+1,1)      = speed;
      point_colors{end+1,1}= file_color;   
      total_points        += 1;
    endfor
  endfor

  printf(">>> Total de points tracés : %d\n", total_points);


  figure; hold on;
  for k = 1:numel(F1_max_vals)
    scatter(F1_max_vals(k), speeds(k), 50, point_colors{k}, 'filled');
    text(   F1_max_vals(k)+3, speeds(k)+0.05, labels{k}, ...
            'FontSize', 10, 'Interpreter', 'none');
  endfor
  xlabel('F1_{max} (Hz)',    'FontSize', 12);
  ylabel('F1 speed (Hz/ms)', 'FontSize', 12);
  title ('F1_{max} vs F1 speed (onglide slope)', 'FontSize', 13);
  grid on;
endfunction
