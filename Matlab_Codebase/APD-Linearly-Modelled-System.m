% 4-PAM Digital Communication System Modelling assuming Linear P v I
% response from the APD 
% also by default the code is for noisy case, for noiseless uncomment the
% stuff i marked as noiseless and comment the noisy stuff
numTrans = 10000; % Number of transmissions
input = zeros(1, 2*numTrans); % Matrix to store, in this case, 10,000 transmissions of 2 random bits each
encodedInput = zeros(1, numTrans); % Matrix to store constellation mapping values of 10,000 pair of input bits
encodedInputv=zeros(1,numTrans);
encodedOutput = zeros(1, numTrans); % Matrix to store values after transmission through noisy channel
output = zeros(1, 2*numTrans); % Matrix to store pairs of bits obtained after decoding
pBitError=zeros(1,8);
simulatedSER=zeros(1,60);
SNR=zeros(1,60);

for z=1:60
snr= z; % in dB
SNR(z)=z;
i = 1; % Reset variables to iterate through the matrices
 j = 1;
 k = 1;
 n = 1;
 q = 1;
 errorBits = 0; % Variable to count the number of error bits after decoding
 errorSymbols = 0; % Variable to count the number of symbol errors
 snrLinear=10^(snr/10);
% now take a green led with PAM, T=1, with four different amplitudes,
% correspondingly their power vector is 10^-6,6*10^-5,2.5*10^-4,15.4*10^-4,
% this gets converted to a voltage vector after photodiode stage, assuming
% Mst=100 (in report it is Mo sorry for the difference in conventions :[ ), Voexp = 5e-4,0.03,0.125,0.81, but see the reality below
Voexp=[5e-4,0.03,0.125,0.81];  % modelled according to constant M v P characteristics 
In=[6.83e-4,0.04,0.17,1.05];  % Intensity vector for PAM-4
tc=[0,0,0,0];


 % Information source modelling

 while i <= 2*numTrans % Input random bit combinations in matrix

 twoBits = round(rand(1, 2)); % Random bit generator for a pair of bits with equal probability for 0 and 1
 input(i:i+1) = twoBits;
 i = i + 2;
 end
 % Encoding
 for k=1:numTrans % Iterate through input sequence of transmissions
 
 if input(j:j+1) == [0 0] % Assign appropriate constellation value to pair of bits
 inputSymbol = In(1);
 inputSymbolv=Voexp(1);
  tc(1)=tc(1)+1;
 elseif input(j:j+1) == [0 1]
 inputSymbol = In(2);  % strictly speaking as it is a VLC system, it should be intensity here but for convenience directly mapping to voltage
 inputSymbolv=Voexp(2);
 tc(2)=tc(2)+1;
 elseif input(j:j+1) == [1 1]
 inputSymbol = In(3);
 inputSymbolv=Voexp(3); 
 tc(3)=tc(3)+1;
 elseif input(j:j+1) == [1 0]
 inputSymbol = In(4);
 inputSymbolv=Voexp(4);
  tc(4)=tc(4)+1;

 end
 j = j + 2;
 encodedInput(k) = inputSymbol; % Store obtained values in appropriate matrix
 encodedInputv(k) = inputSymbolv;
 k = k + 1;

 end
 %encodedInput

 % assume green light of wavelength 555 nm
 Pled=zeros(1,numTrans);  % power emitted from led per symbol
 
 M=zeros(1,numTrans); % signal multiplication factor of AVD , changes with Pled
 I=zeros(1,numTrans);  % final photodiode current 
 Vo=zeros(1,numTrans);  %output voltage from photodiode
%{
 %Transmission over AWGN channel
v=5/(4*snrLinear);
noiseSamples = sqrt(v)*randn(1,numTrans);
noisyOutput=encodedInput+noiseSamples;
%}
% APD reception of signal

 for m = 1:numTrans
%{     
if(encodedInput(m)==Voexp(1))         % noiseless case 
         Pled(m)=1e-6;
        
     elseif(encodedInput(m)==Voexp(2))
         Pled(m)=6e-5;
          
     elseif(encodedInput(m)==Voexp(3))
         Pled(m)=2.5e-4;
     elseif(encodedInput(m)==Voexp(4))
         Pled(m)=15.4e-4; 
end
%}   

     Pled(m)=encodedInput(m)*1.464e-3;
    % Pled(m)=noisyOutput(m)/500;
     
     % M(m) stage
     K(m)=0.013*0.95/Pled(m);  % 1. Mst initial = 100  K avg 39.8
     T(m)=15384*Pled(m)/0.95;  % T avg is 5.02
     J(m)=sqrt(1+T(m))-1;   % big assumption in these plots is that Mo or Mst initial=100 (please refer https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=8999582)
     M(m)=K(m)*J(m);   % M avg is 57.8
%M=(0.013/Iph)*(sqrt(1+(4*Iph*10000/2.6))-1); this is the formula to be
%implemented which i have implemented in the above lines
    I(m)=M(m)*Pled(m)*0.1/0.95;
    Vo(m)=I(m)*50;

 end
  var=mean(I.^2)./snrLinear;
  noise=wgn(1,numTrans,var,'linear');
  noisyoutput=I+noise;
  Vo=noisyoutput.*50;



% cal Vo avg is 0.16, actually Pled avg is 0.00031 , beta avg is 0.422







 % Detector modelling
 for m = 1:numTrans % Iterate through noisy signal values and assign appropriate level to noisy constellation value
 if Vo(m)>=Voexp(4)
    outputSymbol = Voexp(4);
 elseif(Vo(m)<Voexp(4)) && (Vo(m)>=(Voexp(3)+Voexp(4))/2)
    outputSymbol = Voexp(4);
 elseif Vo(m)>=Voexp(3)
     outputSymbol = Voexp(3);
 elseif(Vo(m)<Voexp(3)) && (Vo(m)>=(Voexp(2)+Voexp(3))/2)
    outputSymbol = Voexp(3);
 elseif Vo(m)>=Voexp(2)
    outputSymbol = Voexp(2);
 elseif(Vo(m)<Voexp(2)) && (Vo(m)>=(Voexp(1)+Voexp(2))/2)
    outputSymbol = Voexp(2);
 else
    outputSymbol = Voexp(1);
 end
 encodedOutput(m) = outputSymbol; % Store obtained value in appropriate matrix
 end
 %Vo
 
 
 % Decoding
 while n < numTrans % Iterate through noisy output constellation values

 if encodedOutput(n) == Voexp(4) % Assign appropriate pair of bits to each value
 output(q:q+1) = [1 0];
 elseif encodedOutput(n) == Voexp(3)
 output(q:q+1) = [1 1];
 elseif encodedOutput(n) == Voexp(2)
 output(q:q+1) = [0 0];
 output(q:q+1) = [0 1];
 elseif encodedOutput(n) == Voexp(1)
 end

 q = q + 2;
 n = n + 1;

 end

 % determine symbol error
 for l= 1:numTrans
     if encodedOutput(l)~=encodedInputv(l)
         errorSymbols=errorSymbols+1;
     end
 end
 
 errorSymbols;
 %encodedInput
% Vo
% encodedOutput
 simulatedSER(z)=errorSymbols/numTrans;
 tc;



end
%SNR
%simulatedSER
figure
semilogy(SNR,simulatedSER)
title('Linearly Modelled System with M_i=100')
xlabel('SNR (in dB)')
ylabel('Simulated Symbol Error Rate (SER)')






