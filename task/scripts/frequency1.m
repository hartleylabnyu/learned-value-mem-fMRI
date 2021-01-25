%% FREQUENCY TASK %%
% In this task, participants see postcards that vary in the frequency with
% which they are presented. They need to press a button when they see a
% repeated postcard.

%% Define screen info
% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
inc = white - grey;

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Define fixation cross
% Here we set the size of the arms of our fixation cross
fixCrossDimPix = 20;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
fixCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
lineWidthPix = 3;

%% FREQUENCY TASK %%
% In this task, participants see postcards that vary in the frequency with
% which they are presented. They need to press a button when they see a
% repeated postcard.

%% Create data file
freq_filename = ['sub', int2str(subjectNumber), '_', date, '_freqTask1_mri.txt'];
fileID = fopen(freq_filename, 'w');
freqDataArray = {};

% specify file format. 

% Column 1: Subject number %f
% Column 2: CB Version %f
% Column 3: Trial %f
% Column 4: Card %s
% Column 5: Frequency condition %f
% Column 6: ITI Duration %d
% Column 7: response %f
% Column 8: RT %d
% Column 9: Trial start %d
% Column 10: Trial end %d
% Column 11: ITI start %d
% Column 12: ITI end %d
% Column 13: task version
% Column 14: block 

formatSpec = '\n %f\t %f\t %f\t %s\t %f\t %d\t %d\t %d\t %d\t %d\t %d\t %d\t %s\t %f'; 

fileVars = {'sub', 'cbVersion','trial','stim','freqCond','freqITI', 'freqTaskResp', ...
    'freqTaskRT','freqTrialStart','freqTrialEnd','freqTrialITIStart','freqTrialITIEnd', 'taskVersion', 'block'};

for fV = 1:length(fileVars)
    PrintType = '%s';
    PrintfV = cell2mat(fileVars(fV));
    fprintf(fileID, [PrintType '\t'], PrintfV);
end

%% Present instruction screen
freqInstructions = imread('taskInstructionsA/freq1_instructions.jpeg');
freqInstructions = imresize(freqInstructions, [screenYpixels screenXpixels]);
Screen('PutImage', window, freqInstructions); % put image on screen

% Flip to the screen
HideCursor();
Screen('Flip', window);
trigger = 0; %indicate that trigger hasn't sent yet

% Wait for scanner trigger
while trigger == 0
[keyIsDown, secs, keyCode] = KbCheck; %wait for trigger
if keyIsDown == 1 && keyCode(scannerTrigger) == 1
    trigger = 1;
    taskStartTime = GetSecs;
end
end

%% Start ITI
Screen('DrawLines', window, fixCoords,lineWidthPix, white, [xCenter yCenter]);
[~, beginningITIstart] = Screen('Flip', window);
WaitSecs(startITI);
beginningITIend = GetSecs();

%% Define image sizes and locations
%sizes
s1 = 300;
s2 = 300;
s3 = 3;

%% Run trials for each row of the array
% Present paired images for 3 seconds. Within this time, allow keyboard
% input and log responses (button pressed + RT) Add this info to the array.

for i = 1:numFreqTrials

% Load the image
cardImage = freqStimArray{i, 1};
cardImage = imread(cardImage);

%resize images
cardImage = imresize(cardImage, [s1 s2]); 

% Make the image into a texture
cardTexture = Screen('MakeTexture', window, cardImage);
  
% Draw the card on the screen
Screen('DrawTexture', window, cardTexture, [], [], 0);

%print trial number to console
disp(['Trial ' int2str(i) ' out of ' int2str(numFreqTrials)]); 

% Initialize response variables
respToBeMade = true;  
response = []; %initialize response 
rt = []; %initialize rt

%flip to the screen
[~, tStart] = Screen('Flip', window);
HideCursor();

%Get response information
    while ((GetSecs - tStart)) < freqTrialDuration && (respToBeMade == true) %if it has been fewer than 2 seconds and a response has not been made
    [keyIsDown,secs, keyCode] = KbCheck; %log response info
        if keyCode(escapeKey)
            ShowCursor;
            sca;
            return
        elseif keyCode(button1)
            response = 1;
            disp('New response made.');
            rt = GetSecs - tStart;
            WaitSecs(freqTrialDuration - (GetSecs-tStart));
        elseif keyCode(button2)
            response = 2;
            disp('Old response made.');
            rt = GetSecs - tStart;
            WaitSecs(freqTrialDuration - (GetSecs-tStart));
        end
    end
    
tEnd = GetSecs;
  
%% Close texture
Screen('Close', cardTexture);

%% ITI with fixation cross
itiInterval = freqStimArray{i,3};
Screen('DrawLines', window, fixCoords,lineWidthPix, white, [xCenter yCenter]);
[~, ITIStart] = Screen('Flip', window);
WaitSecs(itiInterval);
ITIEnd = GetSecs();

