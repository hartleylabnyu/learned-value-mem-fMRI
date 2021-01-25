%% Generate stimulus arrays used in all three tasks - Version A, practice

%% Frequency task
% determine number of trials and ITIs for each condition
numFreqTrials = ((numCards/2) * (freq1 + freq2));
freqITIvec = jitterVec;
firstRepITIsA = freqITIvec(randperm(length(freqITIvec)));
firstRepITIsB = freqITIvec(randperm(length(freqITIvec)));
firstRepITIs = [firstRepITIsA, firstRepITIsB]';
secondRepITIs = freqITIvec(randperm(length(freqITIvec)));
thirdRepITIs = freqITIvec(randperm(length(freqITIvec)));
fourthRepITIs = freqITIvec(randperm(length(freqITIvec)));
fifthRepITIs = freqITIvec(randperm(length(freqITIvec)));

%% Assign cards to frequency conditions
% Create list of card stimuli
cardStim = dir('stim/practiceCards/*.jpg');
cardArray = {cardStim.name};

% Add frequency information to list
freq1vec = freq1.*ones((numCards/2), 1);
freq2vec = freq2.*ones((numCards/2), 1);
frequencies = [freq1vec; freq2vec];

%assign cards to frequencies
for i = 1:numCards
    card = cardArray{i};
    freqArray{i,1} = card;
    freqArray{i,2} = frequencies(i);
end

%Ensure that high frequency cards are presented the right number of times
%create empty stim array
freqStimArray = cell.empty(numCards, 0);

for i = 1:numCards
    freqStimArray{i,1} = freqArray{i,1}; %first 24 rows of stimulus array have each card
    freqStimArray{i,2} = freqArray{i,2};
    freqStimArray{i,3} = firstRepITIs(i);
end

%then make the next 4 rows of the array, which should have all the cards
%that are repeated 4 times (second apperance)
for i = 1:(numCards/2)
    freqStimArray{i+numCards,1} = freqArray{i+(numCards/2),1};
    freqStimArray{i+numCards,2} = freqArray{i+(numCards/2),2};
    freqStimArray{i+numCards,3} = secondRepITIs(i);
end

%then make the next 12 rows of the array, which should have all the cards
%that are repeated 4 times (3rd appearance)
for i = 1:(numCards/2)
    freqStimArray{i+(numCards+.5*numCards),1} = freqArray{i+(numCards/2),1};
    freqStimArray{i+(numCards+.5*numCards),2} = freqArray{i+(numCards/2),2};
    freqStimArray{i+(numCards+.5*numCards),3} = thirdRepITIs(i);
end

%then make the next 12 rows of the array, which should have all the cards
%that are repeated 4 times (4th appearance)
for i = 1:(numCards/2)
    freqStimArray{i+(numCards+numCards),1} = freqArray{i+(numCards/2),1};
    freqStimArray{i+(numCards+numCards),2} = freqArray{i+(numCards/2),2};
    freqStimArray{i+(numCards+numCards),3} = fourthRepITIs(i);
end


%then make the next 12 rows of the array, which should have all the cards
%that are repeated 5 times (5th appearance)
for i = 1:(numCards/2)
    freqStimArray{i+(numCards*2.5),1} = freqArray{i+(numCards/2),1};
    freqStimArray{i+(numCards*2.5),2} = freqArray{i+(numCards/2),2};
    freqStimArray{i+(numCards*2.5),3} = fifthRepITIs(i);
end


%randomize order of stimulus array
freqStimOrdered = freqStimArray; %use this later
freqStimArray = freqStimArray(randperm(size(freqStimArray,1)),:);



%%%%%%%%%%%%%%%%%%%%%%%%%%
% PAIRED-ASSOCIATES TASK %
%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Create array with random card / stamp pairings
% Create lists of food stimuli and animal stimuli
stampStim=dir('stim/practiceStamps/*.jpg');
stampArray = {stampStim.name}; 

