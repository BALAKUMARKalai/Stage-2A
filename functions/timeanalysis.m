function timeanalysis(filenames)
  pkg load io;
  output_file = 'maxima_percentagesKSIE.xlsx';
  headers = {'Context', 'Amp_max (%)','Amp_segment (1-6)' ,'F1_maxt(%)','F1_segment (1-6)', 'F2_maxt (%)', ...
             'F2_segment (1-6)','F1max','Time(F1_max)','Length','F1maxrange'};

  for f = 1:length(filenames)
    filename = filenames{f};
    [~, sheets] = xlsfinfo(filename);
    data_table = cell(length(sheets), length(headers));

    for i = 1:length(sheets)
      sheet_name = sheets{i};
      data = xlsread(filename, sheet_name);

      time = data(:, 1);
      amplitude = data(:, 2);
      F0 = data(:, 3);
      F1 = data(:, 4);
      F2 = data(:, 5);

      valid = ~any(isnan([time, amplitude, F1, F2]), 2);
      time = time(valid);
      amplitude = amplitude(valid);
      F1 = F1(valid);
      F2 = F2(valid);

      if isempty(time)
        continue;
      endif

      len_time = length(time);
      [~, idx_max_amp] = max(amplitude);
      [~, idx_max_F1] = max(F1);
      [~, idx_max_F2] = max(F2);
      F1_min = min(F1);

      t_start = min(time);
      t_end = max(time);
      t_F1max = time(idx_max_F1);
      rel_Amp = ((time(idx_max_amp) - t_start) / (t_end - t_start)) * 100;
      rel_F1 = ((t_F1max - t_start) / (t_end - t_start)) * 100;
      rel_F2 = ((time(idx_max_F2) - t_start) / (t_end - t_start)) * 100;

      intervalle = zeros(6, 2);
      for j = 1:6
        intervalle(j, :) = [floor(len_time * (j - 1) / 6) + 1, floor(len_time * j / 6)];
      endfor

      intervallef = zeros(4, 2);
      for k = 1:4
        intervallef(k,:) = [F1_min + 50*(k - 1), F1_min + 50*k];
      endfor

      % Segment d’appartenance (1–6 ou 1–4)
      rel_Amp_int = 0;
      rel_F1_int = 0;
      rel_F2_int = 0;
      F1maxrange = 0;

      for j = 1:6
        if idx_max_amp >= intervalle(j,1) && idx_max_amp <= intervalle(j,2)
          rel_Amp_int = j;
        endif
        if idx_max_F1 >= intervalle(j,1) && idx_max_F1 <= intervalle(j,2)
          rel_F1_int = j;
        endif
        if idx_max_F2 >= intervalle(j,1) && idx_max_F2 <= intervalle(j,2)
          rel_F2_int = j;
        endif
      endfor

      for k = 1:4
        if max(F1) >= intervallef(k,1) && max(F1) <= intervallef(k,2)
          F1maxrange = k;
        endif
      endfor

      % Remplir la table
      data_table{i, 1} = sheet_name;
      data_table{i, 2} = round(rel_Amp);
      data_table{i, 4} = round(rel_F1);
      data_table{i, 6} = round(rel_F2);
      data_table{i, 3} = rel_Amp_int;
      data_table{i, 5} = rel_F1_int;
      data_table{i, 7} = rel_F2_int;
      data_table{i, 8} = round(max(F1));
      data_table{i, 9} = round(t_F1max);
      data_table{i,10} = round(t_end - t_start);
      data_table{i,11} = F1maxrange;
    endfor

    [~, name, ~] = fileparts(filename);
    xlswrite(output_file, [headers; data_table], name);
  endfor
endfunction