%% Add trial data to stimArray
freqDataArray{i, 1} = subjectNumber;
freqDataArray{i, 2} = cbNumber;
freqDataArray{i, 3} = i;
freqDataArray{i, 4} = freqStimArray{i, 1}; %card
freqDataArray{i, 5} = freqStimArray{i, 2}; %frequency condition
freqDataArray{i, 6} = freqStimArray{i, 3}; %ITI duration
freqDataArray{i, 7} = response;
freqDataArray{i, 8} = rt;
freqDataArray{i, 9} = tStart;
freqDataArray{i, 10} = tEnd;
freqDataArray{i, 11} = ITIStart;
freqDataArray{i, 12} = ITIEnd;
freqDataArray{i, 13} = taskVersion;
freqDataArray{i, 14} = block;

%% Save data
fileID = fopen(freq_filename, 'a');
fprintf(fileID,formatSpec,freqDataArray{i, :});

%Close the file.
fclose(fileID);

end

%% END ITI
Screen('DrawLines', window, fixCoords,lineWidthPix, white, [xCenter yCenter]);
[~, endITIstart] = Screen('Flip', window);
WaitSecs(endITI);
endITIend = GetSecs();


%% Add beginning ITI to file
freqDataArray{numFreqTrials+1, 1} = subjectNumber;
freqDataArray{numFreqTrials+1, 2} = cbNumber;
freqDataArray{numFreqTrials+1, 3} = 0;
freqDataArray{numFreqTrials+1, 4} = 'beginningITI'; %card
freqDataArray{numFreqTrials+1, 5} = []; %frequency condition
freqDataArray{numFreqTrials+1, 6} = startITI; %ITI duration
freqDataArray{numFreqTrials+1, 7} = [];
freqDataArray{numFreqTrials+1, 8} = [];
freqDataArray{numFreqTrials+1, 9} = [];
freqDataArray{numFreqTrials+1, 10} = [];
freqDataArray{numFreqTrials+1, 11} = beginningITIstart;
freqDataArray{numFreqTrials+1, 12} = beginningITIend;
freqDataArray{numFreqTrials+1, 13} = taskVersion;
freqDataArray{numFreqTrials+1, 14} = block;

%% Add ending ITI to file
freqDataArray{numFreqTrials+2, 1} = subjectNumber;
freqDataArray{numFreqTrials+2, 2} = cbNumber;
freqDataArray{numFreqTrials+2, 3} = numFreqTrials+1;
freqDataArray{numFreqTrials+2, 4} = 'endingITI'; %card
freqDataArray{numFreqTrials+2, 5} = []; %frequency condition
freqDataArray{numFreqTrials+2, 6} = endITI; %ITI duration
freqDataArray{numFreqTrials+2, 7} = [];
freqDataArray{numFreqTrials+2, 8} = [];
freqDataArray{numFreqTrials+2, 9} = [];
freqDataArray{numFreqTrials+2, 10} = [];
freqDataArray{numFreqTrials+2, 11} = endITIstart;
freqDataArray{numFreqTrials+2, 12} = endITIend;
freqDataArray{numFreqTrials+2, 13} = taskVersion;
freqDataArray{numFreqTrials+2, 14} = block;

%% Present End screen
line1 = 'Great job!';
 
% Draw all the text in one go
Screen('TextSize', window, 30);
DrawFormattedText(window, [line1],'center', screenYpixels * 0.33, white);

% Flip to the screen
HideCursor();
[~, endScreenStart] = Screen('Flip', window);

%wait for end of run
timeElapsed = GetSecs - taskStartTime;
disp(['The frequency task took ' int2str(timeElapsed) ' seconds.']);
WaitSecs(endTimeBuffer);
endScreenEnd = GetSecs;

%% Add end screen timing to data
freqDataArray{numFreqTrials+3, 1} = subjectNumber;
freqDataArray{numFreqTrials+3, 2} = cbNumber;
freqDataArray{numFreqTrials+3, 3} = numFreqTrials+2;
freqDataArray{numFreqTrials+3, 4} = 'endScreen'; %card
freqDataArray{numFreqTrials+3, 5} = []; %frequency condition
freqDataArray{numFreqTrials+3, 6} = endTimeBuffer; %ITI duration
freqDataArray{numFreqTrials+3, 7} = [];
freqDataArray{numFreqTrials+3, 8} = [];
freqDataArray{numFreqTrials+3, 9} = [];
freqDataArray{numFreqTrials+3, 10} = [];
freqDataArray{numFreqTrials+3, 11} = endScreenStart;
freqDataArray{numFreqTrials+3, 12} = endScreenEnd;
freqDataArray{numFreqTrials+3, 13} = taskVersion;
freqDataArray{numFreqTrials+3, 14} = block;

%% Save data
fileID = fopen(freq_filename, 'a');
fprintf(fileID,formatSpec,freqDataArray{numFreqTrials+1, :});
fprintf(fileID,formatSpec,freqDataArray{numFreqTrials+2, :});
fprintf(fileID,formatSpec,freqDataArray{numFreqTrials+3, :});

%Close the file.
fclose(fileID);

%save task variables
save('taskVars.mat'); 

%Clear the screen
sca;
 






