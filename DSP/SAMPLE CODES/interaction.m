% Open a dialog box for the user to select a file interactively
[filename, filepath] = uigetfile({'*.wav', 'Waveform Audio File (*.wav)'; '*.mp3', 'MPEG Audio Layer III File (*.mp3)'}, 'Select Audio File');

% Check if the user selected a file
if isequal(filename, 0)
    disp('No file selected.'); % User canceled the operation
else
    % Load the selected file
    fullFilePath = fullfile(filepath, filename);
    %[y, fs] = audioread(fullFilePath);
    
    % Now 'y' contains the audio signal, and 'fs' contains the sampling rate
    disp(['Selected file: ', fullFilePath]);
    
    % Your further processing code here...
   [y, Fs] = audioread(fullFilePath);
   %sound(y,Fs)
   % 'y' contains the audio data and 'Fs' is the sampling frequency
   
   % Plot the waveform
   magnitude = abs(y);
   t = (0:length(y)-1) / Fs;
   
   % Play the audio
   %sound(x, Fs);
   N = length(y);
   disp(N)
   X = ones(1, N);
   X=fft(y);
   A=abs(X);
   frequencies = (-N/2:(N/2)-1) * Fs / (N);
   %B=sum(A)/(2*N);
   %disp("THE MARGIN IS :");
   %disp(B);
   %B=0;
   %subplot(2,1,1)
   plot(frequencies, 20*log(abs(X)));
   %plot(abs(X));
   xlabel('Frequencies');
   ylabel('Amplitude');
   title('Audio Waveform of ROCK');
   frequencies_1 = (0:N-1) * Fs / (N);
   %subplot(2,1,2)
   %stem(frequencies_1, angle(X));
   %xlabel('Frequencies');
   %ylabel('Phase');
   %title('Audio Waveform of ROCK');
 end
   