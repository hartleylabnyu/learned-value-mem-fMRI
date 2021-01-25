%% MEMORY TEST %%
% In this task, participants now need to put stamps on the cards that they saw in
% the previous two tasks. Each card will be presented the same number of
% times as in the frequency task.

%% Create 2 data files: One for the main memory data and one for the frequency reports
mem_filename = ['sub', int2str(subjectNumber), '_', date, '_mem_tutorial.txt'];
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

formatSpec = '\n %f\t %f\t %s\t %f\t %s\t %s\t %s\t %s\t %f\t %f\t %f\t %f\t %f\t %d\t %d\t %d\t %d\t %d\t %d';


fileVars = {'sub','trial','stim','freqCond','truePair', 'foilLowFreq', ...
    'foilHighFreq','foilNovel','truePairPos','foilLowFreqPos','foilHighFreqPos', ...
    'foilNovelPos','memResp','memRT','memTrialStart', 'memTrialEnd', 'memTrialITI', ...
    'memTrialITIStart', 'memTrialITIEnd'};

for fV = 1:length(fileVars)
    PrintType = '%s';
    PrintfV = cell2mat(fileVars(fV));
    fprintf(fileID, [PrintType '\t'], PrintfV);
end

%% Freq reports data file
freqReports_filename = ['sub', int2str(subjectNumber), '_', date, '_mem_freqReports_tutorial.txt'];
fileID = fopen(freqReports_filename, 'w');

%specify file format. 

% Column 1: Subject number 
% Column 2: Trial
% Column 3: card stimulus
% Column 4: button response
% Column 5: RT
% Column 6: trial start
% Column 7: trial end
% Column 8: ITI duration
% Column 9: ITI start
% Column 10: ITI end

formatSpec2 = '\n %f\t %f\t %s\t %f\t %d\t %d\t %d\t %d\t %d\t %d'; 

fileVars = {'sub','trial','stim','freqReport','freqReportRT', 'freqReportTrialStart', ...
    'freqReportTrialEnd','freqReportITI','freqReportITITrialStart','freqReportITITrialEnd'};

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

%% Make the image for the frequency responses
%create black rectangle
backgroundImage = zeros(465, 1280,3, 'uint8');
result = backgroundImage;

% read in images of numbers 1:7
 addpath 'stim/memTestFreqResp';
 respStim=dir('stim/memTestFreqResp/*.jpg');
 respArray = {respStim.name}'; 
 respArray = respArray((1:7), 1);

 for i = 1:length(respArray)
     respArray{i, 2} = i;
 end
 
%define size of response images
respSize1 = 100;
spacing = 10;

%Define the locations where the frequency response images should go
gridStartX = round((screenXpixels -((respSize1+spacing)*6+respSize1))/2);
gridStartY = yMargin;
numColumns = 7;
gridLocations = ones(numColumns, 2);
gridLocations(:,2) = 1:7;

%define x coordinate of lower left corner
for i = 1:numColumns
 gridLocations(i, 1) = gridStartX + (i-1)*(respSize1+spacing);
end

%define coordinate of lower left corner
gridLocations(:, 2) = gridStartY;

 for i = 1:7
     %read in image
     respImage = imread(respArray{i,1});
     %resize image
     respImage = imresize(respImage, [75 75]);
     obj = respImage;
     colshift = gridLocations(i,1);
     rowshift = gridLocations(i,2) - (yMargin);
 %   Perform the actual indexing to replace the scene's pixels with the object
     result((1:size(obj,1))+rowshift, (1:size(obj,2))+colshift, :) = obj;      
 end
   
