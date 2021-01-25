%% PART 1: Generate needed variables and run frequency task %%
% clear everything
close all; clear all; clc;

%%
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);
rng('shuffle');
KbName('UnifyKeyNames');

%% Get subject information
subjectNumber = input('Enter subject number: ');
taskVersion = input('Enter task version (A or B): ', 's');
cbNumber = input('Enter counter-balance condition for first block (1 or 2): ');
cbNumber2 = input('Enter counter-balance condition for second block (1 or 2): ');
debugMode = input('Debugging mode? (0 for real experiment, 1 for debugging): ');


%% Add path to scripts
addpath 'scripts';

%% create experiment constants
run expConstants;
block = 1; %set block number 

%% generate stimulus arrays used in all three tasks and then run frequency task
if strcmp(taskVersion, 'A') == 1
    run stimArrays1;
    run frequency1;
elseif strcmp(taskVersion, 'B') == 1
    run stimArrays2;
    run frequency2;
end

disp('You just ran Part 1. Run Part 2 next.');
















