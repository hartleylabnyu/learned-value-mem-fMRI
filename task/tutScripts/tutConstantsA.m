%% Tutorial Constants %%

%% Keys
% Define the keyboard keys that are listened for. 
escapeKey = KbName('ESCAPE');
button1 = KbName('g'); %right hand index finger
button2 = KbName('h'); %right hand middle
button3 = KbName('j'); %right hand ring
button4 = KbName('k'); %right hand pinky
button5 = KbName('s'); %left hand ring
button6 = KbName('d'); %left hand middle
button7 = KbName('f'); %left hand index
scannerTrigger = KbName('5%'); %scanner trigger

%% Trial numbers and frequency conditions %%
numCards = 4; %number of different cards
freq1 = 1; %low frequency repetitions
freq2 = 5; %high frequency repetitions
numMemTrials = (numCards/2).*(freq1 + freq2);

%% Experiment Timing 
freqTrialDuration = 2; % should be set at 2
encodingTime = 5; %seconds that the paired associates stim are on the screen
memTestMaxResponse = 6; %memory test RT limit for first 24 trials and frequency response
memTestMaxResponsePart2 = 4; %memory test RT limit for second part with repeated images
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

jitterVec = linspace(itiMin, itiMax, 2); %create vector of evenly spaced ITIs


%% Paths to stimuli %% 
addpath 'stim/practiceCards';
addpath 'stim/practiceStamps';