%save the result as the resp image
 respImage = result;
 sizeResp= size(respImage);
 respLocation = [0 yMargin sizeResp(2) sizeResp(1)+yMargin];
 
 % define the locations of the frequency responses
 respRect1 = [(gridLocations(1,1) - 10) (gridLocations(1,2) -10) (gridLocations(1,1) +10)+size(obj,1)  (gridLocations(1,2) +10)+size(obj,1)]; 
 respRect2 = [(gridLocations(2,1) - 10) (gridLocations(2,2) -10) (gridLocations(2,1) +10)+size(obj,1)  (gridLocations(2,2) +10)+size(obj,1)];
 respRect3 = [(gridLocations(3,1) - 10) (gridLocations(3,2) -10) (gridLocations(3,1) +10)+size(obj,1)  (gridLocations(3,2) +10)+size(obj,1)];
 respRect4 = [(gridLocations(4,1) - 10) (gridLocations(4,2) -10) (gridLocations(4,1) +10)+size(obj,1)  (gridLocations(4,2) +10)+size(obj,1)];
 respRect5 = [(gridLocations(5,1) - 10) (gridLocations(5,2) -10) (gridLocations(5,1) +10)+size(obj,1)  (gridLocations(5,2) +10)+size(obj,1)];
 respRect6 = [(gridLocations(6,1) - 10) (gridLocations(6,2) -10) (gridLocations(6,1) +10)+size(obj,1)  (gridLocations(6,2) +10)+size(obj,1)];
 respRect7 = [(gridLocations(7,1) - 10) (gridLocations(7,2) -10) (gridLocations(7,1) +10)+size(obj,1)  (gridLocations(7,2) +10)+size(obj,1)];

%% Present instruction screens
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 29:33
instructionPicName = ['tutInstructionsB/Slide', int2str(i), '.jpeg'];
I1 = imread(instructionPicName);
Screen('PutImage', window, I1); % put image on screen

% Flip to the screen
HideCursor();
Screen('Flip', window);
KbStrokeWait;
end

taskStartTime = GetSecs;
for i = 1:numCards %loop through the first 24 postcards so that each is presented once
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
cardLocation = [((screenXpixels/2)-(s1/2)), 100, ((screenXpixels/2)+(s1/2)), 100+s2];

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
disp(['Trial ' int2str(i) ' of first 4 associative memory trials']);

% Initialize response variables
respToBeMade = true;  
response = []; %initialize response 
rt = []; %initialize rt

    while respToBeMade == true && (GetSecs - tStart) < memTestMaxResponse % if a response has not been made and the maxtime has not elapsed
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
            WaitSecs(memTestMaxResponse - (GetSecs - tStart));
        elseif keyCode(button2)
            response = 2;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, rect2, 10);
            Screen('Flip', window);
            WaitSecs(memTestMaxResponse - (GetSecs - tStart));
        elseif keyCode(button3)
            response = 3;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, rect3, 10);
            Screen('Flip', window);
            WaitSecs(memTestMaxResponse - (GetSecs - tStart));
        elseif keyCode(button4)
            response = 4;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, rect4, 10);
            Screen('Flip', window);
            WaitSecs(memTestMaxResponse - (GetSecs - tStart)); 
        end
    end
  
%% Close textures
Screen('Close', cardTexture);
Screen('Close', stamp1Texture);
Screen('Close', stamp2Texture);
Screen('Close', stamp3Texture);
Screen('Close', stamp4Texture);

tEnd = GetSecs;

%% ITI with jitter
itiInterval = memStimArray{i,11};

%draw fixation cross
Screen('FillRect', window, black);
Screen('DrawLines', window, fixCoords, lineWidthPix, white, [xCenter yCenter]); 
[~, ITIStart] = Screen('Flip', window); %display fixation cross
HideCursor(); 
WaitSecs(itiInterval); %wait for ITI duration
ITIEnd = GetSecs; %get end time
 
 %% Add info to data array
memDataArray{i,1} = subjectNumber;
memDataArray{i,2} = i;
memDataArray{i,3} = memStimArray{i,1}; %card stim
memDataArray{i,4} = memStimArray{i,10}; %condition
memDataArray{i,5} = memStimArray{i,2}; %true stamp
memDataArray{i,6} = memStimArray{i,3}; %foil stamp 1
memDataArray{i,7} = memStimArray{i,4}; %foil stamp 4
memDataArray{i,8} = memStimArray{i,5}; %foil stamp novel
memDataArray{i,9} = memStimArray{i,6}; %true stamp position
memDataArray{i,10} = memStimArray{i,7}; %foil stamp 1 position
memDataArray{i,11} = memStimArray{i,8}; %foil stamp 4 position
memDataArray{i,12} = memStimArray{i,9}; %foil stamp novel position
memDataArray{i,13} = response;
memDataArray{i,14} = rt; 
memDataArray{i,15} = tStart; 
memDataArray{i,16} = tEnd;
memDataArray{i,17} = memStimArray{i,11}; %ITI duration
memDataArray{i,18} = ITIStart;
memDataArray{i,19} = ITIEnd;
 
 %% Save data
 fileID = fopen(mem_filename, 'a');
 fprintf(fileID,formatSpec,memDataArray{i, :});
 
 %fprintf writes a space-delimited file.
 %Close the file.
 fclose(fileID);

