% Sample data
[X, Fs] = audioread("rock.00099.wav");
cutoff_frequency=1205;
normalized_cutoff = cutoff_frequency / (Fs/2);
[b, a] = butter(5, normalized_cutoff, 'low');
filtered_signal = filter(b, a, X);

 %Start time measurement
tic;
 %Compute FFT using the custom function
Y1 = myFFT(filtered_signal);

% End time measurement
elapsed_time = toc;
fprintf('Time taken to execute loop: %.6f seconds\n', elapsed_time);

N=length(Y1)
% Plot the magnitude of the FFT

y_shifted = fftshift(abs(Y1));
k_shifted =(-N/2:N/2-1)*(Fs/N);

stem(k_shifted, y_shifted)
xlabel('Frequency (Hz)')
ylabel('Amplitude')


function X = myFFT(x)
    nextpow = 2^nextpow2(length(x));  % Calculate the next power of 2
    x = [x; zeros(nextpow - length(x), 1)];  % Zero-padding to the next power of 2
    N = length(x);
    if N <= 1
        X = x;
    else
       even = myFFT(x(1:2:end));
       odd = myFFT(x(2:2:end));
       W = exp(-2i*pi/N).^(0:N/2-1);
       X = [even + W .* odd, even - W .* odd];
   end
end
