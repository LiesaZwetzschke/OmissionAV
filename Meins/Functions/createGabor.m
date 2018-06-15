function [gaborid, desRect] = createGabor(window, position, rSize)


radius = rSize/2;


backgroundOffset = [0.5 0.5 0.5 0];
%disableNorm = 1;
contrastPreMultiplicator = 0.5;


% create Gabor grating 
[gaborid, gaborrect] = CreateProceduralSineGrating(window,rSize, rSize,...
    backgroundOffset,radius, contrastPreMultiplicator);


% Rectangle Gabor is drawn in
desRect = [position(1)-rSize, position(2)-rSize,position(1)+rSize,position(2)+rSize]; 



%     for t = 1:nFrames
%     
%         % Create gabor and fixation cross
%         Screen('FillRect', window, color);
%         Screen('DrawTexture', window, gaborid ,[] ,desRect , angle,[],[],[],[],[],...
%             propertiesMat);
%         DrawFormattedText(window,'+','center','center',crossColor);
% 
%         Screen('DrawingFinished', window);
%         vbl = Screen('Flip', window, vbl + ifi/2);
%     
%     end



end