end
% 
% 
% 
% 
% 
% 
% 

%% PART 2: Test Explicit representations of the frequencies %    
% %% Present instructions for second phase of memory test
 for i = 34:38
 instructionPicName = ['tutInstructionsB/Slide', int2str(i), '.jpeg'];
 I1 = imread(instructionPicName);
 Screen('PutImage', window, I1); % put image on screen
% 
% % Flip to the screen
 HideCursor();
 Screen('Flip', window);
 KbStrokeWait;
 end
% 
%% Loop through frequency report trials
 for j = 1:numCards
     
    % Load the image
     cardImage = memFreqStimArray{j, 1};
     cardImage = imread(cardImage);
 
     %resize images
     cardImage = imresize(cardImage, [400 300]); 
 
     % Get the size of the image
     [s1, s2, s3] = size(cardImage);
 
     % Make the image into a texture
     cardTexture = Screen('MakeTexture', window, cardImage);
     respTexture = Screen('MakeTexture', window, respImage);
     
     %define the card locations
     cardLocation = [((screenXpixels/2)-(s1/2)), 100, ((screenXpixels/2)+(s1/2)), 100+s2];
  
     % Draw the card on the screen
     Screen('DrawTexture', window, cardTexture, [], cardLocation, 0);
     Screen('DrawTexture', window, respTexture, [], respLocation, 0);
 
     % Flip to the screen
     [~, tStart] = Screen('Flip', window, [], 1);
     disp(['Trial ' int2str(j) ' of  4 frequency reports']);
     
     % Initialize response variables
     respToBeMade = true;  
     response = []; %initialize response
     rt = []; %initialize rt
    
 
 %Get response information
     while respToBeMade == true && (GetSecs - tStart) < memTestMaxResponse %if a valid response has not been made
         [keyIsDown,secs, keyCode] = KbCheck; %check for keypress
         if keyCode(escapeKey)
            ShowCursor;
            sca;
            return
         elseif keyCode(button1)
            response = 4;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, respRect4, 10);
            Screen('Flip', window);
            WaitSecs(memTestMaxResponse - (GetSecs - tStart)); 
         elseif keyCode(button2)
            response = 5;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, respRect5, 10);
            Screen('Flip', window);
            WaitSecs(memTestMaxResponse - (GetSecs - tStart)); 
        elseif keyCode(button3)
            response = 6;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, respRect6, 10);
            Screen('Flip', window);
            WaitSecs(memTestMaxResponse - (GetSecs - tStart)); 
        elseif keyCode(button4)
            response = 7;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, respRect7, 10);
            Screen('Flip', window);
            WaitSecs(memTestMaxResponse - (GetSecs - tStart)); 
        elseif keyCode(button5)
            response = 1;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, respRect1, 10);
            Screen('Flip', window);
            WaitSecs(memTestMaxResponse - (GetSecs - tStart)); 
        elseif keyCode(button6)
            response = 2;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, respRect2, 10);
            Screen('Flip', window);
            WaitSecs(memTestMaxResponse - (GetSecs - tStart)); 
        elseif keyCode(button7)
            response = 3;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, respRect3, 10);
            Screen('Flip', window);
            WaitSecs(memTestMaxResponse - (GetSecs - tStart)); 
         end
     end
     
%% Close textures
Screen('Close', cardTexture);
Screen('Close', respTexture);

tEnd = GetSecs;  

%% ITI
itiInterval = memFreqStimArray{j,3};

%draw fixation cross 
Screen('FillRect', window, black);
Screen('DrawLines', window, fixCoords, lineWidthPix, white, [xCenter yCenter]);
[~, ITIStart] = Screen('Flip', window);
WaitSecs(itiInterval);
ITIEnd = GetSecs;
 

% Add the trial data to the array
memFreqReportsDataArray{j, 1} = subjectNumber;
memFreqReportsDataArray{j, 2} = j;
memFreqReportsDataArray{j, 3} = memFreqStimArray{j,1}; %card stim
memFreqReportsDataArray{j, 4} = response;
memFreqReportsDataArray{j, 5} = rt;
memFreqReportsDataArray{j, 6} = tStart;
memFreqReportsDataArray{j, 7} = tEnd;
memFreqReportsDataArray{j, 8} = memFreqStimArray{j,3}; %ITI duration
memFreqReportsDataArray{j, 9} = ITIStart;
memFreqReportsDataArray{j, 10} = ITIEnd;
 
 
% Save data
fileID = fopen(freqReports_filename, 'a');
fprintf(fileID,formatSpec2,memFreqReportsDataArray{j, :});
fclose(fileID);
   
 end
