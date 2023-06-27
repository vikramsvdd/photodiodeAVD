% 4-PAM Digital Communication System Modelling
% Important note : for detailed comments refer to
% APD-Linearly-Modelled-System.m program as all the programs are similar to
% this code with modifications and only the modifications will be explained
% in this code/following codes

% This code is for non-linearly modelled PAM-4 based VLC system (taking
% into account the varying nature of M with P)
numTrans = 10000; % Number of transmissions
input = zeros(1, 2*numTrans); % Matrix to store, in this case, 10,000 transmissions of 2 random bits each
encodedInput = zeros(1, numTrans); % Matrix to store contellation mapping values of 10,000 pair of input bits
%  encodedInputv=zeros(1,numTrans);
encodedOutput = zeros(1, numTrans); % Matrix to store values after transmission through noisy channel
output = zeros(1, 2*numTrans); % Matrix to store pairs of bits obtained after decoding
pBitError=zeros(1,8);
simulatedBER=zeros(1,8);
snr= 60 % in dB
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
% Mst=100, Voexp = 5e-4,0.03,0.125,0.81, but see the reality below
%Voexp=[5.2e-4,0.026,0.08,0.265]; % modelled according to non linear M v P
%characteristics,Mstinitial=100
%Voexp=[4.04e-4,0.0214,0.070,0.246];%Mstinitial=80
%Voexp=[3.12e-4,0.017,0.0613,0.2339];%Mstinitial=60
%Voexp=[2.088e-4,0.0121,0.0459,0.2003];%Mstinitial=40
Voexp=[1.05e-4,0.0063,0.0253,0.1347];%Mstinitial=20
In=[6.83e-4,0.04,0.17,1.05];
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
 inputSymbol=In(2);
 inputSymbolv=Voexp(2);
 tc(2)=tc(2)+1;
 elseif input(j:j+1) == [1 1]
 inputSymbol=In(3); 
 inputSymbolv=Voexp(3);
 tc(3)=tc(3)+1;
 elseif input(j:j+1) == [1 0]
 inputSymbol=In(4);
 inputSymbolv=Voexp(4);
  tc(4)=tc(4)+1;

 end
 j = j + 2;
 encodedInput(k) = inputSymbol; % Store obtained values in appropriate matrix
 encodedInputv(k) = inputSymbolv;
 k = k + 1;

 end
 encodedInput;

 % assume green light of wavelength 555 nm
 Pled=zeros(1,numTrans);  % power emitted from led per symbol
 
 M=zeros(1,numTrans); % signal multiplication factor of AVD , changes with Pled
 I=zeros(1,numTrans);  % final photodiode current 
 Vo=zeros(1,numTrans);  %output voltage from photodiode

 %Transmission over AWGN channel
v=5/(4*snrLinear);
noiseSamples = sqrt(v)*randn(1,numTrans);
noisyOutput=encodedInput+noiseSamples;

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

     

     Pled(m)=noisyOutput(m)*1.464e-3;
     %Pled(m)=noisyOutput(m)/500;  wrong!!!!!!!!!! how can power be
     %linearly mapped to voltage??????
     
     % M(m) stage
     K(m)=0.0665*0.95/Pled(m);  % 1. Mst initial = 100  K avg 39.8 % change Mst intitial and track how the system responds!
     T(m)=601*Pled(m)/0.95;  % T avg is 5.02
     J(m)=sqrt(1+T(m))-1;   % big assumption in these plots is that M0 or Mst initial=100 (please refer https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=8999582)
     M(m)=K(m)*J(m);   % M avg is 57.8
%M=(0.013/Iph)*(sqrt(1+(4*Iph*10000/2.6))-1); this is the formula to be
%implemented
    I(m)=M(m)*Pled(m)*0.1/0.95;
    Vo(m)=I(m)*50;

 end
 


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
 simulatedSER=errorSymbols/numTrans
 tc;
 Vo;







