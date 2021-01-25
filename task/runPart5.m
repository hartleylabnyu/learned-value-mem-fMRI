%% PART 5: 2nd part of memory test (SCANNER OFF) %%
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);
rng('shuffle');
KbName('UnifyKeyNames');
warning(['Do not run the scanner for this part of the experiment! ' ...
'Resume scanning during Part 6.']);

if strcmp(taskVersion, 'A') == 1
    run memTest1b;
elseif strcmp(taskVersion, 'B') == 1
    run memTest2b;
end


disp('You just ran Part 5. Run Part 6 next.');



