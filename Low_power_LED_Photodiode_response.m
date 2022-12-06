%Simple APD Photodiode Modelling
%Design-Parameters
Ub=200; % Breakdown voltage in V
r=1.5; % Si Photodiode (Avalanche)
Uo=5; %Supply voltage in V
Rb=1; %resistance coupled with APD in ohms
Rv=10; % resistance coupled with supply voltage in ohms
Ir=0.00002; %reverse saturation current in amps
h = 6.626068e-34;%plank's constant
q = 1.6e-19; %charge of an electron
f= 5.4e14; % frequency of green light ( we are using a green-LED)



%problem start
I=[6.83,13.6,27.3,54.6]; % Intensity vector in Candela Cd
P=[0.01,0.02,0.03,0.04];  %Power emitted by the LED in Watts
% For Low light power case, the multiplication factor of photodiode M is a
% constant as given by the formula
M = 1/(r*(Uo/Ub)) % The avalanche multiplication factor
iout = [0 0 0 0];  % primary photocurrent corresponding to a given power
ioutm = [0 0 0 0]; % multiplied photocurrent
for i=1:length(P)
    iout(i)= P(i)*q/(h*f);
    ioutm(i)=M*iout(i);

end
iout
ioutm

%plotting the input-output graph, i.e power of led vs 
%photocurrent




plot(P, iout, P, ioutm, '.-'), legend('Primary-photocurrent', 'Multiplied-Photocurrent')
title('Power v  photocurrent')
xlabel('Optical Power(W)')
ylabel('Photocurrent(A)')










