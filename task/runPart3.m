%% PART 3: Run memory test %%
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);
rng('shuffle');
KbName('UnifyKeyNames');

if strcmp(taskVersion, 'A') == 1
    run memTest1a;
elseif strcmp(taskVersion, 'B') == 1
    run memTest2a;
end


disp('You just ran Part 3. Run Part 4 next.');

