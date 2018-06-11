function [y] = createGabor(duration, window, position, rSize, cycles, ifi, angle, contrast)

% Default arguments
if nargin<7 || isempty(angle)
    angle = 90;
end
if nargin<8 || isempty(contrast)
    contrast = 1;
end

nFrames = duration/ifi;

% Color fixationcross
crossColor = [255 255 255];
%backColor = [0.5 0.5 0.5 0];

% Sigma of Gaussian
sigma = rSize / 7;
radius = rSize/2

% Obvious Parameters
%angle = 90;  
%contrast = 1;
aspectRatio = 1.0;
phase = 0;

% Spatial Frequency (Cycles Per Pixel)
freq = cycles / rSize;

backgroundOffset = [0.5 0.5 0.5 0];
disableNorm = 1;
contrastPreMultiplicator = 0.5;


% create Gabor grating 
[gaborid, gaborrect] = CreateProceduralSineGrating(window,rSize, rSize,...
    backgroundOffset,radius, contrastPreMultiplicator);

% Property matrix for DrawTexture
propertiesMat = [phase, freq, sigma, contrast, aspectRatio, 0, 0, 0];


% Rectangle Gabor is drawn in
desRect = [position(1)-rSize, position(2)-rSize,position(1)+rSize,position(2)+rSize]; 

topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
vbl = Screen('Flip', window);

for t = 1:nFrames;
    
    % Create gabor and fixation cross
    Screen('FillRect', window, [127 127 127]);
    Screen('DrawTexture', window, gaborid ,[] ,desRect , angle,[],[],[],[],[],...
        propertiesMat);
    DrawFormattedText(window,'+','center','center',crossColor);
    
    Screen('DrawingFinished', window);
    vbl = Screen('Flip', window, vbl + ifi/2);
    t = t+1;
end


Priority(0);

end


