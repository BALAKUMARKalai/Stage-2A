% main.m
file2j_I = 'C:/Users/kalai/stage/data/2j_I_.xlsx';  % Spécifie le chemin du fichier à traiter
file3j_I = 'C:/Users/kalai/stage/data/3j_I_.xlsx';  
file1j_I = 'C:/Users/kalai/stage/data/1j_I_.xlsx';
file1k_I = 'C:/Users/kalai/stage/data/1k_I_.xlsx';  
file2k_I = 'C:/Users/kalai/stage/data/2k_I_.xlsx';  
file3k_I = 'C:/Users/kalai/stage/data/3k_I_.xlsx';  
file1r_I = 'C:/Users/kalai/stage/data/1r_I_.xlsx'; 

file1j_E = 'C:/Users/kalai/stage/data/1j_E_.xlsx';
file2j_E = 'C:/Users/kalai/stage/data/2j_E_.xlsx';
file3j_E = 'C:/Users/kalai/stage/data/3j_E_.xlsx';
file1k_E = 'C:/Users/kalai/stage/data/1k_E_.xlsx';
file2k_E = 'C:/Users/kalai/stage/data/2k_E_.xlsx';
file3k_E = 'C:/Users/kalai/stage/data/3k_E_.xlsx';

%average(filename);  % Appelle la fonction avec le fichier comme argument
%F1max(filename);
%ampmax(filename);
%centralvalue(filename);

%average(file3k_I)
%ampmax(file1k_E)



files_ji = {file1j_I, file2j_I, file3j_I};
files_ki = {file1k_I, file2k_I, file3k_I};
files_je = {file1j_E, file2j_E, file3j_E};
files_ke = {file1k_E, file2k_E, file3k_E};
files_jie = {file1j_I, file2j_I, file3j_I,file1j_E, file2j_E, file3j_E};
files_kie = {file1k_I, file2k_I, file3k_I,file1k_E, file2k_E, file3k_E};

strategie_plot(files_je)
%plotspeaker(files_j)

%timeanalysis(files_kie)
%figure;
%plotspeaker(file1j_I_p)
%figure;
%average(file1j_I)
%figure;
%F1max(file1j_I)
%figure;
%figure;
%F1max(file1j_I)
%figure;
%plotspeaker({file1j_I})
%
%plotspeaker({file1j_I, file2j_I})
%

%plotspeaker(files_j)
%meanplotspeaker(files_j)
%pearson2('maxima_percentagesKSIE.xlsx')
%spearman('maxima_percentagesJP.xlsx')
%pearson2('maxima_percentagesJPIE.xlsx')
%timeanalysis(files_k)
%pearson('maxima_percentagesKSE.xlsx')
%timeanalysis(files_ke)
%plotspeaker({file1k_I})
%

%speedmax(files_jie)
%
%comparestrat(file1k_I)
%comparestrat_avg(files_ki)
%timeanalysis(files_ki)
%pearson("maxima_percentagesKS.xlsx")
%comparestrat(file1k_I)
%comparestrat(file2k_I)
%comparestrat(file3k_I)
%comparestrat_avg(files_ki)

%comparestrat_subplots(files_ki)
%pearson('maxima_percentagesJPIE.xlsx')
%pearsonseg('maxima_percentagesKSIE.xlsx')
%pearsonseg('maxima_percentagesKS.xlsx')
%comparestrat_avg(files_ki)
%plotspeaker({file2k_I})
%plotspeaker({file1k_I})
%plotspeaker({file3k_I})

%
%plotspeaker(files_ki)

%
%centralvalue(file1j_I)
%pearsonrangeall('maxima_percentagesJP.xlsx')

%comparestrat(file1j_I)
%plotspeaker({file3k_E})
%timeanalysis(files_ki)
%pearsonrangeall('maxima_percentagesKS.xlsx')
%strategie_plot(files_ki)

%pearsonseg('maxima_percentagesKS.xlsx')