%% PART 5: 2nd part of memory test - block 2 (SCANNER OFF) %%
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);
rng('shuffle');
KbName('UnifyKeyNames');
warning(['Do not run the scanner for this part of the experiment!']);

if strcmp(taskVersion, 'A') == 1
    run memTest2b;
elseif strcmp(taskVersion, 'B') == 1
    run memTest1b;
end

disp('You just ran Part 10. You''re done!');



