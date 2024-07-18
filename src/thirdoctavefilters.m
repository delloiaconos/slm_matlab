function [ thirdOctaveFilterBank, centralFrequencies ] = thirdoctavefilters( varargin )
    % This function returns a bank of third octave filters according to 
    % ANSI S1.11-2004

    % Local Fields
    locVars = [ "bandsPerOctave", "filterOrder", "centralF", "fs" ];

    % Default Settings
    bandsPerOctave = 3;
    filterOrder = 6;
    centralF = 1000;
    fs = 48000;

    % Check if any field is present
    vkindex = [];
    for idx=1:length(locVars)
        var = locVars(idx);
        loc =  find( cellfun(@(v) ( isstring(v) || ischar(v) ) && strcmpi( var, v ), varargin ) );
        if ~isempty(loc) && ~ismember(loc, vkindex) && (loc <= nargin-1) 
            eval( fprintf( "%s = varargin{loc+1};", var ) );
            vkindex = [vkindex loc loc+1];
        end
    end

    % Third octave band filter design

    thirdOctaveFilter = fdesign.octave(bandsPerOctave, 'Class 0', 'N,F0', ...
        filterOrder, centralF, fs);

    % Obtenemos las frecuencias centrales en el rango audible

    centralFrequencies = validfrequencies(thirdOctaveFilter);
    numCentralFrequencies = length(centralFrequencies);

    for i=1:numCentralFrequencies
        thirdOctaveFilter.F0 = centralFrequencies(i);
        thirdOctaveFilterBank(i) = design(thirdOctaveFilter,'butter');
    end

    % filter visualization

    %fvtool(thirdOctaveFilterBank(17),'FrequencyScale','log','Color','white');
    %axis([0.1 24 -90 5])
    %title('1/3 octave filter')

end

