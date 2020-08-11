clc;
close all;
clear ;

% Preparing the carrier signal
[ymain,Fs_main]=audioread('m.wav');                       %reading the main audio and Fs_main is the number of samples

ymain_f=lowpass(ymain,pi/4) ;                               %using low passfilter to detect the main signal
subplot(2,2,1);
plot(ymain_f);                                             %plot the main signal 
title('main audio.wav after low pass');

% Preparing the hidden signal
[yhidden,Fs_hidden]=audioread('h.wav');                       %reading the hidden_message and Fs_hidden is the number of samples
yhidden_b=lowpass(yhidden,pi/8) ;                              %using low passfilter to detect the hidden signal (hidden_message)
t_hidden = (0:length(yhidden)-1)/Fs_hidden;                         % getting a great number of samples to use it in AM modultaion
t_hidden = t_hidden(:);                                             %here we put it in a vector
sigAM =0.01*cos(2*pi*20000*t_hidden);                   %here we def the cos in a variable to use it as AM modulation with amplitude 0.01
yhidden_ff = yhidden_b .* sigAM;                              %here we multiply the the hidden message signal by cos and choose n=20000
subplot(2,2,2);
plot(yhidden_ff);                                            %here we plot the hidden message signal after we multiply it 
title('hidden message.wav after preparation');    %title on ploting 

% adding both signals together
Lmain = length(ymain_f);                                       %length of the main signal after filteration 
Lhidden_ff = length(yhidden_ff);                                 %length of the hidden signal after filteration 
yhidden_ff = [yhidden_ff;zeros(Lmain-Lhidden_ff,1)];                   %here we adjust the length of the message to make it equal to the main signal so we can sum them togehter
enc = yhidden_ff + ymain_f;                                    %summtion of the two signals 
subplot(2,2,3);
plot(enc);                                                %plot the encoded message
title('sum of both signals');                            %title on ploting
%sound(enc, Fs_c);       %we can listen to the encoded (enc) messeage 


% alogorithm to extract 
t_enc = (0:length(enc)-1)/Fs_hidden;                 %geting the sample of encoded signal 
t_enc = t_enc(:);                                  %puting this samples in vector
sigAM_enc = 100*cos(2*pi*20000*t_enc);      %AM modulation
dec = enc .* sigAM_enc;                         %here we multiply the encoded signal with the cos 
dec_msg=lowpass(dec,pi/8) ;                     %here we pass the dec  to a low pass filter of frequency pi/8 as we know the hidden_message frequency 

subplot(2,2,4);
dec_msg = dec_msg *1.8;                       % amplitude (raise the voice ) to reach exact signal
plot(dec_msg);                                    %ploting the dec_msg 
%%axis([0 6e5 -0.5 0.5]);                      %from 0 to 6e5 is the scale of X-axis and from -0.5 to 0.5 is the scale of Y-axis
title('decoded signal');                           %or extracted 

%sound(dec_msg, Fs_hidden); % to hear the decoded version (extracted/hidden signal) 
%sound(ymain, Fs_main); % to hear the carrier/main
%sound(yhidden, Fs_hidden); % to hear the hidden message
%sound(enc, Fs_main); % to hear the sum of both
%audiowrite('extracted.wav',dec_msg, Fs_hidden); % here we save the extracted message
