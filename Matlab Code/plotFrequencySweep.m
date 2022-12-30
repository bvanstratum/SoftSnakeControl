close all
clear all
clc
load 'experiments-Dec 12-21-2022.mat'
mySubPlot = figure('Units','inches','Position',[-10 1 10 10])
subplot(5,2,1)
N = numel(Experiments)
for i = 1:N
    PlotTimeAvgData(Experiments(i).ExperimentalTimeSeriesData,...
        mySubPlot,... 
        Experiments(i).frequency,... actuation frequenc
        .002,...%sample prd 
        i)
end
