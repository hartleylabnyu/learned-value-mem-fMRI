%% PART 6: 2nd block: Run frequency task %%
clearvars -except subjectNumber cbNumber cbNumber2 debugMode taskVersion

Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);
rng('shuffle');
KbName('UnifyKeyNames');

 %add path to scripts
 addpath 'scripts'
 
 %create experiment constants
 run expConstants
 block = 2;

if strcmp(taskVersion, 'A') == 1
    run stimArrays2;
    run frequency2;
elseif strcmp(taskVersion, 'B') == 1
    run stimArrays1;
    run frequency1;
end

disp('You just ran Part 6. Run Part 7 next.');


