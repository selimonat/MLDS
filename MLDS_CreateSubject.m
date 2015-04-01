function [phi]=MLDS_CreateSubject(dimension,shape)
%[phi]=MLDS_CreateSubject(dimension,shape)
%
%
% Dimension is the dimensionality of the psychological scale (the subject)... For the
% one dimension case, the phi's are modelled as a power function with
% exponent = 2. In the case of two dimensional case, we have 8 points spread
% to a virtual circle with some additive noise to eliminate the equidistance
% positioning of the phi values. The distance to the center is always kept
% constant. SHAPE determines the distribution of the phi values, it must be a
% string: "random" or "power"
%
%

if dimension == 1
    
    power     = 2;
    if strcmp(shape,'power')%power function        
        phi       = ([0:7]).^power;        
    elseif strcmp(shape,'random')
        phi       = rand(1,8);
    end
    %
    phi = Scale(phi);
    
elseif dimension == 2
        
    %equally spaced angles with some random noise        
    if strcmp(shape,'random')
        angles    = linspace(0,2*pi-2*pi/8,8) + (rand(1,8)-.5).*pi/4;        
    %angles with increasing distances as a power function.    
    elseif strcmp(shape,'power')
        angles = linspace(0,2*pi-2*pi/8,8).^2;
        angles = angles./max(angles)*(2*pi-pi/8);        
    end
    %
    %THEIR PROJECTION TO THE AXES.
    phi           = [cos(angles) ; sin(angles)];    
end