%% FREQUENCY REPORTS %%
% In this task, participants need to report how many times they saw the
% stimulus in the first task.

%% Freq reports data file
freqReports_filename = ['sub', int2str(subjectNumber), '_', date, '_mem1_freqReports_mri.txt'];
fileID = fopen(freqReports_filename, 'w');

%specify file format: 

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
% Column 11: Block

formatSpec2 = '\n %f\t %f\t %s\t %f\t %d\t %d\t %d\t %d\t %d\t %d\t %f'; 

fileVars = {'sub','trial','stim','freqReport','freqReportRT', 'freqReportTrialStart', ...
    'freqReportTrialEnd','freqReportITI','freqReportITITrialStart','freqReportITITrialEnd', 'block'};

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


 
%% PART 2: Test Explicit representations of the frequencies % 
% Present instructions for second phase of memory test
memInstructions = imread('taskInstructionsA/freqMem1_instructions.jpeg');
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


%% Start ITI
Screen('DrawLines', window, fixCoords,lineWidthPix, white, [xCenter yCenter]);
[~, beginningITIstart] = Screen('Flip', window);
WaitSecs(startITI);
beginningITIend = GetSecs();


%% Loop through frequency report trials
 for j = 1:numCards
     
    % Load the image
     cardImage = memFreqStimArray{j, 1};
     cardImage = imread(cardImage);
 
     %resize images
     cardImage = imresize(cardImage, [300 300]); 
 
     % Get the size of the image
     [s1, s2, s3] = size(cardImage);
 
     % Make the image into a texture
     cardTexture = Screen('MakeTexture', window, cardImage);
     respTexture = Screen('MakeTexture', window, respImage);
     
     %define the card locations
     cardLocation = [((screenXpixels/2)-(s1/2)), 200, ((screenXpixels/2)+(s1/2)), 200+s2];
  
     % Draw the card on the screen
     Screen('DrawTexture', window, cardTexture, [], cardLocation, 0);
     Screen('DrawTexture', window, respTexture, [], respLocation, 0);
 
     % Flip to the screen
     [~, tStart] = Screen('Flip', window, [], 1);
     disp(['Trial ' int2str(j) ' of  24 frequency reports']);
     
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
memFreqReportsDataArray{j, 11} = block;
 

% Save data
fileID = fopen(freqReports_filename, 'a');
fprintf(fileID, formatSpec2, memFreqReportsDataArray{j, :});
fclose(fileID);
   
 end
 
%% END ITI
Screen('DrawLines', window, fixCoords,lineWidthPix, white, [xCenter yCenter]);
[~, endITIstart] = Screen('Flip', window);
WaitSecs(endITI);
endITIend = GetSecs();


%% Add beginning ITI to file
memFreqReportsDataArray{numCards + 1, 1} = subjectNumber;
memFreqReportsDataArray{numCards + 1, 2} = 0;
memFreqReportsDataArray{numCards + 1, 3} = 'beginningITI'; %card stim
memFreqReportsDataArray{numCards + 1, 4} = [];
memFreqReportsDataArray{numCards + 1, 5} = [];
memFreqReportsDataArray{numCards + 1, 6} = [];
memFreqReportsDataArray{numCards + 1, 7} = [];
memFreqReportsDataArray{numCards + 1, 8} = startITI; %ITI duration
memFreqReportsDataArray{numCards + 1, 9} = beginningITIstart;
memFreqReportsDataArray{numCards + 1, 10} = beginningITIend;
memFreqReportsDataArray{numCards + 1, 11} = block;

%% Add ending ITI to file
memFreqReportsDataArray{numCards + 2, 1} = subjectNumber;
memFreqReportsDataArray{numCards + 2, 2} = numCards + 1;
memFreqReportsDataArray{numCards + 2, 3} = 'endingITI'; %card stim
memFreqReportsDataArray{numCards + 2, 4} = [];
memFreqReportsDataArray{numCards + 2, 5} = [];
memFreqReportsDataArray{numCards + 2, 6} = [];
memFreqReportsDataArray{numCards + 2, 7} = [];
memFreqReportsDataArray{numCards + 2, 8} = endITI; %ITI duration
memFreqReportsDataArray{numCards + 2, 9} = endITIstart;
memFreqReportsDataArray{numCards + 2, 10} = endITIend;
memFreqReportsDataArray{numCards + 2, 11} = block;
 
%% End screen
line1 = 'Great job!';
 
% Draw all the text in one go
Screen('TextSize', window, 30);
DrawFormattedText(window, [line1],'center', screenYpixels * 0.33, white);

% Flip to the screen
HideCursor();
[~, endScreenStart] = Screen('Flip', window);

%wait for end of run
timeElapsed = GetSecs - taskStartTime;
disp(['The frequency reports took ' int2str(timeElapsed) ' seconds.']);
WaitSecs(endTimeBuffer+3);
endScreenEnd = GetSecs;

%% Add end screen timing to file
memFreqReportsDataArray{numCards + 3, 1} = subjectNumber;
memFreqReportsDataArray{numCards + 3, 2} = numCards + 2;
memFreqReportsDataArray{numCards + 3, 3} = 'endScreen'; %card stim
memFreqReportsDataArray{numCards + 3, 4} = [];
memFreqReportsDataArray{numCards + 3, 5} = [];
memFreqReportsDataArray{numCards + 3, 6} = [];
memFreqReportsDataArray{numCards + 3, 7} = [];
memFreqReportsDataArray{numCards + 3, 8} = endTimeBuffer + 3; %ITI duration
memFreqReportsDataArray{numCards + 3, 9} = endScreenStart;
memFreqReportsDataArray{numCards + 3, 10} = endScreenEnd;
memFreqReportsDataArray{numCards + 3, 11} = block;

%% Save data
fileID = fopen(freqReports_filename, 'a');
fprintf(fileID, formatSpec2, memFreqReportsDataArray{numCards + 1, :});
fprintf(fileID, formatSpec2, memFreqReportsDataArray{numCards + 2, :});
fprintf(fileID, formatSpec2, memFreqReportsDataArray{numCards + 3, :});
fclose(fileID);

%save task variables
save('taskVars.mat'); 
 
% Clear the screen
sca;



