%
% GETIAVFEAT Gets the  
%
% feat = getiavfeat(x,winsize,wininc,datawin,dispstatus)
%
% Author Adrian Chan
%
% This function computes the IAV feature of the signals in x,
% which are stored in columns.
%
% The signals in x are divided into multiple windows of size
% winsize and the windows are space wininc apart.
%
% Inputs
%    x: 		columns of signals
%    winsize:	window size (length of x)
%    wininc:	spacing of the windows (winsize)
%    datawin:   window for data (e.g. Hamming, default rectangular)
%               must have dimensions of (winsize,1)
%    dispstatus:zero for no waitbar (default)
%
% Outputs
%    feat:     IAV value in a 2 dimensional matrix
%              dim1 window
%              dim2 feature (col i is the features for the signal in column i of x)
%
% Modifications
% 05/01/14 AC Change feat output so that dim1 is window and dim2 is feature
% 04/08/04 AC First created.

function feat = getiavfeat(x,winsize,wininc,datawin,dispstatus)

if nargin < 5
    if nargin < 4
        if nargin < 3
            if nargin < 2
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
    h = waitbar(0,'Computing IAV features...');
end

st = 1;
en = winsize;

for i = 1:numwin
    if dispstatus
        waitbar(i/numwin);
    end
    curwin = x(st:en,:).*repmat(datawin,1,Nsignals);
    feat(i,:) = sum(abs(curwin));
   
    st = st + wininc;
    en = en + wininc;
end

if dispstatus
    close(h)
end
