%
% getHISTfeat Gets the histogram feature as described in Ninapro papers
% (e.g. Scientific Data)
%
%IMPORTANT: data standardization may be important to get proper results from HIST feature. This phase is included in FeatureExtractor:
%         edges=[-3:0.3:3];
%         emg=(emg-repmat(mean(emg),[size(emg,1),1]))./repmat(std(emg),[size(emg,1),1]);

%
% This function computes the HIST feature of the signals in x,
% which are stored in columns.
%
% The signals in x are divided into multiple windows of size
% winsize and the windows are space wininc apart.
%
% Inputs
%    x: 		columns of signals
%    winsize:	window size (length of x)
%    wininc:	spacing of the windows (winsize)
%
% Outputs
%    feat:     HIST value in a 2 dimensional matrix
%              dim1 window
%              dim2 feature (col i is the features for the signal in column i of x)
%
% Modifications
% 05/01/14 AC Change feat output so that dim1 is window and dim2 is feature
% 04/06/23 AC First created.


function feat = getHISTfeat(x,winsize,wininc,edges)

if nargin < 3
    if nargin < 2
        winsize = size(x,1);
    end
    wininc = winsize;
end

datasize = size(x,1);
Nsignals = size(x,2);
numwin = floor((datasize - winsize)/wininc)+1;

% allocate memory
feat = zeros(numwin,Nsignals*size(edges,2));

st = 1;
en = winsize;


for i = 1:numwin


   curwin = x(st:en,:).*repmat(ones(winsize,1),1,Nsignals);
   
   F0=histc(curwin,edges);
   feat(i,:) = F0(:)';  
   
   
   st = st + wininc;
   en = en + wininc;
end

