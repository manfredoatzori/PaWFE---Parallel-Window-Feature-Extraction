% getmDWTfeat Gets the marginal Discrete Wavelet Transform feature as described in Ninapro papers
% Ref: ICRA2013, EMBC2012, Lucas 2008, Scientific Data 2014
%
%
% This function computes the mDWT feature of the signals in x,
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
%    feat:     mDWT value in a 2 dimensional matrix
%              dim1 window
%              dim2 feature (col i is the features for the signal in column i of x)
%


function feat = getmDWTfeat(x,winsize,wininc)

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
% feat = zeros(numwin,Nsignals*size(edges,2));

st = 1;
en = winsize;


for i = 1:numwin
    
    curwin = x(st:en,:);
    
    %-----------------
    %mDWT NEW NEW
    for colInd=1:size(curwin,2),
        
        [C,L] = wavedec(curwin(:,colInd),3,'db7'); 
        
        L=cumsum(L); %<<<To optimize: is the same in different time windows???
        L=[0;L]; %<<<
        
        
        sReal=[0, 3, 2, 1];
        
        for s=1:4, 
            
            d_xk=C(L(s)+1:L(s+1));
            
            MaxSum=min(ceil(size(x,1)/(2^sReal(s)-1)),size(d_xk,1));
            
            m_xk(s,colInd)=sum(abs(d_xk(1:MaxSum)));
                
        end
        
    end
    
    feat=m_xk(:)';

    
    
% % %     %-----------------
% % %     %Wrong
% % %
% % %     for j=1:size(curwin,2),
% % %
% % %         [C,L] = wavedec(curwin(:,j),3,'db7');
% % %
% % %         SMax=log2(size(C,1));
% % %         N=size(C,1);
% % %
% % %         for jj=1:SMax,
% % %             %                     CMax=round(N/(2^(jj-1)));
% % %             CMax=round(N/2^jj-1);
% % %             FV(jj,j)=sum(abs(C(1:CMax)));
% % %         end
% % %
% % %     end
% % %
% % %     feat(i,:) = FV(:)';
% % %     %----------------
    
    
    
    st = st + wininc;
    en = en + wininc;
end
