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
I=[1.3e6,2.6e6,5.2e6,10.4e6]; % Intensity vector in Candela Cd
P=[2000,4000,6000,8000];  %Power emitted by the LED in Watts
% For high light power case, the multiplication factor of photodiode M is a
% non linear function of primary photocurrent as given by the formula
iout = [0 0 0 0];  % primary photocurrent corresponding to a given power
ioutm = [0 0 0 0]; % multiplied photocurrent
M=[0 0 0 0];
for i=1:length(P)
    iout(i)= P(i)*q/(h*f);
    M(i) = 1/sqrt(0.055*iout(i)+1.1e-6); % The avalanche multiplication factor or attenuation factor (depends on iout and has a non-linear dependence as seen 
    ioutm(i)=M(i)*iout(i);   % multiplied photocurrent

end
iout
M
ioutm

%plotting the input-output graph, i.e power of led vs 
%photocurrent

plot(P, iout, P, ioutm, '.-'), legend('Primary-photocurrent', 'Multiplied-Photocurrent')
title('Power v  photocurrent')
xlabel('Optical Power(W)')
ylabel('Photocurrent(A)')








