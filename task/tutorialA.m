%% RUN MEMFREQ TUTORIAL 
% This is the Version A tutorial, with cards and stamps
% clear everything
close all; clear all; clc;

%%
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);
rng('shuffle');
KbName('UnifyKeyNames');

%% Get subject information
subjectNumber = input('Enter subject number: ');
cbNumber = input('Enter counter-balance condition for first block (1 or 2): ');
cbNumber2 = input('Enter counter-balance condition for second block (1 or 2): ');
debugMode = input('Debugging mode? (0 for real experiment, 1 for debugging): ');

%% Run scripts
addpath 'tutScripts';

%create experiment constants
run tutConstantsA

%create stimulus arrays
run tutStimArraysA

%frequency tutorial
run freqPracA

%paired associates tutorial
run pairedAssociatesPracA

%memory test tutorial
run memTestPracA
