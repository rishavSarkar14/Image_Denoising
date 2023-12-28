clear
clc

% Filter Specifications
fc=input("Enter the cutoff frequency: ");
fs=input("Enter the sampling frequency: ");

order = input("Order ");      % Filter order

% Analog prototype filter design
wc = 2*pi*fc;
[num,den] = butter(order, wc, 's');

% Bilinear transform
[num_d,den_d] = bilinear(num,den,fs);

% Normalize the coefficients
b = num_d / den_d(1);
a = den_d / den_d(1);

% Plot frequency response
freqz(b,a);

% Apply the filter to a signal
x = sin(2*pi*50*(0:0.0001:1));    % Input signal
y = filter(b,a,x);                 % Filtered signal

% Plot input and output signals
t = (0:length(x)-1) / fs;
figure;
subplot(2,1,1); plot(t,x); title('Input Signal');
subplot(2,1,2); plot(t,y); title('Filtered Signal');