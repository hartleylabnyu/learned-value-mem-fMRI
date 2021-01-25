%% Experiment Constants %%

%% Keys
% Define the keyboard keys that are listened for. 
escapeKey = KbName('ESCAPE');
button1 = KbName('1!'); %right hand index finger
button2 = KbName('2@'); %right hand middle
button3 = KbName('3#'); %right hand ring
button4 = KbName('4$'); %right hand pinky
button5 = KbName('8*'); %left hand ring
button6 = KbName('7&'); %left hand middle
button7 = KbName('6^'); %left hand index
scannerTrigger = KbName('5%'); %scanner trigger

%% Trial numbers and frequency conditions %%
numCards = 24; %number of different cards
freq1 = 1; %low frequency repetitions
freq2 = 5; %high frequency repetitions
numMemTrials = (numCards/2).*(freq1 + freq2);

%% Experiment Timing 
freqTrialDuration = 2; % should be set at 2
encodingTime = 5; %seconds that the paired associates stim are on the screen
memTestMaxResponse = 6; %memory test RT limit for first 24 trials and frequency response
memTestMaxResponsePart2 = 4; %memory test RT limit for second part with repeated images
startITI = 3; %ITI at very beginning of task
endITI = 3; %additional ITI at end of task 
endTimeBuffer = 6; %seconds to add at end of task

% ITIs
itiMin = 2; %minimum ITI 
itiMax = 6; %maximum ITI

% if debugMode is on, make the trials in the frequency task and PA task
% very short
if debugMode == 1
    freqTrialDuration = .1;
    itiMin = .1;
    itiMax = .1;
    encodingTime = .1;
    memTestMaxResponse = .1;
    memTestMaxResponsePart2 = .1;
end

jitterVec = linspace(itiMin, itiMax, 12); %create vector of evenly spaced ITIs

%% Paths to stimuli %% 
addpath 'stim/allCards';
addpath 'stim/stamps';
addpath 'stim/allPics';
addpath 'stim/frames';




