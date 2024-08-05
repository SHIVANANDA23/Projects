%Wp = [60 2000]/(22050/2); Ws = [50 250]/(22050/2);   % Normalizing frequency
Fs=22050;
Wp = [150 2000]/(Fs/2); Ws = [50 2150]/(Fs/2);
    Rp = 10; Rs = 50;
    [n,Wn] = buttord(Wp,Ws,Rp,Rs);  % Gives minimum order of filter
    [z,p,k] = butter(n,Wn);         % Butterworth filter design
    SOS = zp2sos(z,p,k);            % Converts to second order sections
    freqz(SOS,1024,22050)            % Plots the frequency response
