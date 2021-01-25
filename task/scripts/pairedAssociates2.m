%% PAIRED ASSOCIATES TASK %%
% In this task, participants see a card and a stamp presented on the
% screen simultaneously. Participants see instructions that tell them that
% they should try to remember which card goes with which stamp.

%Participants must press one button if the stamp is
% on the right side of the card and a different button if the stamp is on
% the left side of the card.


%% Create data file 
PA_filename = ['sub', int2str(subjectNumber), '_', date, '_PA2_mri.txt'];
PA_fileID = fopen(PA_filename, 'w');
PAdataArray = {};

%specify file format. 
% Column 1: subject number - f
% Column 2: trial number - f
% Column 3: condition (1 = low frequency, 2 = high frequency) - f
% Column 4: card stimulus - s
% Column 5: stamp stimulus - s
% Column 6: side of screen that card was on (1 for left, 2 for right) - f
% Column 7: ITI interval - d
% Column 8: trial start - d
% Column 9: trial end - d
% Column 10: ITI start - d
% Column 11: ITI end - d

PA_fileFormat = '\n %f\t %f\t %f\t %s\t %s\t %f\t %d\t %d\t %d\t %d\t %d'; 

fileVars = {'sub','trial','freqCond','stim','truePair', 'stimSide', ...
    'paITI','paTrialStart','paTrialEnd','paITIStart','paITIEnd'};

for fV = 1:length(fileVars)
    PrintType = '%s';
    PrintfV = cell2mat(fileVars(fV));
    fprintf(PA_fileID, [PrintType '\t'], PrintfV);
end

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

%% Present instruction screen
paInstructions = imread('taskInstructionsA/pa2_instructions.jpeg');
paInstructions = imresize(paInstructions, [screenYpixels screenXpixels]);
Screen('PutImage', window, paInstructions); % put image on screen

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
s2 = 400;
s3 = 3;

%space between pics
pixelsBetweenPics = 100;

% locations
loc1 = [(screenXpixels/2 - 50 - s2) (screenYpixels/2 - (s2)/2) (screenXpixels/2 - 50) ((screenYpixels/2 - (s2)/2)+300)];
loc2 = [(screenXpixels/2 + 50) (screenYpixels/2 - (s2)/2) (screenXpixels/2 + 50 + s2) ((screenYpixels/2 - (s2)/2)+300)];

%% Run trial for each row of the array
for i = 1:numCards

% Determine what images to present
stampImage = PA_stimArray{i, 1};
cardImage = PA_stimArray{i, 2};

% Load the two images
stampImage = imread(stampImage);
cardImage = imread(cardImage);

%resize images
stampImage = imresize(stampImage, [s1 s2]); 
cardImage = imresize(cardImage, [s1 s2]); 

% Make the image into a texture
stampTexture = Screen('MakeTexture', window, stampImage);
cardTexture = Screen('MakeTexture', window, cardImage);

%assign image locations
stampLoc = loc1;
cardLoc = loc2;

if PA_stimArray{i,3} == 2 
    stampLoc = loc2;
    cardLoc = loc1;
end

% Draw the images on the screen, side by side
Screen('DrawTexture', window, stampTexture,[],stampLoc, 0);
Screen('DrawTexture', window, cardTexture, [], cardLoc, 0);

% Flip to the screen and start timer
[~, tStart] = Screen('Flip', window);
HideCursor();
disp(['Trial ' int2str(i) ' of 24']);

%Wait for trial duraiton
%WaitSecs(encodingTime);

    while ((GetSecs - tStart)) < encodingTime 
    [keyIsDown,secs, keyCode] = KbCheck; %log response info
        if keyCode(escapeKey)
            ShowCursor;
            sca;
            return
        end
    end

% Close textures
Screen('Close',stampTexture);
Screen('Close', cardTexture);
  
%End trial timer
tEnd = GetSecs;

%% ITI with jitter
%Get ITI duration from trial array
itiInterval = PA_stimArray{i, 5}; 

%draw fixation cross
Screen('DrawLines', window, fixCoords, lineWidthPix, white, [xCenter yCenter]); 
[~, ITIstart] = Screen('Flip', window);

%Wait for ITI
WaitSecs(itiInterval);
ITIend = GetSecs();

