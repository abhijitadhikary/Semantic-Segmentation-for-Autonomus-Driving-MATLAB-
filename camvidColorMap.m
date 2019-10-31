function cmap = camvidColorMap()

% rgb values for each of the labels in the color map
cmap = [
    128 128 128   % sky
    128 0 0       % building
    192 192 192   % pole
    128 64 128    % road
    60 40 222     % pavement
    128 128 0     % tree
    192 128 128   % signSymbol
    64 64 128     % fence
    64 0 128      % car
    64 64 0       % pedestrian
    0 128 192     % bicyclist
    ];

% convert the rgb values which range from 0 to 255, between 0 and 1
cmap = cmap ./ 255;
end
