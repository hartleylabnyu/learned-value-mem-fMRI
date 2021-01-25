%% MEMORY TEST 2 - PART B %%
% In this task, participants now need to put stamps on the cards that they saw in
% the previous two tasks. Each card will be presented the same number of
% times as in the frequency task.

%% Create data file for the main memory data
mem_filename = ['sub', int2str(subjectNumber), '_', date, '_mem2b_mri.txt'];
fileID = fopen(mem_filename, 'w');

%specify file format.
% Column 1: Subject number - f
% Column 2: Trial Number - f
% Column 3: Card stimulus - s
% Column 4: Condition - f
% Column 5: True stamp - s
% Column 6: Foil stamp - 1 condition - s
% Column 7: Foil stamp - 4 condition - s
% Column 8: Foil stamp - novel stamp - s
% Column 9: True stamp position (1 - 4) - f
% Column 10: Foil stamp - 1 position (1 - 4) - f
% Column 11: Foil stamp - 4 position (1 - 4) - f
% Column 12: Foil stamp - novel stamp position (1 - 4) - f
% Column 13: Button press - f
% Column 14: Button press RT - d
% Column 15: Trial Start - d
% Column 16: Trial End - d
% Column 17: ITI duration - d
% Column 18: ITI start - d
% Column 19: ITI end - d
% Column 20: block

formatSpec = '\n %f\t %f\t %s\t %f\t %s\t %s\t %s\t %s\t %f\t %f\t %f\t %f\t %f\t %d\t %d\t %d\t %d\t %d\t %d\t %f';


fileVars = {'sub','trial','stim','freqCond','truePair', 'foilLowFreq', ...
    'foilHighFreq','foilNovel','truePairPos','foilLowFreqPos','foilHighFreqPos', ...
    'foilNovelPos','memResp','memRT','memTrialStart', 'memTrialEnd', 'memTrialITI', ...
    'memTrialITIStart', 'memTrialITIEnd', 'block'};

for fV = 1:length(fileVars)
    PrintType = '%s';
    PrintfV = cell2mat(fileVars(fV));
    fprintf(fileID, [PrintType '\t'], PrintfV);
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

%% Define positions of 4 choices
xMargin = .25*screenXpixels;
pixelsBetweenPics = 50;
answerPicWidth = round((screenXpixels - (xMargin*2) - (3*pixelsBetweenPics))/4);
answerPicHeight = (3/4)*answerPicWidth;
yMargin = screenYpixels - (answerPicHeight + 200);

answerLoc1 = [xMargin yMargin xMargin+answerPicWidth yMargin + answerPicHeight];
answerLoc2 = answerLoc1 + [pixelsBetweenPics+answerPicWidth 0 pixelsBetweenPics+answerPicWidth 0];
answerLoc3 = answerLoc2 + [pixelsBetweenPics+answerPicWidth 0 pixelsBetweenPics+answerPicWidth 0];
answerLoc4 = answerLoc3 + [pixelsBetweenPics+answerPicWidth 0 pixelsBetweenPics+answerPicWidth 0];

rect1 = answerLoc1 + [(-10) (-10) 10 (10)];
rect2 = answerLoc2 + [(-10) (-10) 10 (10)];
rect3 = answerLoc3 + [(-10) (-10) 10 (10)];
rect4 = answerLoc4 + [(-10) (-10) 10 (10)];

%% Present instruction screen
memInstructions = imread('taskInstructionsA/mem2_part2_instructions.jpeg');
memInstructions = imresize(memInstructions, [screenYpixels screenXpixels]);
Screen('PutImage', window, memInstructions); % put image on screen

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

% Loop through trials
for trial = 1:(size(memStimArray,1) - numCards)
    i = trial + numCards;
 
% Load the images
cardImage = memStimArray{i, 1};
cardImage = imread(cardImage);
stamp1 = imread(memStimArray{i,2});
stamp2 = imread(memStimArray{i,3});
stamp3 = imread(memStimArray{i,4});
stamp4 = imread(memStimArray{i,5});

%resize card image
cardImage = imresize(cardImage, [400 300]); 

% Get the size of the image
[s1, s2, s3] = size(cardImage);

% Make the images into textures
cardTexture = Screen('MakeTexture', window, cardImage);
stamp1Texture = Screen('MakeTexture', window, stamp1);
stamp2Texture = Screen('MakeTexture', window, stamp2);
stamp3Texture = Screen('MakeTexture', window, stamp3);
stamp4Texture = Screen('MakeTexture', window, stamp4);

%define the card location
cardLocation = [((screenXpixels/2)-(s1/2)), 200, ((screenXpixels/2)+(s1/2)), 200+s2];

%define the stamp locations
for k = 1:4
    if memStimArray{i,6} == k
        stamp1loc = eval(['answerLoc' int2str(k)]);
    elseif memStimArray{i,7} == k
        stamp2loc = eval(['answerLoc' int2str(k)]);
    elseif memStimArray{i,8} == k
        stamp3loc = eval(['answerLoc' int2str(k)]);
    elseif memStimArray{i,9} == k
        stamp4loc = eval(['answerLoc' int2str(k)]);
    end
