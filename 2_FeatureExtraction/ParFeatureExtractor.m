function [feat, featStim, featRep] = ParFeatureExtractor(emg,stimulus,repetition,deadzone,winsize,wininc,featFunc,ker)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Variables to make it work as a script
% clear all; close all; clc
% addpath(genpath('2_FeatureExtraction'));
% addpath(genpath('getFeatures'));
% % load('S1Otto_Test.mat'); %Mc
% load('S1DelsysTest.mat'); %Mc
% % Deadzone:   Otto: 10^-5;    Delsys: 10^-5;  Cometa: 10^3;   Myo: 10.
% % Winsize:    Otto: 20;       Delsys: 400;    Cometa: 400;    Myo: 40.
% % Wininc:     Otto: =1;       Delsys: 20;     Cometa: 20;     Myo: 2.
% featFunc='getrmsfeat';
% stimulus=restimulus;
% repetition=rerepetition;
% % [feat, featStim, featRep] = ParFeatureExtractor(emg,restimulus,rerepetition,deadzone,winsize,wininc,);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Computes emg features included in the folder 'getFeatures' from data as
%the Ninapro data available on the web 
%FeatFunc can be:
%'getTDfeat' or 'getiavfeat.m' or 'getmavsfeat.m' or 'getsscfeat.m' or 'getzcfeat.m' or 'getTDfeat.m' or 'getarfeat.m' or 'getmavfeat.m' or 'getrmsfeat.m' or 'getwlfeat.m' or 'getmDWTfeat'

%Example:
%[feat, featStim, featRep] = FeatureExtractor(emg,stimulus,repetition,10^-5,400,20,'getmavfeat');
% Delsys & Cometa suggested deadzone (to check)=10^-5
% winsize = window length in samples (Delsys suggested: winsize=400;)
% wininc = window increment (Delsys suggested: wininc=20;)
%Cite:
% Atzori et al., XXX
% Chan ADC, Green GC, "Myoelectric control development toolbox", 30th Conference of the Canadian Medical & Biological Engineering Society, Toronto, Canada, M0100, 2007.
% http://www.sce.carleton.ca/faculty/chan/matlab/myoelectric%20control%20development%20toolbox.pdf

addpath('./getFeatures');

if exist('ker'),
    parpool(ker,'IdleTimeout', 30);
end

datawin = ones(winsize,1);
numwin = size(emg,1);
nSignals = size(emg,2);

edges=[-3:0.3:3];

%-------------------------------------------------------------
% allocate memory
switch featFunc
    case 'getHISTfeat'
        emg=(emg-repmat(mean(emg),[size(emg,1),1]))./repmat(std(emg),[size(emg,1),1]);
        feat = zeros(numwin,nSignals*size(edges,2),'single');
    case 'getTDfeat'
        feat = zeros(numwin,nSignals*5,'single');
    case 'getmDWTfeat'
        feat = zeros(numwin,nSignals*4,'single'); %4=(Level DWT+1)
    otherwise
        feat = zeros(numwin,nSignals,'single');
end
featStim=zeros(numwin,1);
featRep=zeros(numwin,1);
checkStimRep=zeros(numwin,1);

%-------------------------------------------------------------


% compute feat, featStim & featRep
parfor winInd = 1:numwin-winsize,
    
    if mod(winInd-1,wininc)==0,
        %h=waitbar(winInd/numwin);
        disp(['Feature Extraction Progress: ' num2str(round(winInd*10000/numwin)/100) '%'])
        
        curStimWin=stimulus(winInd:winInd+winsize,:);
        curRepWin=repetition(winInd:winInd+winsize,:);
                
        if size(unique(curStimWin))==1 & size(unique(curRepWin))==1,
        
            checkStimRep(winInd,1)=1;
            featStim(winInd,1)=curStimWin(1);
            featRep(winInd,1)=curRepWin(1);
            
            curwin = emg(winInd:winInd+winsize-1,:); %.*repmat(datawin,1,nSignals);
            
            %%%
            switch featFunc
                case 'getrmsfeat'
                    % GETRMSFEAT Gets the RMS feature (Root Mean Square).
                    feat(winInd,:) = getrmsfeat(curwin,winsize,wininc);
                case 'getTDfeat'
                    %Compute Time Domain features according to HUDGINS, A New Strategy for Multifunction Myoelectric Control
                    feat(winInd,:) = getTDfeat(curwin,deadzone,winsize,wininc);
                case 'getmavfeat'
                    % GETMAVFEAT Gets the MAV feature (Mean Absolute Value).
                    feat(winInd,:) = getmavfeat(curwin,winsize,wininc,datawin);
                case 'getzcfeat'
                    % GETZCFEAT Gets the ZC feature (zero crossing).
                    feat(winInd,:) = getzcfeat(curwin,deadzone,winsize,wininc,datawin);
                case 'getsscfeat'
                    % GETSSCFEAT Gets the slope sign change feature.
                    feat(winInd,:) = getsscfeat(curwin,deadzone,winsize,wininc,datawin);
                case 'getwlfeat'
                    % GETWLFEAT Gets the waveform length feature.
                    feat(winInd,:) = getwlfeat(curwin,winsize,wininc,datawin);
                case 'getarfeat'
                    % GETARFEAT Gets the AR feature (autoregressive).
                    order=1;
                    feat(winInd,:) = getarfeat(double(curwin),order,winsize,wininc,datawin);
                case 'getiavfeat'
                    % GETIAVFEAT Gets the IAV feature (Integrated Absolute Value).
                    feat(winInd,:) = getiavfeat(curwin,winsize,wininc,datawin);
                case 'getHISTfeat'
                    % getHISTfeat Gets the histogram feature as described in Ninapro papers
                    feat(winInd,:) = getHISTfeat(curwin,winsize,wininc,edges);
                case 'getmDWTfeat'
                    feat(winInd,:) = getmDWTfeat(curwin,winsize,wininc);
                otherwise
                    warning('feature not yet implemented in FeatureExtractor')
                    %                 break
            end
            
        end
        %-------------------------------------------------------------
    end
end

%-------------------------------------------------------------
%Remove features that correspond to windows without unique stimulus and repetition
z=find(checkStimRep==0);
feat(z,:)=[];
featStim(z,:)=[];
featRep(z,:)=[];
%-------------------------------------------------------------



