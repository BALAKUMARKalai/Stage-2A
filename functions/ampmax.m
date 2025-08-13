function ampmax(filename)

pkg load io;  
[~, sheets] = xlsfinfo(filename);  

F1_refs = [];
F2_refs = [];
labels = {};

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
    
    
    [amp_max, idx_maxAmp] = max(amplitude);
    F1_ref = F1(idx_maxAmp);
    F2_ref = F2(idx_maxAmp);
    time_ref = time(idx_maxAmp);


% --- Get indices of maxima ---
[~, idx_maxF1] = max(F1);
[~, idx_maxAmp] = max(amplitude);
[~, idx_maxF2] = max(F2);


rel_F1 = time(idx_maxF1) / time(end);
rel_Amp = time(idx_maxAmp) / time(end);
rel_F2 = time(idx_maxF2) / time(end);

% --- Display the percentages for each context ---
fprintf('--- %s ---\n', sheet_name);
fprintf('F1 max at %.2f%% of the recording\n', rel_F1 * 100);
fprintf('Amplitude max at %.2f%% of the recording\n', rel_Amp * 100);
fprintf('F2 max at %.2f%% of the recording\n\n', rel_F2 * 100);

    F1_refs(end+1) = F1_ref;
    F2_refs(end+1) = F2_ref;
    labels{end+1} = sheet_name;
    figure('Name', sprintf('Context: %s', sheet_name));


% Plot final 
figure('Name', 'Reference points F1 vs F2 (all consonant contexts)');
hold on;


if ~isempty(F1_refs) && ~isempty(F2_refs)
    scatter(F1_refs, F2_refs, 100, 'r', 'filled');
else
    disp('F1_refs or F2_refs are empty!');
end


for i = 1:length(F1_refs)
    text(F1_refs(i), F2_refs(i) + 50, labels{i}, ... % décalage vertical de 50 Hz
        'FontSize', 10, 'Color', 'black', ...
        'HorizontalAlignment', 'center');
end


xlabel('F1 (kHz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('F2 (kHz)', 'FontSize', 12, 'FontWeight', 'bold');


xlim([0, max(F1_refs) + 500]); % Ajout d'une marge de 500 Hz sur les axes
ylim([0, max(F2_refs) + 500]); 

title('Reference points for F1 vs F2 (for each consonantal context)', 'FontSize', 14, 'FontWeight', 'bold');
legend('Reference Ampmax points', 'Location', 'northeast');

grid on;
hold off;

end




