
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
freq_filename = ['sub', int2str(subjectNumber), '_', date, '_freqTask_tutorial.txt'];
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

formatSpec = '\n %f\t %f\t %f\t %s\t %f\t %d\t %d\t %d\t %d\t %d\t %d\t %d'; 

fileVars = {'sub', 'cbVersion','trial','stim','freqCond','freqITI', 'freqTaskResp', ...
    'freqTaskRT','freqTrialStart','freqTrialEnd','freqTrialITIStart','freqTrialITIEnd'};

for fV = 1:length(fileVars)
    PrintType = '%s';
    PrintfV = cell2mat(fileVars(fV));
    fprintf(fileID, [PrintType '\t'], PrintfV);
end


%% Present instruction screens 
for i = 1:13
instructionPicName = ['tutInstructionsB/Slide', int2str(i), '.jpeg'];
I1 = imread(instructionPicName);
Screen('PutImage', window, I1); % put image on screen

% Flip to the screen
HideCursor();
Screen('Flip', window);
KbStrokeWait;
end
taskStartTime = GetSecs;


%% Define image sizes and locations
%sizes
s1 = 300;
s2 = 400;
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

%% Save data
fileID = fopen(freq_filename, 'a');
fprintf(fileID,formatSpec,freqDataArray{i, :});

%Close the file.
fclose(fileID);

end

%% Present End screen
% END SCREEN
line1 = 'Great job!';
 
% Draw all the text in one go
Screen('TextSize', window, 30);
DrawFormattedText(window, [line1],'center', screenYpixels * 0.33, white);

% Flip to the screen
HideCursor();
Screen('Flip', window);

%wait for end of run
timeElapsed = GetSecs - taskStartTime;
disp(['The frequency task took ' int2str(timeElapsed) ' seconds.']);
WaitSecs(endTimeBuffer);
sca;

