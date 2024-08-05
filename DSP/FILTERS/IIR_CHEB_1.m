file_path = "L:\MATLAB\DSP DATASETS\Data\genres_original\rock\rock.00099.wav";

[x, Fs] = audioread(file_path);

% FFT of non-filtered signal
X_nonfiltered = fft(x);


rp = 10; % Passband ripple in dB
rs = 35; % Stopband attenuation in dB

% Designing Chebyshev Type I filter
Wp = [200 2000]/(Fs/2); Ws = [50 2150]/(Fs/2);
[n, Wn] = cheb1ord(Wp,Ws ,rp, rs);
%n=2;
%Wn=[50,2000]/(Fs/2);
[b, a] = cheby1(n, rp, Wn, 'bandpass');

% Frequency response of the filter
figure;
freqz(b, a, linspace(0, Fs/2, 1000), Fs);

% Apply the filter to the signals
filtered_x = filter(b, a, x);
%sound(filtered_x, Fs);

% FFT of filtered signal
X_filtered = fft(filtered_x);

% Convert samples to frequencies
frequencies = (Fs/2) * linspace(-1, 1, length(x));

% Plotting the signals and their spectra
figure;

subplot(2, 1, 1);
plot(x)
xlabel("Time(s)")
ylabel("Amplitude ")
title("Original Signal")

subplot(2, 1, 2);
plot(filtered_x)
xlabel("Time(s)")
ylabel("Amplitude ")
title("Filtered Signal")

figure;
subplot(2, 1, 1);
plot(frequencies, abs(fftshift(X_nonfiltered)))
xlabel("Frequency (Hz)")
ylabel("Magnitude")
title("Original FFT Magnitude Spectrum")

subplot(2, 1, 2);
plot(frequencies, abs(fftshift(X_filtered)))
xlabel("Frequency (Hz)")
ylabel("Magnitude")
title("Filtered FFT Magnitude Spectrum")