%Randomize order of stimulus arrays
stampOrder = randperm(numCards); %generate random food order
%cardOrder = randperm(numCards); %generate random animal order
leftRight = ones(1,(numCards/2)); leftRight(1, (numCards/4)) = 2; %create vector of 1s and 2s
leftRightLowFreq = leftRight(randperm(length(leftRight))); %randomize the order
leftRightHighFreq = leftRight(randperm(length(leftRight))); %randomize the order

%Generate vector of ITI durations
ITIvec = jitterVec; %paITImin + (paITImax-paITImin).*rand((numCards/2),1);
highFreqITIs = ITIvec(randperm(length(ITIvec))); %assign the same ITIs to cards in the high and low frequency conditions
lowFreqITIs = ITIvec(randperm(length(ITIvec)));
highFreqIndex = 1;
lowFreqIndex = 1;

%create empty PA_stim array
PA_stimArray = cell.empty(numCards, 0);

%fill in array
for i = 1:numCards 
    PA_stimArray{i,1} = stampArray{stampOrder(i)}; %stamp
    PA_stimArray{i,2} = freqArray{i, 1}; %card
    PA_stimArray{i,4} = freqArray{i, 2}; %condition
    if PA_stimArray{i, 4} == freq1
        PA_stimArray{i,5} = lowFreqITIs(lowFreqIndex); %assign ITI based on condition
        PA_stimArray{i,3} = leftRightLowFreq(lowFreqIndex);
        lowFreqIndex = lowFreqIndex + 1;
    elseif PA_stimArray{i, 4} == freq2
        PA_stimArray{i,5} = highFreqITIs(highFreqIndex);
        PA_stimArray{i,3} = leftRightHighFreq(highFreqIndex);
        highFreqIndex = highFreqIndex + 1;
    end   
end

%shuffle order
PA_stimArray = PA_stimArray(randperm(size(PA_stimArray,1)),:);


%%%%%%%%%%%%%%%
% MEMORY TEST %
%%%%%%%%%%%%%%%
%% Generate array of postcards, stamps, and frequency conditions
allStim = PA_stimArray(:, [1:2, 4]);

% Generate list of stamps in the 1 frequency condition
lowFreqStamps = allStim((cell2mat(allStim(:,3)) == freq1), 1);
lowFreqStamps = [lowFreqStamps; lowFreqStamps]; %double it because each one will be a foil twice

% Generate list of stamps in the 4 frequency condition
highFreqStamps = allStim((cell2mat(allStim(:,3)) == freq2), 1);
highFreqStamps = [highFreqStamps; highFreqStamps];

% Generate list of novel stamps
novelStamps = stampArray(numCards + 1: end)';
novelStamps = [novelStamps; novelStamps];

% Generate list of all cards
allCards = cardArray(randperm(length(cardArray)))';

% Generate groups of cards with their true stamp and 3 foil stamps
memStimArray = cell.empty(numCards, 0);
memStimArray(:,1) = allCards;

% Add correct stamp to array
[~,ia,ib] = intersect(memStimArray(:,1),PA_stimArray(:,2)); 
memStimArray = [memStimArray(ia, :),PA_stimArray(ib,1)];

%generate 3 random lists of 4 numbers
randVec = 1:4;
randVec1 = randperm(length(randVec));
randVec2 = randperm(length(randVec));
randVec3 = randperm(length(randVec));

% Add foil stamps
for i = 1:numCards
    randIdx1 = randVec1(i);
    randIdx2 = randVec2(i);
    randIdx3 = randVec3(i);
    memStimArray(i, 3) = lowFreqStamps(randIdx1);    
    memStimArray(i, 4) = highFreqStamps(randIdx2);
    memStimArray(i, 5) = novelStamps(randIdx3); 
end

% Go through the whole array and make sure none of the foil stamps are the
% same as the true stamps

idx = find(strcmp(memStimArray(:, 2), memStimArray(:,3)) == 1);
idx2 = find(strcmp(memStimArray(:, 2), memStimArray(:,4)) == 1);

if isempty(idx) == 1 && isempty(idx2) == 1
     disp('Memory test array has been checked for duplicates.')
end

