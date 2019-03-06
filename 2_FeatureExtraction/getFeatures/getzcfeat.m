%
% GETZCFEAT Gets the ZC feature (zero crossing).
%
% feat = getsscfeat(x,deadzone,winsize,wininc,datawin,dispstatus)
%
% Author Adrian Chan
%
% This function computes the ZC feature of the signals in x,
% which are stored in columns.
%
% The signals in x are divided into multiple windows of size
% winsize and the windows are space wininc apart.
%
% Inputs
%    x: 		columns of signals
%    deadzone:  +/- zone signal must cross to be considered a deadzone
%    winsize:	window size (length of x)
%    wininc:	spacing of the windows (winsize)
%    datawin:   window for data (e.g. Hamming, default rectangular)
%               must have dimensions of (winsize,1)
%    dispstatus:zero for no waitbar (default)
%
% Outputs
%    feat:     RMS value in a 2 dimensional matrix
%              dim1 window
%              dim2 feature (col i is the features for the signal in column i of x)
%
% Modifications
% 05/01/14 AC Change feat output so that dim1 is window and dim2 is feature
% 06/06/25 AC First created.

function feat = getzcfeat(x,deadzone,winsize,wininc,datawin,dispstatus)

if nargin < 6
    if nargin < 5
        if nargin < 4
            if nargin < 3
                winsize = size(x,1);
            end
            wininc = winsize;
        end
        datawin = ones(winsize,1);
    end
    dispstatus = 0;
end

datasize = size(x,1);
Nsignals = size(x,2);
numwin = floor((datasize - winsize)/wininc)+1;

% allocate memory
feat = zeros(numwin,Nsignals);

if dispstatus
    h = waitbar(0,'Computing ZC features...');
end

st = 1;
en = winsize;

for i = 1:numwin
   if dispstatus
       waitbar(i/numwin);
   end
   y = x(st:en,:).*repmat(datawin,1,Nsignals);
   
   y = (y > deadzone) - (y < -deadzone);

   % forces the zeros towards either the positive or negative
   % the filter is chosen so that the most recent +1 or -1 has
   % the most influence on the state of the zero.
   a=1;
   b=exp(-(1:winsize/2))';
   z = filter(b,a,y);
   
   
   z = (z > 0) - (z < -0);
   dz = diff(z);
   
   feat(i,:) = (sum(abs(dz)==2));
   
   st = st + wininc;
   en = en + wininc;
end

if dispstatus
    close(h)
end
