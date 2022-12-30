close all
clear all
clc
RunDesignator = 'experiments-Dec 12-21-2022';
Experiments = dir('../Experiments/');
I_Experiments = find(not([Experiments.isdir]));

 for i = I_Experiments
    filename = strcat(Experiments(i).folder,'\',Experiments(i).name)
    Experiments(i).ExperimentalTimeSeriesData = ...
        importExperimentData(filename);
    STR = fileread(filename);
    S = regexp(STR,'frequency:    .* Hz','match');
    Sp = regexp(S,'\d*\.\d*','match');
    Experiments(i).frequency = str2double(Sp{1})
   
    
    
    
    
 end
 save(RunDesignator,'Experiments')


