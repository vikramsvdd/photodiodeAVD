Iph = logspace(-6,1);  % primary photocurrent
P= 0.95.*Iph;
for i=1:length(Iph)
    K(i)=0.013/Iph(i);  % calculation for 1. Mst initial = 100
    T(i)=15384*Iph(i);
    J(i)=sqrt(1+T(i))-1;   % (please refer https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=8999582)
    M1(i)=K(i)*J(i);
%M=(0.013/Iph)*(sqrt(1+(4*Iph*10000/2.6))-1); this is the formula to be
%implemented
    I1(i)=M1(i)*Iph(i);


   
K(i)=0.016/Iph(i);  % 2. Mst initial = 80
   T(i)=9624*Iph(i);
   J(i)=sqrt(1+T(i))-1;
   M2(i)=K(i)*J(i);
 I2(i)=M2(i)*Iph(i);

   K(i)=0.022/Iph(i);   % 3. Mst initial = 60 
   T(i)=5413*Iph(i);
   J(i)=sqrt(1+T(i))-1;
   M3(i)=K(i)*J(i);
I3(i)=M3(i)*Iph(i);

   K(i)=0.033/Iph(i);   % 4. Mst initial = 40 
   T(i)=2406*Iph(i);
   J(i)=sqrt(1+T(i))-1;
   M4(i)=K(i)*J(i);
I4(i)=M4(i)*Iph(i);

   K(i)=0.0665/Iph(i);   % 5. Mst initial = 20 
   T(i)=601*Iph(i);
   J(i)=sqrt(1+T(i))-1;
   M5(i)=K(i)*J(i);
  I5(i)=M5(i)*Iph(i); 

  K(i)=0.04/Iph(i);     % 6. Mst initial=100, r=1, vb=200 (basically same Mst initial but different parameters)
  T(i)=5000*Iph(i);
  J(i)=sqrt(1+T(i))-1;
  M6(i)=K(i)*J(i);
I6(i)=M5(i)*Iph(i);

end


figure(15)
semilogx(P,M1)   % M v Iph for different values of Mph initial
 hold on

%semilogx(P,M2)
%semilogx(P,M3)
%semilogx(P,M4)
%semilogx(P,M5)
semilogx(P,M6)

xlabel("Input Power (P) (in Watts)");
ylabel("Multiplication Gain (M)");
legend('r=1.5, V_B=200 V', 'r=0.5, V_B=400 V')


%figure(2)
%loglog(P,I1)     % I v P (output characteristics)
%{
hold on
loglog(P,I2)
loglog(P,I3)
loglog(P,I4)
loglog(P,I5)
%}
%title("Output model of APD");
xlabel("Input Power (P) (in Watts)");
ylabel("Multiplied Photocurrent (I)(in Amps)");