%%

% 
% 
% 
% 
% 
% 
% 
% 
% 


%% Part 3 of memory test
% Present instructions for third phase of memory test
 for i = 39:41
 instructionPicName = ['tutInstructionsB/Slide', int2str(i), '.jpeg'];
 I1 = imread(instructionPicName);
 Screen('PutImage', window, I1); % put image on screen
 
 % Flip to the screen
 HideCursor();
 Screen('Flip', window);
 KbStrokeWait;
 end
 
% Loop through trials
for i = numCards+1:size(memStimArray,1) 
 
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
cardLocation = [((screenXpixels/2)-(s1/2)), 100, ((screenXpixels/2)+(s1/2)), 100+s2];

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
disp(['Trial ' int2str(i) ' of  10 associative memory trials']);

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
            WaitSecs(memTestMaxResponsePart2 - (GetSecs-tStart));
        elseif keyCode(button2)
            response = 2;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, rect2, 10);
            Screen('Flip', window);
            WaitSecs(memTestMaxResponsePart2 - (GetSecs-tStart));
        elseif keyCode(button3)
            response = 3;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, rect3, 10);
            Screen('Flip', window);
            WaitSecs(memTestMaxResponsePart2 - (GetSecs-tStart));
        elseif keyCode(button4)
            response = 4;
            rt = GetSecs - tStart;
            respToBeMade = false;
            Screen('FrameRect', window, grey, rect4, 10);
            Screen('Flip', window);
            WaitSecs(memTestMaxResponsePart2 - (GetSecs-tStart));
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
memDataArray{i,1} = subjectNumber;
memDataArray{i,2} = i;
memDataArray{i,3} = memStimArray{i,1}; %card stim
memDataArray{i,4} = memStimArray{i,10}; %condition
memDataArray{i,5} = memStimArray{i,2}; %true stamp
memDataArray{i,6} = memStimArray{i,3}; %foil stamp 1
memDataArray{i,7} = memStimArray{i,4}; %foil stamp 4
memDataArray{i,8} = memStimArray{i,5}; %foil stamp novel
memDataArray{i,9} = memStimArray{i,6}; %true stamp position
memDataArray{i,10} = memStimArray{i,7}; %foil stamp 1 position
memDataArray{i,11} = memStimArray{i,8}; %foil stamp 4 position
memDataArray{i,12} = memStimArray{i,9}; %foil stamp novel position
memDataArray{i,13} = response;
memDataArray{i,14} = rt; 
memDataArray{i,15} = tStart; 
memDataArray{i,16} = tEnd;
memDataArray{i,17} = memStimArray{i,11}; %ITI duration
memDataArray{i,18} = ITIStart;
memDataArray{i,19} = ITIEnd;

 %% Save data
 fileID = fopen(mem_filename, 'a');
 fprintf(fileID,formatSpec,memDataArray{i, :});
 fclose(fileID);

  end
    
%% Compute how well they did 
 for i = 1:size(memDataArray,1)
     if memDataArray{i,9} == memDataArray{i,13} %if the true stamp position = response
         memDataArray{i,20} = 1;
     else
         memDataArray{i,20} = 0;
     end
 end
 
 %Compute overall accuracy
 cardsStamped = sum(cellfun(@double,memDataArray(:,20)));
     
%% End screen
 line1 = 'Great job!';
 line2 = '\n\n You stamped ';
 line3 = int2str(cardsStamped);
 line4 = ' postcards correctly!';
% 
 % Draw all the text in one go
 Screen('TextSize', window, 30);
 DrawFormattedText(window, [line1 line2 line3 line4],'center', screenYpixels * 0.33, white);
 
 % Flip to the screen
 Screen('Flip', window);
 
 %wait for end of run
 timeElapsed = GetSecs - taskStartTime;
 disp(['The memory test took ' int2str(timeElapsed) ' seconds.']);
WaitSecs(endTimeBuffer+3);
 
% Clear the screen
sca;
