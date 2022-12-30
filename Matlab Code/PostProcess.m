close all
clear all
clc
% control loop at 1kHz
% datalogging at 100Hz
load sinFollowThreeHz100psi.mat 


%pressure as  a function of levels
dt = 0.01;
N = height(sinFollowThreeHrtz100psi);
t = 0:dt:(N-1)*dt;

plvlToPress = @(x) 0.13529*x - 12.4282;
CommandPressure_psi ...
= plvlToPress(sinFollowThreeHrtz100psi.CommandPressure);
pressure_psi...
    = plvlToPress(sinFollowThreeHrtz100psi.Pressure);
plot(t,CommandPressure_psi)
hold on
plot(t,pressure_psi)
I = find(islocalmin(CommandPressure_psi))
plot(t(I),CommandPressure_psi(I),'ro')
phasePress      = [];
phaseCommand    = [];
phaseInVoltage  = [];
phaseOutVoltage = [];
inVolt   = sinFollowThreeHrtz100psi.FluidInVoltage;
outVolt  = sinFollowThreeHrtz100psi.FluidOutVoltage;
for i = 1:length(I)-1
    if (i == 1)
        phasePress   = pressure_psi       (I(i):I(i)+33)';
        phaseCommand = CommandPressure_psi(I(i):I(i)+33)';
        phaseInVoltage  = inVolt(I(i):I(i)+33)';
        phaseOutVoltage = outVolt(I(i):I(i)+33)';
    else
        temp = pressure_psi(I(i):I(i)+33)'
    phasePress   = [phasePress;temp];
        temp         = CommandPressure_psi(I(i):I(i)+33)'
    phaseCommand = [phaseCommand;temp];
        temp         = inVolt(I(i):I(i)+33)';
    phaseInVoltage  = [phaseInVoltage;temp];
        temp         = outVolt(I(i):I(i)+33)';
    phaseOutVoltage = [phaseOutVoltage;temp];
        
    end
end
figure
tphase = linspace(0,1,34)
plot(tphase,phasePress','b')
hold on
plot(tphase,phaseCommand','k')
plot(tphase,phaseInVoltage'/255*10,'r')
plot(tphase,phaseOutVoltage'/255*10,'g')
xlabel("Phase Time $[t/\tau]$",'Interpreter','latex')
ylabel("Pressure [PSI]",'Interpreter','latex')
grid on