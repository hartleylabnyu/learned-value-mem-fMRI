%% PART 2: Run paired associates task %%
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);
rng('shuffle');
KbName('UnifyKeyNames');

if strcmp(taskVersion, 'A') == 1
    run pairedAssociates1;
elseif strcmp(taskVersion, 'B') == 1
    run pairedAssociates2;
end


disp('You just ran Part 2. Run Part 3 next.');