%% Add trial data to dataArray
PAdataArray{i, 1} = subjectNumber;
PAdataArray{i, 2} = i; %trial
PAdataArray{i, 3} = PA_stimArray{i, 4}; %condition
PAdataArray{i, 4} = PA_stimArray{i, 2}; %card stim
PAdataArray{i, 5} = PA_stimArray{i, 1}; %stamp stim
PAdataArray{i, 6} = PA_stimArray{i, 3}; %card on left or right (1 for left, 2 for right)
PAdataArray{i, 7} = PA_stimArray{i, 5}; % ITI duration
PAdataArray{i, 8} = tStart;
PAdataArray{i, 9} = tEnd;
PAdataArray{i, 10} = ITIstart;
PAdataArray{i, 11} = ITIend;

%% Save data
PA_fileID = fopen(PA_filename, 'a');
fprintf(PA_fileID,PA_fileFormat,PAdataArray{i, :});
fclose(PA_fileID);

end

%% END ITI
Screen('DrawLines', window, fixCoords,lineWidthPix, white, [xCenter yCenter]);
[~, endITIstart] = Screen('Flip', window);
WaitSecs(endITI);
endITIend = GetSecs();

%% Add beginning ITI to file
PAdataArray{numCards + 1, 1} = subjectNumber;
PAdataArray{numCards + 1, 2} = 0; %trial
PAdataArray{numCards + 1, 3} = []; %condition
PAdataArray{numCards + 1, 4} = 'beginningITI'; %card stim
PAdataArray{numCards + 1, 5} = []; %stamp stim
PAdataArray{numCards + 1, 6} = []; %card on left or right (1 for left, 2 for right)
PAdataArray{numCards + 1, 7} = startITI; % ITI duration
PAdataArray{numCards + 1, 8} = [];
PAdataArray{numCards + 1, 9} = [];
PAdataArray{numCards + 1, 10} = beginningITIstart;
PAdataArray{numCards + 1, 11} = beginningITIend;


%% Add ending ITI to file
PAdataArray{numCards + 2, 1} = subjectNumber;
PAdataArray{numCards + 2, 2} = numCards + 1; %trial
PAdataArray{numCards + 2, 3} = []; %condition
PAdataArray{numCards + 2, 4} = 'endingITI'; %card stim
PAdataArray{numCards + 2, 5} = []; %stamp stim
PAdataArray{numCards + 2, 6} = []; %card on left or right (1 for left, 2 for right)
PAdataArray{numCards + 2, 7} = endITI; % ITI duration
PAdataArray{numCards + 2, 8} = [];
PAdataArray{numCards + 2, 9} = [];
PAdataArray{numCards + 2, 10} = endITIstart;
PAdataArray{numCards + 2, 11} = endITIend;


%% Present End screen
% END SCREEN
line1 = 'Great job!';
 
% Draw all the text in one go
Screen('TextSize', window, 30);
DrawFormattedText(window, [line1],'center', screenYpixels * 0.33, white);

% Flip to the screen
HideCursor();
[~, endScreenStart] = Screen('Flip', window);

%wait for end of run
timeElapsed = GetSecs - taskStartTime;
disp(['The paired associates task took ' int2str(timeElapsed) ' seconds.']);
WaitSecs(endTimeBuffer);
endScreenEnd = GetSecs;

%% Add end screen timing to data
PAdataArray{numCards + 3, 1} = subjectNumber;
PAdataArray{numCards + 3, 2} = numCards + 2; %trial
PAdataArray{numCards + 3, 3} = []; %condition
PAdataArray{numCards + 3, 4} = 'endScreen'; %card stim
PAdataArray{numCards + 3, 5} = []; %stamp stim
PAdataArray{numCards + 3, 6} = []; %card on left or right (1 for left, 2 for right)
PAdataArray{numCards + 3, 7} = endTimeBuffer; % ITI duration
PAdataArray{numCards + 3, 8} = [];
PAdataArray{numCards + 3, 9} = [];
PAdataArray{numCards + 3, 10} = endScreenStart;
PAdataArray{numCards + 3, 11} = endScreenEnd;

%% Save data
PA_fileID = fopen(PA_filename, 'a');
fprintf(PA_fileID,PA_fileFormat,PAdataArray{numCards+ 1, :});
fprintf(PA_fileID,PA_fileFormat,PAdataArray{numCards+ 2, :});
fprintf(PA_fileID,PA_fileFormat,PAdataArray{numCards+ 3, :});
fclose(PA_fileID);

%save task variables
save('taskVarsBlock2.mat'); 

%Close screen
sca;
 











