function feat = getTDfeat(x,deadzone,winsize,wininc)

%Compute Time Domain features according to HUDGINS, A New Strategy for Multifunction Myoelectric Control

%Author: Manfredo Atzori

% Delsys suggested deadzone (to check)=10^-5
% winsize = window length in samples (Delsys suggested: winsize=400;)
% wininc = window increment (Delsys suggested: wininc=20;)

if nargin < 6
    if nargin < 5
        if nargin < 4
            if nargin < 3
                if nargin < 2
                    deadzone=0; %10^-5 Delsys, Cometa
                end
                winsize = size(x,1);
            end
            wininc = winsize;
        end
        datawin = ones(winsize,1);
    end
    dispstatus = 0;
end


%----------------
%1.Mean Absolute Value
feat1 = getmavfeat(x,winsize,wininc);

%----------------
%2.Mean Absolute Value Slopej
feat2 = getmavsfeat(x,winsize,wininc,datawin,dispstatus);

%----------------
%3.Zero Crossing
feat3 = getzcfeat(x,deadzone,winsize,wininc); 

%----------------
%4.Slope Sign Change
feat4 = getsscfeat(x,deadzone,winsize,wininc);

%----------------
%5.Waveform Length (WL) (I,A)
feat5 = getwlfeat(x,winsize,wininc);

feat=[feat1, feat2, feat3, feat4, feat5];
%
