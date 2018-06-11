%% Script for unisensory condition %%
% Skip sync tests for demo purposes only
Screen('Preference', 'SkipSyncTests', 2);

% Open the screen + screen variables
[window, windowRect] = PsychImaging('OpenWindow', mainwindow, Color.back);

instructionText = ['In diesem Block werden dir sowohl T�ne oder Kreise pr�sentiert.'...
    '\nBitte halte deinen Blick auf dem Fixationskreuz!',...
    '\nDeine Aufgabe ist es kurze Pausen in den T�nen zu erkennen\n oder eine Farbver�nderung des Kreises.'...
    '\nNach jedem Durchgang hast du die M�glichkeit zu antworten.'...
    '\nFalls du eine der beiden Ver�nderungen wahrgenommen hast, dann dr�cke bitte die Leertaste und sei so akkurat wie m�glich.']; 

%Screen('SelectStereoDrawBuffer', window,0);
DrawFormattedText(window, instructionText, 'center', ...
    'center', Color.text);
Screen('Flip', window);
KbStrokeWait;

DrawFormattedText(window, 'Wait', 'center','center', Color.text);
Screen('Flip', window);

Screen('Flip',window);
DrawFormattedText(window,'The End. Vielen Dank f�r deine Teilnahme!','center','center');
Screen('Flip',window);

KbWait;

sca;