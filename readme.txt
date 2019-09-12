The code computes emg features included in the folder 'getFeatures' from data such as the Ninapro data available on the web 
The main code function requires the following input variables: emg, stimulus, repetition, deadzone, winsize, wininc, featFunc, ker. 
The input variable emg is the electromyographic signal. It is expected to be an m x n matrix where each column represents the signal provided by an electrode while each row represents the synchronized time samples of all the electrodes. 
The input variable stimulus represents the movement repeated by the subject. It is expected to be a column vector of integers, each corresponding to a specific movement that can be repeated several times. This value is fundamental to allow the classification of the movements. Using Ninapro, both labeled or relabeled data can be used. 
The input variable repetition represents the repetition of the movement, which can be important in offline studies to select the movements for the training and testing set.  
The input variable deadzone is the positive and negative limit that the signal or the slope must cross to be considered a dead zone in the zero crossing and the slope sign change features. This value is also required for the set of time domain statistics feature. The input variable winsize is the length of the time window to be analyzed. It is expressed in terms of samples, so it is equal to the sampling frequency multiplied by the length of the time window in seconds. 
The input variable wininc is the increment of the sliding window. Also in this case, the value is equal to the sampling frequency multiplied by the increment expressed in seconds. 
The input variable featFunc is the feature to be extracted. Currently, it allows to extract the following signal features: Integrated Absolute Value, IAV (input string: getiavfeat); Mean Absolute Value, MAV (getmavfeat); Slope Sign Change SSC (getsscfeat); Zero Crossing, ZC (getzcfeat); Mean Absolute Value Slope, MAVS (getmavsfeat); Root Mean Square, RMS (getrmsfeat); waveform length, WL (getwlfeat); the set of time domain statistics described in detail in the paper by Hudgins et al. (Hudgins et al., 1993), TD (which include the concatenation of MAV, MAVS,  ZC, SSC and WL,  getTDfeat); the histogram (HIST) signal feature (Zardoshti-Kermani et al., 1995) obtained by dividing a 3σ threshold into 20 bins (getHISTfeat); the marginal Discrete Wavelet Transform (Lucas et al., 2008) created with a db7 wavelet with 3 levels (getmDWTfeat). Finally, the input variable ker corresponds to the number of CPU cores to be used for the computation.
Reference values for deadzone, winsize and wininc are the following ones:
Deadzone:   Otto: 10^-5;    Delsys: 10^-5;  Cometa: 10^3;   Myo: 10.
Winsize:    Otto: 20;       Delsys: 400;    Cometa: 400;    Myo: 40.
Wininc:     Otto: =1;       Delsys: 20;     Cometa: 20;     Myo: 2.
The code outputs the following variables: feat, featStim and featRep. The output variable feat corresponds to the features extracted. It 
has a number of rows equal to the number of extracted time windows and a number of columns which depends on the dimension of each signal feature. The output variable featStim provides the input variable stim that corresponds to each time window. The output variable featRep provides the input variable repetition that corresponds to each time window. Time windows that do not have a unique value for stim or repetition variables are removed from the output variables.



Example:
[feat, featStim, featRep] = FeatureExtractor(emg,stimulus,repetition,10^-5,400,20,'getmavfeat');
Delsys & Cometa suggested deadzone (to check)=10^-5
winsize = window length in samples (Delsys suggested: winsize=400;)
wininc = window increment (Delsys suggested: wininc=20;)
The code include fast signal feature extraction algorithms that can extract widely used features and allow researchers to easily add new ones.

In case you use this code, please cite the following papers:
Atzori Manfredo, Müller Henning, PaWFE: Fast Signal Feature Extraction Using Parallel Time Windows, Frontiers in Neurorobotics, 13, 74, 2019 (DOI=10.3389/fnbot.2019.00074)
Chan, A. D. C., and Green, G. C. (2017). Myoelectric control development toolbox. CMBES. Proc. 30.
http://www.sce.carleton.ca/faculty/chan/matlab/myoelectric%20control%20development%20toolbox.pdf
