% writing to a serial port
% a real struggle to discover i needed to put a "\r\n" on my Serial.printf
%  statements in arduino.
close all

f_start       = 0.25
f_end         = 3.0
N_experiments = 10


frequencies = linspace(f_start,f_end,N_experiments);
frequencies_strings = string(frequencies);

   
  
for i = 1:N_experiments
    frequency_string = string(frequencies_strings{i});
    fileID = fopen(strcat(frequency_string,'.txt'),'wt')
    pause(1);
      try
   
        writeline(s,frequency_string)
    catch ME
        serialPorts = serialportlist
        I_port = input('type the index of the port for the arduino') 
        s = serialport(serialPorts{I_port},2000000)
        writeline(s,frequency_string);
%         configureCallback(s,"terminator",@readSerialData)
    end
    ThisLine = readline(s);
    while(ThisLine ~= "done")
        ThisLine = readline(s);
        fprintf(fileID,'%s',ThisLine);
    end
    fclose(fileID);
end
    flush(s)

% for disconnecting
% clear s