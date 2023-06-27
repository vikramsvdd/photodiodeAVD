% 4-PAM Digital Communication System Modelling
numTrans = 10000; % Number of transmissions
input = zeros(1, 2*numTrans); % Matrix to store, in this case, 10,000 transmissions of 2 random bits each
encodedInput = zeros(1, numTrans); % Matrix to store contellation mapping values of 10,000 pair of input bits
%  encodedInputv=zeros(1,numTrans);
encodedOutput = zeros(1, numTrans); % Matrix to store values after transmission through noisy channel
output = zeros(1, 2*numTrans); % Matrix to store pairs of bits obtained after decoding
pBitError=zeros(1,8);
simulatedBER=zeros(1,8);
simulatedSER1=zeros(1,60);
simulatedSER2=zeros(1,60);
simulatedSER3=zeros(1,60);
simulatedSER4=zeros(1,60);
simulatedSER5=zeros(1,60);
SNR=zeros(1,60);

for miv = [100,80,60,40,20]
for z=1:60
snr= z; % in dB
SNR(z)=z; % in dB
i = 1; % Reset variables to iterate through the matrices
 j = 1;
 k = 1;
 n = 1;
 q = 1;
 errorBits = 0; % Variable to count the number of error bits after decoding
 errorSymbols = 0; % Variable to count the number of symbol errors
 snrLinear=10^(snr/10);
% now take a green led with PAM, T=1, with four different amplitudes,
% correspondingly their power vector is 3e-3,2e-2,4e-2,6e-2,
% this gets converted to a voltage vector after photodiode stage, assuming
% Mst=100, Voexp = 5e-4,0.03,0.125,0.81, but see the reality below
if(miv==100)
    Voexp=[0.0005,0.0010,0.0016,0.0021]; % modelled according to non linear M v P
%characteristics,Mstinitial=100
elseif(miv==80)
    Voexp=[0.0004,0.0008,0.0012,0.0016];%Mstinitial=80
elseif(miv==60)
    Voexp=[0.0003,0.0006,0.0009,0.0012];%Mstinitial=60
elseif(miv==40)
    Voexp=1e-3.*[ 0.2088,0.4174,0.6256,0.8337];%Mstinitial=40
elseif(miv==20)
    Voexp=1e-3.*[0.1052,0.2103,0.3154,0.4204];%Mstinitial=20
end
In=[0.0007,0.0013,0.0020,0.0027];
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
%{
 %Transmission over AWGN channel
v=5/(4*snrLinear);
noiseSamples = sqrt(v)*randn(1,numTrans);
%noisyOutput=encodedInput+noiseSamples;
noisyOutput=awgn(encodedInput,snr,'measured');
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
     %Pled(m)=noisyOutput(m)/500;  wrong!!!!!!!!!! how can power be
     %linearly mapped to voltage??????
     
     % M(m) stage
    if(miv==100)
        K(m)=0.013*0.95/Pled(m);  % 1. Mst initial = 100  K avg 39.8
         T(m)=15384*Pled(m)/0.95;  % T avg is 5.02
        J(m)=sqrt(1+T(m))-1;   % big assumption in these semilogys is that M0 or Mst initial=100 (please refer https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=8999582)
        M(m)=K(m)*J(m);   % M avg is 57.8
%M=(0.013/Iph)*(sqrt(1+(4*Iph*10000/2.6))-1); this is the formula to be
%implemented
        I(m)=M(m)*Pled(m)*0.1/0.95;
       % Vo(m)=I(m)*50;

     elseif(miv==80)
         K(m)=0.016*0.95/Pled(m);  % 1. Mst initial = 80  K avg 39.8
         T(m)=9624*Pled(m)/0.95;  % T avg is 5.02
        J(m)=sqrt(1+T(m))-1;   % big assumption in these semilogys is that M0 or Mst initial=100 (please refer https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=8999582)
        M(m)=K(m)*J(m);   % M avg is 57.8
%M=(0.013/Iph)*(sqrt(1+(4*Iph*10000/2.6))-1); this is the formula to be
%implemented
        I(m)=M(m)*Pled(m)*0.1/0.95;
       % Vo(m)=I(m)*50;

     elseif(miv==60)
         K(m)=0.022*0.95/Pled(m);  % 1. Mst initial = 60  K avg 39.8
         T(m)=5413*Pled(m)/0.95;  % T avg is 5.02
        J(m)=sqrt(1+T(m))-1;   % big assumption in these semilogys is that M0 or Mst initial=100 (please refer https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=8999582)
        M(m)=K(m)*J(m);   % M avg is 57.8
%M=(0.013/Iph)*(sqrt(1+(4*Iph*10000/2.6))-1); this is the formula to be
%implemented
        I(m)=M(m)*Pled(m)*0.1/0.95;
       % Vo(m)=I(m)*50;

     elseif(miv==40)
         K(m)=0.033*0.95/Pled(m);  % 1. Mst initial = 40  K avg 39.8
         T(m)=2406*Pled(m)/0.95;  % T avg is 5.02
        J(m)=sqrt(1+T(m))-1;   % big assumption in these semilogys is that M0 or Mst initial=100 (please refer https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=8999582)
        M(m)=K(m)*J(m);   % M avg is 57.8
%M=(0.013/Iph)*(sqrt(1+(4*Iph*10000/2.6))-1); this is the formula to be
%implemented
        I(m)=M(m)*Pled(m)*0.1/0.95;
       % Vo(m)=I(m)*50;

     elseif(miv==20)
         K(m)=0.0665*0.95/Pled(m);  % 1. Mst initial = 20  K avg 39.8
         T(m)=601*Pled(m)/0.95;  % T avg is 5.02
        J(m)=sqrt(1+T(m))-1;   % big assumption in these semilogys is that M0 or Mst initial=100 (please refer https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=8999582)
        M(m)=K(m)*J(m);   % M avg is 57.8
%M=(0.013/Iph)*(sqrt(1+(4*Iph*10000/2.6))-1); this is the formula to be
%implemented
        I(m)=M(m)*Pled(m)*0.1/0.95;
        % Vo(m)=I(m)*50;
     end
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
 if(miv==100)
    simulatedSER1(z)=errorSymbols/numTrans;
elseif(miv==80)
    simulatedSER2(z)=errorSymbols/numTrans;
elseif(miv==60)
    simulatedSER3(z)=errorSymbols/numTrans;
elseif(miv==40)
    simulatedSER4(z)=errorSymbols/numTrans;
elseif(miv==20)
    simulatedSER5(z)=errorSymbols/numTrans;
 end
 tc;
 Vo;
end
end
figure(5)
semilogy(SNR,simulatedSER1)
hold on
semilogy(SNR,simulatedSER2)
semilogy(SNR,simulatedSER3)
semilogy(SNR,simulatedSER4)
semilogy(SNR,simulatedSER5)
hold off
title('Non-Linearly Modelled System with Varying M_i')
xlabel('SNR (in dB)')
ylabel('Simulated Symbol Error Rate (SER)')
legend('M_i=100','M_i=80','M_i=60','M_i=40','M_i=20')
xlim([1 60])
ylim([0 1])






