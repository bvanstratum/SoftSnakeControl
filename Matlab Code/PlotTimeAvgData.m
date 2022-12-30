function PlotTimeAvgData(Data,myFigure,frequency,dt,I_fig)

%pressure as  a function of levels
N = height(Data);
t = 0:dt:(N-1)*dt;

plvlToPress = @(x) 0.13529*x - 12.4282;
CommandPressure_psi ...
= plvlToPress(Data.pressureCommanded);
pressure_psi...
    = plvlToPress(Data.pressure);
figure
plot(t,CommandPressure_psi)
hold on
plot(t,pressure_psi)
I = find(islocalmin(CommandPressure_psi))
plot(t(I),CommandPressure_psi(I),'ro')
phasePress      = [];
phaseCommand    = [];
phaseInVoltage  = [];
phaseOutVoltage = [];
inVolt   = Data.fluidInVoltage;
outVolt  = Data.fluidOutVoltage;
delta_I = min(diff(I));
for i = 1:length(I)-1
    if (i == 1)
        phasePress   = pressure_psi       (I(i):I(i)+delta_I)';
        phaseCommand = CommandPressure_psi(I(i):I(i)+delta_I)';
        phaseInVoltage  = inVolt(I(i):I(i)+delta_I)';
        phaseOutVoltage = outVolt(I(i):I(i)+delta_I)';
    else
        temp = pressure_psi(I(i):I(i)+delta_I)'
    phasePress   = [phasePress;temp];
        temp         = CommandPressure_psi(I(i):I(i)+delta_I)'
    phaseCommand = [phaseCommand;temp];
        temp         = inVolt(I(i):I(i)+delta_I)';
    phaseInVoltage  = [phaseInVoltage;temp];
        temp         = outVolt(I(i):I(i)+delta_I)';
    phaseOutVoltage = [phaseOutVoltage;temp];
        
    end
end
figure(myFigure)
subplot(2,5,I_fig)
tphase = linspace(0,1,delta_I+1)
plot(tphase,phasePress','b')
hold on
plot(tphase,phaseCommand','k')
plot(tphase,phaseInVoltage'/255*10,'r')
plot(tphase,phaseOutVoltage'/255*10,'g')
title(sprintf('%2.3g Hz',frequency))
xlabel("Phase Time $[t/\tau]$",'Interpreter','latex')
ylabel("Pressure [PSI]",'Interpreter','latex')
grid on