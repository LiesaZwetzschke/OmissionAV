%% Script for unisensory condition %%
% Skip sync tests for demo purposes only
Screen('Preference', 'SkipSyncTests', 2);

% Open the screen + screen variables
[window, windowRect] = PsychImaging('OpenWindow', mainwindow, Color.back);

instructionText = ['In diesem Block werden dir sowohl Töne oder Kreise präsentiert.'...
    '\nBitte halte deinen Blick auf dem Fixationskreuz!',...
    '\nDeine Aufgabe ist es kurze Pausen in den Tönen zu erkennen\n oder eine Farbveränderung des Kreises.'...
    '\nNach jedem Durchgang hast du die Möglichkeit zu antworten.'...
    '\nFalls du eine der beiden Veränderungen wahrgenommen hast, dann drücke bitte die Leertaste und sei so akkurat wie möglich.']; 

%Screen('SelectStereoDrawBuffer', window,0);
DrawFormattedText(window, instructionText, 'center', ...
    'center', Color.text);
Screen('Flip', window);
KbStrokeWait;

DrawFormattedText(window, 'Wait', 'center','center', Color.text);
Screen('Flip', window);

Screen('Flip',window);
DrawFormattedText(window,'The End. Vielen Dank für deine Teilnahme!','center','center');
Screen('Flip',window);

KbWait;

sca;