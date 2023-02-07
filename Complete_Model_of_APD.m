Iph = logspace(-6,1);  % primary photocurrent
P= 0.95.*Iph;
for i=1:length(Iph)
    K(i)=0.013/Iph(i);  % 1. Mst initial = 100
    T(i)=15384*Iph(i);
    J(i)=sqrt(1+T(i))-1;   % big assumption in these plots is that M0=100 (please refer https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=8999582)
    M1(i)=K(i)*J(i);
%M=(0.013/Iph)*(sqrt(1+(4*Iph*10000/2.6))-1); this is the formula to be
%implemented
    I(i)=M1(i)*Iph(i);


   %{
K(i)=0.016/Iph(i)   % 2. Mst initial = 80
   T(i)=9624*Iph(i);
   J(i)=sqrt(1+T(i))-1;
   M2(i)=K(i)*J(i);

   K(i)=0.022/Iph(i)   % 3. Mst initial = 60 
   T(i)=5413*Iph(i);
   J(i)=sqrt(1+T(i))-1;
   M3(i)=K(i)*J(i);

   K(i)=0.033/Iph(i)   % 4. Mst initial = 40 
   T(i)=2406*Iph(i);
   J(i)=sqrt(1+T(i))-1;
   M4(i)=K(i)*J(i);

   K(i)=0.0665/Iph(i)   % 5. Mst initial = 20 
   T(i)=601*Iph(i);
   J(i)=sqrt(1+T(i))-1;
   M5(i)=K(i)*J(i);
   
   %}


end


figure(1)
semilogx(P,M1)   % M v Iph for different values of Mph initial
% hold on
%{
semilogx(P,M2)
semilogx(P,M3)
semilogx(P,M4)
semilogx(P,M5)
%}
xlabel("Input Power(W)");
ylabel("Multiplication Gain (Mph)");

figure(2)
loglog(P,I)     % I v P
title("Output model of APD");
xlabel("Input Power(W)");
ylabel("Multiplied Photocurrent (A)");




