%% PART 4: Frequency Reports

Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);
rng('shuffle');
KbName('UnifyKeyNames');

if strcmp(taskVersion, 'A') == 1
    run frequencyReports1;
elseif strcmp(taskVersion, 'B') == 1
    run frequencyReports2;
end

disp('You just ran Part 4. Run Part 5 next. Remember, do NOT scan Part 5.');


