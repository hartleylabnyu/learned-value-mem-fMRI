%% PART 9: Frequency Reports: 2nd block

Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);
rng('shuffle');
KbName('UnifyKeyNames');

if strcmp(taskVersion, 'A') == 1
    run frequencyReports2;
elseif strcmp(taskVersion, 'B') == 1
    run frequencyReports1;
end

disp('You just ran Part 9. Run Part 10 next. Remember, do NOT scan Part 10.');