if isempty(idx) == 0 || isempty(idx2) == 0
    while isempty(idx) == 0 || isempty(idx2) == 0
        memStimArray =  shufflerows(memStimArray, idx, idx2, numCards);
        idx = find(strcmp(memStimArray(:, 2), memStimArray(:,3)) == 1);
        idx2 = find(strcmp(memStimArray(:, 2), memStimArray(:,4)) == 1);
    end

    if isempty(idx) == 1 && isempty(idx2) == 1
        disp('Memory test array has been checked for duplicates.')
    end
end

%generate vector of ITIs
memTestITIs = jitterVec; %memTestITImin + (memTestITImax-memTestITImin).*rand((numCards/2),1);
lowFreqITIs = memTestITIs(randperm(length(memTestITIs)));
highFreqITIs = memTestITIs(randperm(length(memTestITIs)));
lowFreqITIindex = 1;
highFreqITIindex = 1;


for i = 1:numCards
    locationVec = randperm(4);
    memStimArray{i,6} = locationVec(1);
    memStimArray{i,7} = locationVec(2);
    memStimArray{i,8} = locationVec(3);
    memStimArray{i,9} = locationVec(4);
end

%shuffle array
memStimArray = memStimArray(randperm(size(memStimArray,1)),:);


%get the frequency condition labels for each stim
for i = 1:numCards
    memStimVec = memStimArray(:,1);
    allStimVec = allStim(:,2);
    freqIdx = find(strcmp(memStimVec(i), allStimVec) == 1);
    memStimArray{i, 10} = allStim{freqIdx, 3};
end

%Assign ITIs
for i = 1:numCards
    if memStimArray{i, 10} == freq1
        memStimArray{i,11} = lowFreqITIs(lowFreqITIindex);
        lowFreqITIindex = lowFreqITIindex + 1;
    elseif memStimArray{i, 10} == freq2
        memStimArray{i,11} = highFreqITIs(highFreqITIindex);
        highFreqITIindex = highFreqITIindex + 1;
    end
end

   
%memStimOrdered lists each postcard once
memStimOrdered = memStimArray;

%create a new memTest array where the postcards in the 5 condition are
%repeated 4 times

%create array with the high frequency card rows of the memTestArray
highFreqRows = find(cell2mat(memStimArray(:,10)) == freq2);
highFreqCardArray = memStimArray(highFreqRows, :);

%repeat it four times
memTestArrayRepetitions = [highFreqCardArray; highFreqCardArray; highFreqCardArray; highFreqCardArray];

%shuffle the order
memTestArrayRepetitions = memTestArrayRepetitions(randperm(size(memTestArrayRepetitions,1)),:);

%Add non-jittered ITIs
for i = 1:size(memTestArrayRepetitions,1)
    memTestArrayRepetitions{i,11} = .5;
end

%Make the final memTestArray
memStimArray = [memStimOrdered; memTestArrayRepetitions];
% memStimArray will be used for the regular memory trials


%% Create array for memory frequency test
 %take one trial for each card
 memFreqStimArray = memStimOrdered(:,[1, 10]); %cards and conditions
 
 %shuffle order
 memFreqStimArray = memFreqStimArray(randperm(size(memFreqStimArray,1)),:);
 
 %change jitter
 lowFreqITIindex = 1; %reset index variables
 highFreqITIindex = 1;
 
 %shuffle jitter vectors
 lowFreqITIs = lowFreqITIs(randperm(length(lowFreqITIs)));
 highFreqITIs = highFreqITIs(randperm(length(highFreqITIs)));
 
 for i = 1:numCards
    if memFreqStimArray{i, 2} == freq1
        memFreqStimArray{i,3} = lowFreqITIs(lowFreqITIindex);
        lowFreqITIindex = lowFreqITIindex + 1;
    elseif memFreqStimArray{i, 2} == freq2
        memFreqStimArray{i,3} = highFreqITIs(highFreqITIindex);
        highFreqITIindex = highFreqITIindex + 1;
    end
 end

 %% Save all variables in mat file %%
save('tutVars.mat'); 
