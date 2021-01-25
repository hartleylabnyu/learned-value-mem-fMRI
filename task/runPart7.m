%% PART 7: 2nd block: Run paired associates task %%
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);
rng('shuffle');
KbName('UnifyKeyNames');

if strcmp(taskVersion, 'A') == 1
    run pairedAssociates2;
elseif strcmp(taskVersion, 'B') == 1
    run pairedAssociates1;
end

disp('You just ran Part 7. Run Part 8 next.');