end
 
% Draw the card and stamps on the screen
Screen('DrawTexture', window, cardTexture, [], cardLocation, 0);
Screen('DrawTexture', window, stamp1Texture, [], stamp1loc, 0);
Screen('DrawTexture', window, stamp2Texture, [], stamp2loc, 0);
Screen('DrawTexture', window, stamp3Texture, [], stamp3loc, 0);
Screen('DrawTexture', window, stamp4Texture, [], stamp4loc, 0);

% Flip to the screen and start timer
[~, tStart] = Screen('Flip', window, [], 1);
disp(['Trial ' int2str(i) ' of  60 associative memory trials']);

% Initialize response variables
respToBeMade = true;  
response = []; %initialize response 
rt = []; %initialize rt

    while respToBeMade == true && (GetSecs - tStart) < memTestMaxResponsePart2 % if a response has not been made
    [keyIsDown,secs, keyCode] = KbCheck; %check to see if a key has been pressed 
        if keyCode(escapeKey)
            ShowCursor;
            sca;
            return
        elseif keyCode(button1)
            response = 1;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, rect1, 10);
            Screen('Flip', window);
            WaitSecs(.5);
        elseif keyCode(button2)
            response = 2;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, rect2, 10);
            Screen('Flip', window);
            WaitSecs(.5);
        elseif keyCode(button3)
            response = 3;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, rect3, 10);
            Screen('Flip', window);
            WaitSecs(.5);
        elseif keyCode(button4)
            response = 4;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, rect4, 10);
            Screen('Flip', window);
            WaitSecs(.5);
        end
    end
    
%% Close textures
Screen('Close', cardTexture);
Screen('Close', stamp1Texture);
Screen('Close', stamp2Texture);
Screen('Close', stamp3Texture);
Screen('Close', stamp4Texture);

tEnd = GetSecs;

%% ITI - no jitter
itiInterval = .5;
Screen('FillRect', window, black);
Screen('DrawLines', window, fixCoords, lineWidthPix, white, [xCenter yCenter]); 
[~, ITIStart] = Screen('Flip', window);
HideCursor();
WaitSecs(itiInterval);
ITIEnd = GetSecs;
 
 %% Add the trial data to the array
memDataArray{trial,1} = subjectNumber;
memDataArray{trial,2} = i;
memDataArray{trial,3} = memStimArray{i,1}; %card stim
memDataArray{trial,4} = memStimArray{i,10}; %condition
memDataArray{trial,5} = memStimArray{i,2}; %true stamp
memDataArray{trial,6} = memStimArray{i,3}; %foil stamp 1
memDataArray{trial,7} = memStimArray{i,4}; %foil stamp 4
memDataArray{trial,8} = memStimArray{i,5}; %foil stamp novel
memDataArray{trial,9} = memStimArray{i,6}; %true stamp position
memDataArray{trial,10} = memStimArray{i,7}; %foil stamp 1 position
memDataArray{trial,11} = memStimArray{i,8}; %foil stamp 4 position
memDataArray{trial,12} = memStimArray{i,9}; %foil stamp novel position
memDataArray{trial,13} = response;
memDataArray{trial,14} = rt; 
memDataArray{trial,15} = tStart; 
memDataArray{trial,16} = tEnd;
memDataArray{trial,17} = memStimArray{i,11}; %ITI duration
memDataArray{trial,18} = ITIStart;
memDataArray{trial,19} = ITIEnd;
memDataArray{trial,20} = block;

 %% Save data
 fileID = fopen(mem_filename, 'a');
 fprintf(fileID,formatSpec,memDataArray{trial, :});
 fclose(fileID);

  end
    
%% Compute how well they did 
 for i = 1:size(memDataArray,1)
     if memDataArray{i,9} == memDataArray{i,13} %if the true stamp position = response
         memDataArray{i,21} = 1;
     else
         memDataArray{i,21} = 0;
     end
 end
 
 %Compute overall accuracy
 cardsStampedPart2 = sum(cellfun(@double,memDataArray(:,21)));
 cardsStamped = cardsStampedPart1 + cardsStampedPart2;
     
%% End screen
 line1 = 'Great job!';
 line2 = '\n\n You framed ';
 line3 = int2str(cardsStamped);
 line4 = ' pictures correctly!';
% 
 % Draw all the text in one go
 Screen('TextSize', window, 30);
 DrawFormattedText(window, [line1 line2 line3 line4],'center', screenYpixels * 0.33, white);
 
 % Flip to the screen
 Screen('Flip', window);
 
 %wait for end of run
 timeElapsed = GetSecs - taskStartTime;
 disp(['The memory test took ' int2str(timeElapsed) ' seconds.']);
 WaitSecs(endTimeBuffer + 3);
 
 
%save task variables
save('taskVarsBlock2.mat'); 
 
% Clear the screen
sca;




