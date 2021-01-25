%% PART 8: 2nd block: Run memory test %%
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);
rng('shuffle');
KbName('UnifyKeyNames');

if strcmp(taskVersion, 'A') == 1
    run memTest2a;
elseif strcmp(taskVersion, 'B') == 1
    run memTest1a;
end

disp('You just ran Part 8. Run Part 9 next.');


