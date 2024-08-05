[x, Fs] = audioread("rock/rock.00099.wav")
% Compute the DFT
N = length(x);             
X = ones(1, N);
tic;
for k = 1:N
    X(k) = 0;
    for n = 1:N
        X(k) = X(k) + x(n) * exp(-1i * 2 * pi * (k-1) * (n-1) / N);
    end
end 
elapsed_time = toc;
fprintf('Time taken to execute loop: %.6f seconds\n', elapsed_time);

% Calculate the frequencies corresponding to the DFT bins
frequencies = (0:N-1) * Fs / N;

% Initialize output array for DFT

magnitude = abs(X);
% Plot the magnitude spectrum
subplot(2,1,1);
plot(frequencies, abs(X));
xlabel('Frequency Index');
ylabel('Magnitude');
title('Magnitude Plot of DFT');
subplot(2,1,2);
stem(frequencies, angle(X));
xlabel('Frequency Index');
ylabel('Phase');
title('Phase Plot of DFT');